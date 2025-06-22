import 'dart:io'; // Wichtig für FileImage
import 'package:flutter/material.dart';
import 'package:gig_hub/src/Data/database_repository.dart';
import 'package:gig_hub/src/Data/user.dart' as repo;
import 'package:gig_hub/src/Theme/palette.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final DatabaseRepository _databaseRepository = MockDatabaseRepository();
  repo.AppUser? _currentUser;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = await _databaseRepository.getUserById("dj_lorem");
    if (mounted) {
      setState(() {
        _currentUser = user;
        _emailController.text = _currentUser?.email ?? "";
      });
    }
  }

  String? validateEmail(String? input) {
    if (input == null || input.isEmpty) return "can't be empty";
    if (input.length < 5) return "enter full address";
    if (!input.contains('@') || !input.contains('.')) return "invalid input";
    if (input.startsWith('@') || input.endsWith('@')) return "invalid input";
    if (input.contains(' ')) return "can't contain space";
    final parts = input.split('@');
    if (parts.length != 2) return "invalid input";
    final local = parts[0];
    final domain = parts[1];
    if (local.isEmpty) return "invalid input";
    if (!domain.contains('.')) return "invalid domain";
    final domainParts = domain.split('.');
    if (domainParts.any((part) => part.length < 2)) return "invalid domain";
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.primalBlack,
      body: Center(
        child: Column(
          spacing: 16,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.chevron_left_rounded, size: 36),
                color: Palette.glazedWhite,
              ),
            ),
            Hero(
              tag: context,
              child: Image.asset("assets/images/gighub_logo.png"),
            ),
            const SizedBox(height: 24),
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Palette.glazedWhite, width: 1.5),
                  ),
                  child: CircleAvatar(
                    radius: 64,
                    backgroundImage:
                        _pickedImage != null
                            ? FileImage(File(_pickedImage!.path))
                            : (_currentUser?.avatarUrl.startsWith('http') ==
                                        true
                                    ? NetworkImage(_currentUser!.avatarUrl)
                                    : FileImage(File(_currentUser!.avatarUrl)))
                                as ImageProvider,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final picked = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (picked != null) {
                        setState(() {
                          _pickedImage = picked;
                          _currentUser?.avatarUrl = picked.path;
                        });
                      }
                    },
                    icon: Icon(
                      Icons.upload_file_rounded,
                      color: Palette.shadowGrey,
                      size: 32,
                      shadows: [
                        BoxShadow(
                          blurRadius: 2,
                          blurStyle: BlurStyle.inner,
                          color: Palette.primalBlack,
                          spreadRadius: 2,
                          offset: Offset(0.6, 0.6),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  " change e-mail",
                  style: GoogleFonts.sometypeMono(
                    textStyle: TextStyle(
                      color: Palette.glazedWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.always,
                      validator: validateEmail,
                      keyboardType: TextInputType.emailAddress,
                      onFieldSubmitted: (newValue) {
                        if (_formKey.currentState!.validate() &&
                            _currentUser != null) {
                          _currentUser!.updateEmail(_currentUser!, newValue);
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
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        helperText: "press enter when finished",
                        labelStyle: TextStyle(color: Palette.primalBlack),
                        suffixIcon: IconButton(
                          onPressed: () => _emailController.clear(),
                          icon: const Icon(Icons.delete),
                        ),
                        fillColor: Palette.glazedWhite,
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: "press enter when done",
                        hintStyle: TextStyle(color: Palette.forgedGold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {},
              child: const Text("change password"),
            ),
            FilledButton(onPressed: () {}, child: const Text("blocked users")),
            FilledButton(onPressed: () {}, child: const Text("delete account")),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 24, 12),
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
