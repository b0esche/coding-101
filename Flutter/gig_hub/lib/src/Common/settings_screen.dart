import 'package:flutter/material.dart';
import 'package:gig_hub/src/Theme/palette.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.primalBlack,
      body: Center(
        child: Column(
          spacing: 40,
          children: [
            SizedBox(),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: Navigator.of(context).pop,
                icon: Icon(Icons.chevron_left_rounded, size: 48),
                color: Palette.glazedWhite,
              ),
            ),

            Hero(
              tag: context,
              child: Image.asset("assets/images/gighub_logo.png"),
            ),

            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Palette.glazedWhite, width: 1.5),
                  ),
                  child: CircleAvatar(
                    radius: 64,
                    backgroundImage: AssetImage(
                      "assets/images/default_avatar.jpg",
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: () {
                      debugPrint("hier avatar ändern");
                    },
                    icon: Icon(
                      Icons.upload_file_rounded,
                      color: Palette.gigGrey,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),

                  labelText: "change e-mail",
                  labelStyle: TextStyle(color: Palette.primalBlack),
                  alignLabelWithHint: true,
                  suffixIcon: Icon(Icons.delete),
                  fillColor: Palette.glazedWhite,
                  filled: true,
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                debugPrint("hier passwort ändern");
              },
              child: Text("change password"),
            ),
            FilledButton(
              onPressed: () {
                debugPrint("hier account löschen");
              },
              child: Text("delete account"),
            ),
            FilledButton(
              onPressed: () {
                debugPrint("hier blockliste öffnen und bearbeiten");
              },
              child: Text("blocked users"),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 24, 0),
                child: Text(
                  "version 1.0.0 alpha",
                  style: TextStyle(color: Palette.glazedWhite),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
