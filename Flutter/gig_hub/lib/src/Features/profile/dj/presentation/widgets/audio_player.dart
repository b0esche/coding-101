import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:gig_hub/src/Data/services/audio_service.dart';
import 'package:gig_hub/src/Theme/palette.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerWidget({super.key, required this.audioUrl});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final AudioService _audioService = AudioService.instance;

  bool _isLoading = true;
  bool _isPlaying = false;
  bool _hasFinished = false;

  Duration? _duration;
  Duration _position = Duration.zero;
  List<double> _waveformData = [];

  late StreamSubscription<PlayerState> _playerStateSubscription;
  late StreamSubscription<Duration> _positionSubscription;
  late StreamSubscription<Duration?> _durationSubscription;
  late StreamSubscription<bool> _loadingSubscription;
  late StreamSubscription<List<double>> _waveformSubscription;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 650),
      vsync: this,
    );

    _setupSubscriptions();
    _loadTrack();
  }

  void _setupSubscriptions() {
    // Subscribe to loading state
    _loadingSubscription = _audioService.loadingStream.listen((isLoading) {
      if (mounted) {
        setState(() => _isLoading = isLoading);
      }
    });

    // Subscribe to waveform data
    _waveformSubscription = _audioService.waveformStream.listen((waveformData) {
      if (mounted) {
        setState(() => _waveformData = waveformData);
      }
    });

    // Subscribe to player state
    _playerStateSubscription = _audioService.player.playerStateStream.listen((
      state,
    ) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
          _hasFinished = state.processingState == ProcessingState.completed;
        });

        // Sync animation controller with player state
        if (state.playing) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      }
    });

    // Subscribe to position
    _positionSubscription = _audioService.player.positionStream.listen((
      position,
    ) {
      if (mounted) {
        setState(() => _position = position);
      }
    });

    // Subscribe to duration
    _durationSubscription = _audioService.player.durationStream.listen((
      duration,
    ) {
      if (mounted) {
        setState(() => _duration = duration);
      }
    });
  }

  Future<void> _loadTrack() async {
    try {
      await _audioService.loadTrack(widget.audioUrl);

      // Set initial waveform data if available
      if (mounted) {
        setState(() {
          _waveformData = _audioService.currentWaveformData;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      debugPrint('Error loading track: $e');
    }
  }

  @override
  void dispose() {
    _playerStateSubscription.cancel();
    _positionSubscription.cancel();
    _durationSubscription.cancel();
    _loadingSubscription.cancel();
    _waveformSubscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioService.player.pause();
    } else {
      if (_hasFinished) {
        await _audioService.player.seek(Duration.zero);
        _hasFinished = false;
      }
      await _audioService.player.play();
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
                      child: CustomWaveformWidget(
                        waveformData: _waveformData,
                        progress:
                            _duration != null && _duration!.inMilliseconds > 0
                                ? _position.inMilliseconds /
                                    _duration!.inMilliseconds
                                : 0.0,
                        onSeek: (progress) async {
                          if (_duration != null) {
                            final position = Duration(
                              milliseconds:
                                  (_duration!.inMilliseconds * progress)
                                      .round(),
                            );
                            await _audioService.player.seek(position);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}

// Custom waveform widget that looks like the original but performs much better
class CustomWaveformWidget extends StatelessWidget {
  final List<double> waveformData;
  final double progress;
  final Function(double) onSeek;

  const CustomWaveformWidget({
    super.key,
    required this.waveformData,
    required this.progress,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final progress = details.localPosition.dx / box.size.width;
        onSeek(progress.clamp(0.0, 1.0));
      },
      child: CustomPaint(
        size: Size(370, 85),
        painter: WaveformPainter(
          waveformData: waveformData,
          progress: progress,
          fixedWaveColor: Palette.gigGrey.o(0.65),
          liveWaveColor: Palette.forgedGold,
        ),
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final List<double> waveformData;
  final double progress;
  final Color fixedWaveColor;
  final Color liveWaveColor;

  WaveformPainter({
    required this.waveformData,
    required this.progress,
    required this.fixedWaveColor,
    required this.liveWaveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (waveformData.isEmpty) {
      // Draw placeholder bars if no waveform data
      _drawPlaceholderWaveform(canvas, size);
      return;
    }

    final paint =
        Paint()
          ..strokeCap = StrokeCap.butt
          ..strokeWidth = 2.65;

    final barWidth = 3.65;
    final barSpacing = 3.65;
    final totalBars = (size.width / (barWidth + barSpacing)).floor();
    final progressBarIndex = (totalBars * progress).round();

    for (int i = 0; i < totalBars && i < waveformData.length; i++) {
      final barHeight = (waveformData[i] * size.height * 0.8).clamp(
        2.0,
        size.height,
      );
      final x = i * (barWidth + barSpacing);
      final y = (size.height - barHeight) / 2;

      paint.color = i <= progressBarIndex ? liveWaveColor : fixedWaveColor;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, barHeight),
          Radius.circular(1),
        ),
        paint,
      );
    }
  }

  void _drawPlaceholderWaveform(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..strokeCap = StrokeCap.butt
          ..strokeWidth = 2.65
          ..color = fixedWaveColor;

    final barWidth = 3.65;
    final barSpacing = 3.65;
    final totalBars = (size.width / (barWidth + barSpacing)).floor();

    for (int i = 0; i < totalBars; i++) {
      final normalizedHeight = 0.3 + (0.7 * sin(i * 0.1));
      final barHeight = (normalizedHeight * size.height * 0.8).clamp(
        2.0,
        size.height,
      );
      final x = i * (barWidth + barSpacing);
      final y = (size.height - barHeight) / 2;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth, barHeight),
          Radius.circular(1),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
