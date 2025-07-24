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

class _AudioPlayerWidgetState extends State<AudioPlayerWidget>
    with TickerProviderStateMixin {
  late PlayerController _playerController;
  late AnimationController _controller;

  bool _isLoading = true;
  bool _isPlaying = false;
  bool _hasFinished = false;

  late StreamSubscription<PlayerState> _stateSub;
  late StreamSubscription<void> _completeSub;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 650),
      vsync: this,
    );

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
    _controller.dispose();
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
      padding: const EdgeInsets.only(top: 4, bottom: 4, right: 4),
      child:
          _isLoading
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 8),
                  child: SizedBox.square(
                    dimension: 28,
                    child: CircularProgressIndicator(
                      color: Palette.forgedGold,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await _togglePlayPause();
                      if (_playerController.playerState.isPlaying) {
                        _controller.forward();
                      } else {
                        _controller.reverse();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Palette.shadowGrey.o(0.65),
                            width: 1.65,
                          ),
                        ),
                        child: AnimatedIcon(
                          icon: AnimatedIcons.play_pause,
                          progress: _controller,
                          size: 28,
                          color: Palette.forgedGold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 280,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: AudioFileWaveforms(
                        size: Size(360, 85),
                        playerController: _playerController,
                        waveformType: WaveformType.fitWidth,
                        animationCurve: Curves.easeInOutBack,
                        animationDuration: Duration(milliseconds: 1200),
                        playerWaveStyle: PlayerWaveStyle(
                          fixedWaveColor: Palette.gigGrey.o(0.65),
                          liveWaveColor: Palette.forgedGold,
                          spacing: 3.65,
                          // scrollScale: 1.35,
                          waveThickness: 2.65,
                          scaleFactor: 85,
                          waveCap: StrokeCap.butt,
                          // seekLineColor: Palette.glazedWhite.o(0.85),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
