import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:gig_hub/src/Theme/palette.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl; // can be local path or remote URL

  const AudioPlayerWidget({super.key, required this.audioUrl});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late final PlayerController _playerController;
  bool _isLoading = true;
  bool _isPlaying = false;
  bool _hasPlayed = false;

  @override
  void initState() {
    super.initState();
    _playerController = PlayerController();
    _init();
    _playerController.onPlayerStateChanged.listen((state) {
      setState(() => _isPlaying = state.isPlaying);
    });
  }

  Future<void> _init() async {
    String path;
    if (widget.audioUrl.startsWith('http')) {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/temp_audio.mp3');
      final bytes = (await http.get(Uri.parse(widget.audioUrl))).bodyBytes;
      await file.writeAsBytes(bytes);
      path = file.path;
    } else {
      path = widget.audioUrl;
    }

    await _playerController.preparePlayer(
      path: path,
      shouldExtractWaveform: true,
    );
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _playerController.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _playerController.pausePlayer();
    } else {
      if (_hasPlayed) {
        await _playerController.seekTo(0);
      }
      await _playerController.startPlayer();
      _hasPlayed = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.primalBlack,
      padding: const EdgeInsets.all(4),
      child:
          _isLoading
              ? Center(
                child: CircularProgressIndicator(
                  color: Palette.forgedGold,
                  strokeWidth: 2,
                  constraints: BoxConstraints.tight(Size(24, 24)),
                ),
              )
              : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    iconSize: 48,
                    color: Palette.glazedWhite,
                    icon: Icon(
                      _isPlaying ? Icons.pause_circle : Icons.play_circle,
                    ),
                    onPressed: _togglePlayPause,
                  ),
                  AudioFileWaveforms(
                    size: Size(260, 80),
                    playerController: _playerController,
                    waveformType: WaveformType.fitWidth,
                    playerWaveStyle: PlayerWaveStyle(
                      fixedWaveColor: Palette.gigGrey,
                      liveWaveColor: Palette.forgedGold,
                      spacing: 4,
                      waveThickness: 2,
                      scaleFactor: 200,
                    ),
                  ),
                ],
              ),
    );
  }
}
