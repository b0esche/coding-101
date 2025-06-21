import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gig_hub/src/Theme/palette.dart';

class PasteButton extends StatelessWidget {
  const PasteButton({
    super.key,
    required TextEditingController soundcloudController,
  }) : _soundcloudController = soundcloudController;

  final TextEditingController _soundcloudController;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: ButtonStyle(splashFactory: NoSplash.splashFactory),
      icon: Icon(Icons.paste_rounded, color: Palette.forgedGold, size: 20),
      onPressed: () async {
        final data = await Clipboard.getData(Clipboard.kTextPlain);
        if (data != null && data.text != null) {
          _soundcloudController.text = data.text!;
        }
      },
    );
  }
}

class RemoveButton extends StatelessWidget {
  const RemoveButton({
    super.key,
    required TextEditingController soundcloudController,
  }) : _soundcloudController = soundcloudController;

  final TextEditingController _soundcloudController;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: ButtonStyle(splashFactory: NoSplash.splashFactory),
      onPressed: _soundcloudController.clear,
      icon: Icon(Icons.close, color: Palette.glazedWhite, size: 18),
    );
  }
}
