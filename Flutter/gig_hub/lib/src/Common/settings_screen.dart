import 'package:flutter/material.dart';
import 'package:gig_hub/src/Data/database_repository.dart';
import 'package:gig_hub/src/Data/user.dart' as repo;
import 'package:gig_hub/src/Theme/palette.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final DatabaseRepository _databaseRepository = MockDatabaseRepository();

  repo.AppUser? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() async {
    _currentUser = _databaseRepository.getUserById("dj_lorem");
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController(
      text: _currentUser?.email ?? "",
    );
    return Scaffold(
      backgroundColor: Palette.primalBlack,
      body: Center(
        child: Column(
          spacing: 36,
          children: [
            const SizedBox(),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: Navigator.of(context).pop,
                icon: const Icon(Icons.chevron_left_rounded, size: 36),
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
                  child: const CircleAvatar(
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  " change e-Mail",
                  style: GoogleFonts.sometypeMono(
                    textStyle: TextStyle(
                      color: Palette.glazedWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    onFieldSubmitted: (newValue) {
                      if (_currentUser != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Palette.forgedGold,
                            content: Center(
                              child: Text(
                                "email updated! please verify.",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        );
                      }
                    },

                    onChanged: (value) {
                      if (_currentUser != null) {
                        _currentUser?.updateEmail(_currentUser, value);
                      }
                    },
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),

                      helperText: "press enter when finished",
                      labelStyle: TextStyle(color: Palette.primalBlack),

                      suffixIcon: IconButton(
                        onPressed: () {
                          emailController.clear();
                        },
                        icon: Icon(Icons.delete),
                      ),
                      fillColor: Palette.glazedWhite,
                      filled: true,
                      alignLabelWithHint: true,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: "press enter when finished",
                      hintStyle: TextStyle(color: Palette.forgedGold),
                    ),
                  ),
                ),
              ],
            ),
            FilledButton(
              onPressed: () {
                debugPrint("hier passwort ändern");
              },
              child: const Text("change password"),
            ),
            FilledButton(
              onPressed: () {
                debugPrint("hier account löschen");
              },
              child: const Text("delete account"),
            ),
            FilledButton(
              onPressed: () {
                debugPrint("hier blockliste öffnen und bearbeiten");
              },
              child: const Text("blocked users"),
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
