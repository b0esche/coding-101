import 'package:gig_hub/src/Data/app_imports.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  PlayerController? _current;

  Future<void> play(PlayerController controller) async {
    if (_current != null && _current != controller) {
      await _current!.pausePlayer();
    }
    _current = controller;
    await controller.startPlayer();
  }

  Future<void> pause(PlayerController controller) async {
    await controller.pausePlayer();
  }
}
