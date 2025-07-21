import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:gig_hub/src/Features/profile/dj/domain/audio_manager.dart';
import 'package:gig_hub/src/Features/profile/dj/domain/soundcloud_service.dart';
import 'package:gig_hub/src/Theme/palette.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;
  final PlayerController playerController;

  const AudioPlayerWidget({
    super.key,
    required this.audioUrl,
    required this.playerController,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late PlayerController _playerController;

  bool _isLoading = true;
  bool _isPlaying = false;
  bool _hasFinished = false;

  late StreamSubscription<PlayerState> _stateSub;
  late StreamSubscription<void> _completeSub;

  @override
  void initState() {
    super.initState();

    _playerController = widget.playerController;

    _stateSub = _playerController.onPlayerStateChanged.listen((state) {
      setState(() => _isPlaying = state.isPlaying);
    });

    _completeSub = _playerController.onCompletion.listen((_) {
      setState(() => _hasFinished = true);
    });

    _init();
  }

  Future<void> _init() async {
    try {
      String urlToStream = widget.audioUrl;

      final publicUrl = await SoundcloudService().getPublicStreamUrl(
        urlToStream,
      );

      if (publicUrl.isEmpty) {
        throw Exception('invalid audio file from server');
      }

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${publicUrl.hashCode}.mp3');

      final bytes = (await http.get(Uri.parse(publicUrl))).bodyBytes;
      await file.writeAsBytes(bytes);

      await _playerController.preparePlayer(
        path: file.path,
        shouldExtractWaveform: true,
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
    } catch (e) {
      throw Exception('error while loading player: $e');
    }
  }

  @override
  void dispose() {
    _stateSub.cancel();
    _completeSub.cancel();
    _playerController.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await AudioManager().pause(_playerController);
    } else {
      if (_hasFinished) {
        await _playerController.seekTo(0);
        _hasFinished = false;
      }

      await AudioManager().play(_playerController);
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
                ),
              )
              : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    iconSize: 48,
                    icon: Icon(
                      _isPlaying ? Icons.pause_circle : Icons.play_circle,
                      color: Palette.glazedWhite,
                    ),
                    onPressed: _togglePlayPause,
                  ),
                  AudioFileWaveforms(
                    size: const Size(260, 85),
                    playerController: _playerController,
                    waveformType: WaveformType.long,
                    animationCurve: Curves.easeInOutBack,
                    animationDuration: Duration(milliseconds: 1200),
                    playerWaveStyle: PlayerWaveStyle(
                      fixedWaveColor: Palette.gigGrey.o(0.65),
                      liveWaveColor: Palette.forgedGold,
                      spacing: 4,
                      waveThickness: 2,
                      scaleFactor: 75,
                      waveCap: StrokeCap.butt,
                    ),
                  ),
                ],
              ),
    );
  }
}
