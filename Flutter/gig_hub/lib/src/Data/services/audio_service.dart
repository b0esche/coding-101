import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:just_waveform/just_waveform.dart';
import 'package:gig_hub/src/data/services/soundcloud_service.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/// Singleton audio service that manages a single AudioPlayer instance
/// for compatibility with just_audio_background
class AudioService {
  static AudioService? _instance;
  static AudioService get instance => _instance ??= AudioService._();

  AudioService._();

  late final AudioPlayer _audioPlayer;
  bool _isInitialized = false;

  // Current track info
  String? _currentTrackUrl;
  List<double> _currentWaveformData = [];

  // Streams for UI updates
  final StreamController<bool> _loadingController =
      StreamController<bool>.broadcast();
  final StreamController<List<double>> _waveformController =
      StreamController<List<double>>.broadcast();

  // Getters for the UI
  AudioPlayer get player => _audioPlayer;
  Stream<bool> get loadingStream => _loadingController.stream;
  Stream<List<double>> get waveformStream => _waveformController.stream;
  List<double> get currentWaveformData => _currentWaveformData;
  String? get currentTrackUrl => _currentTrackUrl;

  Future<void> initialize() async {
    if (_isInitialized) return;

    _audioPlayer = AudioPlayer();
    _isInitialized = true;
  }

  Future<void> loadTrack(String audioUrl) async {
    if (!_isInitialized) await initialize();

    // Don't reload the same track
    if (_currentTrackUrl == audioUrl) return;

    _currentTrackUrl = audioUrl;
    _loadingController.add(true);

    try {
      final publicUrl = await SoundcloudService().getPublicStreamUrl(audioUrl);

      if (publicUrl.isEmpty) {
        throw Exception('invalid audio file from server');
      }

      // Try direct streaming first for instant playback
      try {
        final audioSource = AudioSource.uri(
          Uri.parse(publicUrl),
          tag: MediaItem(
            id: publicUrl.hashCode.toString(),
            album: "GigHub",
            title: "DJ Track Preview",
            artist: "Unknown Artist",
            artUri: Uri.parse(
              'https://via.placeholder.com/300x300/1a1a1a/ffd700?text=🎵',
            ),
            duration: null,
          ),
        );

        await _audioPlayer.setAudioSource(audioSource);
        _loadingController.add(false);

        // Show simple waveform immediately
        _showSimpleWaveform();

        // Extract real waveform in background
        _downloadAndExtractWaveformInBackground(publicUrl);
      } catch (e) {
        debugPrint('Direct streaming failed, falling back to download: $e');
        await _downloadAndSetupPlayer(publicUrl);
      }
    } catch (e) {
      _loadingController.add(false);
      debugPrint('Error while loading track: $e');
      rethrow;
    }
  }

  void _showSimpleWaveform() {
    _currentWaveformData = List.generate(
      100,
      (i) => 0.2 + (0.6 * sin(i * 0.15)) + (0.2 * sin(i * 0.05)),
    );
    _waveformController.add(_currentWaveformData);
  }

  Future<void> _downloadAndSetupPlayer(String publicUrl) async {
    final dir = await getTemporaryDirectory();
    final filePath = '${dir.path}/${publicUrl.hashCode}.mp3';

    // Download in isolate
    final savedFilePath = await compute(_downloadAudio, {
      'publicUrl': publicUrl,
      'filePath': filePath,
    });

    final audioSource = AudioSource.uri(
      Uri.file(savedFilePath),
      tag: MediaItem(
        id: savedFilePath.hashCode.toString(),
        album: "GigHub",
        title: "DJ Track Preview",
        artist: "Unknown Artist",
        artUri: Uri.parse(
          'https://via.placeholder.com/300x300/1a1a1a/ffd700?text=🎵',
        ),
        duration: null,
      ),
    );

    await _audioPlayer.setAudioSource(audioSource);
    _loadingController.add(false);

    // Extract waveform
    _extractWaveform(savedFilePath);
  }

  Future<void> _downloadAndExtractWaveformInBackground(String publicUrl) async {
    try {
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/${publicUrl.hashCode}.mp3';

      if (!await File(filePath).exists()) {
        await compute(_downloadAudio, {
          'publicUrl': publicUrl,
          'filePath': filePath,
        });
      }

      _extractWaveform(filePath);
    } catch (e) {
      debugPrint('Background waveform extraction failed: $e');
    }
  }

  Future<void> _extractWaveform(String filePath) async {
    try {
      final file = File(filePath);
      final fileSize = await file.length();
      const maxSizeForFullWaveform = 2000 * 1024 * 1024; // 2000MB

      if (fileSize > maxSizeForFullWaveform) {
        debugPrint('File too large, skipping waveform extraction');
        return;
      }

      final progressStream = JustWaveform.extract(
        audioInFile: file,
        waveOutFile: File('$filePath.wave'),
        zoom: const WaveformZoom.pixelsPerSecond(5),
      );

      await progressStream.timeout(Duration(seconds: 60)).listen((progress) {
        if (progress.waveform != null) {
          _currentWaveformData = _normalizeWaveformData(
            progress.waveform!.data.map((e) => e.toDouble()).toList(),
          );
          _waveformController.add(_currentWaveformData);
        }
      }).asFuture();
    } catch (e) {
      debugPrint('Waveform extraction failed: $e');
    }
  }

  List<double> _normalizeWaveformData(List<double> data) {
    if (data.isEmpty) return [];

    final maxValue = data.map((v) => v.abs()).reduce(max);
    if (maxValue == 0) return List.filled(data.length, 0.0);

    const maxPoints = 500;
    if (data.length > maxPoints) {
      final step = data.length / maxPoints;
      final List<double> downsampled = [];
      for (int i = 0; i < maxPoints; i++) {
        final index = (i * step).round();
        if (index < data.length) {
          downsampled.add(data[index].abs() / maxValue);
        }
      }
      return downsampled;
    }

    return data.map((v) => v.abs() / maxValue).toList();
  }

  Future<void> dispose() async {
    if (_isInitialized) {
      await _audioPlayer.dispose();
      _isInitialized = false;
    }
    await _loadingController.close();
    await _waveformController.close();
    _instance = null;
  }

  // Static function for isolate
  static Future<String> _downloadAudio(Map<String, dynamic> params) async {
    final String publicUrl = params['publicUrl'];
    final String filePath = params['filePath'];

    final request = http.Request('GET', Uri.parse(publicUrl));
    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('failed to download audio');
    }

    final file = File(filePath);
    final sink = file.openWrite();

    try {
      int bytesWritten = 0;
      const yieldInterval = 128 * 1024;

      await for (final chunk in response.stream) {
        sink.add(chunk);
        bytesWritten += chunk.length;

        if (bytesWritten % yieldInterval == 0) {
          await Future.delayed(Duration.zero);
        }
      }

      await sink.flush();
    } finally {
      await sink.close();
    }

    return filePath;
  }
}
