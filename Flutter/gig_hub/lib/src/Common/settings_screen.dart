import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gig_hub/src/Data/app_imports.dart';
import 'package:gig_hub/src/Data/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gig_hub/src/Data/firestore_repository.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  AppUser? _user;
  XFile? _pickedImage;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final db = FirestoreDatabaseRepository();

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = await db.getCurrentUser();
    setState(() {
      _user = user;
      _emailController.text = FirebaseAuth.instance.currentUser?.email ?? '';
    });
  }

  Future<void> _pickNewImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null && _user != null) {
      final file = File(picked.path);
      final storageRef = FirebaseStorage.instance.ref().child(
        'avatars/${_user!.id}.jpg',
      );

      try {
        final uploadTask = await storageRef.putFile(file);
        final downloadUrl = await uploadTask.ref.getDownloadURL();

        setState(() {
          _pickedImage = picked;

          if (_user is DJ) {
            (_user as DJ).avatarImageUrl = downloadUrl;
          } else if (_user is Booker) {
            (_user as Booker).avatarImageUrl = downloadUrl;
          }
        });

        await db.updateUser(_user!);
      } catch (e) {
        debugPrint('❌ Fehler beim Hochladen oder Speichern: $e');
      }
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

  Future<void> _onEmailSubmitted(String newValue) async {
    if (_formKey.currentState?.validate() != true) return;

    final user = FirebaseAuth.instance.currentUser;
    final messenger = ScaffoldMessenger.of(context);
    if (user == null) return;

    final password = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final passwordController = TextEditingController();
        final formKey = GlobalKey<FormState>();

        return AlertDialog(
          title: Center(
            child: const Text(
              'enter your password',
              style: TextStyle(fontSize: 16),
            ),
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: passwordController,
              obscureText: true,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'password',

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator:
                  (value) =>
                      (value == null || value.isEmpty)
                          ? 'password neccessary'
                          : null,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text(
                'cancel',
                style: TextStyle(color: Palette.primalBlack),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  Navigator.of(context).pop(passwordController.text);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.shadowGrey,
                splashFactory: NoSplash.splashFactory,
                maximumSize: const Size(150, 24),
                minimumSize: const Size(88, 22),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: Palette.concreteGrey.o(0.7),
                    width: 1.5,
                  ),
                ),
                elevation: 3,
              ),
              child: Text(
                'proceed',
                style: TextStyle(color: Palette.primalBlack),
              ),
            ),
          ],
        );
      },
    );

    if (password == null) {
      return;
    }

    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);

      await user.verifyBeforeUpdateEmail(newValue);

      messenger.showSnackBar(
        SnackBar(
          backgroundColor: Palette.forgedGold,
          content: const Center(
            child: Text(
              "email reset link was sent to your current email!",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Center(
            child: Text(
              'error: ${e.toString()}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      );
    }
  }

  Future<void> _onResetPassword() async {
    final email = FirebaseAuth.instance.currentUser?.email;
    final messenger = ScaffoldMessenger.of(context);
    if (email != null) {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: Palette.forgedGold,
          content: Center(
            child: Text("reset email sent!", style: TextStyle(fontSize: 16)),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthRepository>();
    if (_user == null) {
      return Scaffold(
        backgroundColor: Palette.primalBlack,
        body: Center(
          child: CircularProgressIndicator(color: Palette.forgedGold),
        ),
      );
    } else {
      final hasAvatar = _user is DJ || _user is Booker;
      final avatarUrl =
          hasAvatar
              ? (_user is DJ
                  ? (_user as DJ).avatarImageUrl
                  : (_user as Booker).avatarImageUrl)
              : null;

      final ImageProvider? avatarProvider =
          _pickedImage != null
              ? FileImage(File(_pickedImage!.path))
              : (hasAvatar
                      ? (avatarUrl != null && avatarUrl.startsWith('http')
                          ? NetworkImage(avatarUrl)
                          : FileImage(File(avatarUrl!)))
                      : null)
                  as ImageProvider?;

      return Scaffold(
        backgroundColor: Palette.primalBlack,
        body: Center(
          child: Column(
            spacing: 20,
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
              if (hasAvatar && avatarProvider != null)
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Palette.glazedWhite,
                          width: 1.5,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 64,
                        backgroundImage: avatarProvider,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: _pickNewImage,
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
              const SizedBox(height: 4),
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
                        onFieldSubmitted: _onEmailSubmitted,
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
              FilledButton(
                onPressed: _onResetPassword,
                child: const Text("reset password"),
              ),
              FilledButton(
                onPressed: () {
                  // TODO: blocked users page
                },
                child: const Text("blocked users"),
              ),
              FilledButton(
                onPressed: () {
                  // TODO: delete account logic
                },
                child: const Text("delete account"),
              ),
              FilledButton(
                onPressed: () {
                  auth.signOut();
                  Navigator.of(context).pop();
                },
                child: const Text("log out"),
              ),
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
}
