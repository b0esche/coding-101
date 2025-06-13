import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:gig_hub/src/Features/profile/dj/domain/audio_manager.dart';
import 'package:gig_hub/src/Theme/palette.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;
  const AudioPlayerWidget({super.key, required this.audioUrl});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late final PlayerController _playerController;
  bool _isLoading = true;
  bool _isPlaying = false;
  bool _hasFinished = false;
  late StreamSubscription<PlayerState> _stateSub;
  late StreamSubscription<void> _completeSub;

  @override
  void initState() {
    super.initState();
    _playerController = PlayerController();
    _init();
    _stateSub = _playerController.onPlayerStateChanged.listen((state) {
      setState(() => _isPlaying = state.isPlaying);
    });
    _completeSub = _playerController.onCompletion.listen((_) {
      _hasFinished = true;
    });
  }

  Future<void> _init() async {
    String path;
    if (widget.audioUrl.startsWith('http')) {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${widget.audioUrl.hashCode}.mp3');
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
                    size: const Size(260, 80),
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
