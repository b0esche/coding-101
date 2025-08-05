import 'package:flutter_localization/flutter_localization.dart';
import 'package:gig_hub/src/Data/app_imports.dart';
import 'package:gig_hub/src/Data/services/localization_service.dart';
import 'package:gig_hub/src/Common/widgets/blocked_users_dialog.dart';

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

  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
    {'code': 'de', 'name': 'Deutsch', 'flag': '🇩🇪'},
    {'code': 'es', 'name': 'Español', 'flag': '🇪🇸'},
    {'code': 'it', 'name': 'Italiano', 'flag': '🇮🇹'},
    {'code': 'pt', 'name': 'Português', 'flag': '🇵🇹'},
    {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
    {'code': 'nl', 'name': 'Nederlands', 'flag': '🇳🇱'},
    {'code': 'pl', 'name': 'Polski', 'flag': '🇵🇱'},
    {'code': 'uk', 'name': 'Українська', 'flag': '🇺🇦'},
    {'code': 'ar', 'name': 'العربية', 'flag': '🇸🇦'},
    {'code': 'tr', 'name': 'Türkçe', 'flag': '🇹🇷'},
    {'code': 'ja', 'name': '日本語', 'flag': '🇯🇵'},
    {'code': 'ko', 'name': '한국어', 'flag': '🇰🇷'},
    {'code': 'zh', 'name': '中文', 'flag': '🇨🇳'},
  ];

  String _currentLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _currentLanguage =
        FlutterLocalization.instance.currentLocale?.languageCode ?? 'en';
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = await db.getCurrentUser();
    setState(() {
      _user = user;
      _emailController.text = FirebaseAuth.instance.currentUser?.email ?? '';
    });
  }

  Future<File> compressImage(File file) async {
    final tempDir = await getTemporaryDirectory();
    final targetPath = '${tempDir.path}/${const Uuid().v4()}.jpg';

    final compressedBytes = await FlutterImageCompress.compressWithFile(
      file.path,
      quality: 60,
      format: CompressFormat.jpeg,
    );
    if (mounted) {
      if (compressedBytes == null) {
        throw Exception(AppLocale.imgCompressionFailed.getString(context));
      }
    }
    if (compressedBytes != null) {
      final compressedFile = File(targetPath);
      await compressedFile.writeAsBytes(compressedBytes);

      return compressedFile;
    }
    return file;
  }

  Future<void> _pickNewImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null && _user != null) {
      final originalFile = File(picked.path);
      final compressedFile = await compressImage(originalFile);

      final storageRef = FirebaseStorage.instance.ref().child(
        'avatars/${_user!.id}.jpg',
      );

      try {
        final uploadTask = await storageRef.putFile(
          compressedFile,
          SettableMetadata(
            contentType: 'image/jpeg',
            customMetadata: {'ownerId': _user!.id},
          ),
        );

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
        throw Exception('error while uploading: $e');
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
            child: Text(
              AppLocale.enterPw.getString(context),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: passwordController,
              obscureText: true,
              autofocus: true,
              decoration: InputDecoration(
                labelText: AppLocale.pw.getString(context),

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
                          ? AppLocale.pwNecessary.getString(context)
                          : null,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text(
                AppLocale.cancel.getString(context),
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
                AppLocale.proceed.getString(context),
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
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            backgroundColor: Palette.forgedGold,
            content: Center(
              child: Text(
                AppLocale.changeEmailMsg.getString(context),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        );
      }
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          backgroundColor: Palette.alarmRed,
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
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            backgroundColor: Palette.forgedGold,
            content: Center(
              child: Text(AppLocale.changeEmailMsg.getString(context)),
            ),
          ),
        );
      }
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
        body: Stack(
          children: [
            Positioned(
              right: 16,
              top: 60,
              child: Container(
                decoration: BoxDecoration(
                  color: Palette.shadowGrey.o(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Palette.concreteGrey),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _currentLanguage,
                    dropdownColor: Palette.primalBlack.o(0.9),
                    iconEnabledColor: Palette.forgedGold,
                    style: TextStyle(color: Palette.glazedWhite),
                    borderRadius: BorderRadius.circular(8),
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    selectedItemBuilder: (BuildContext context) {
                      return _languages.map((language) {
                        return Center(
                          child: Text(
                            language['flag']!,
                            style: TextStyle(fontSize: 24),
                          ),
                        );
                      }).toList();
                    },
                    items:
                        _languages.map((language) {
                          return DropdownMenuItem<String>(
                            value: language['code'],
                            child: Center(
                              child: Text(
                                language['flag']!,
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                          );
                        }).toList(),
                    onChanged: (String? newLanguage) {
                      if (newLanguage != null) {
                        setState(() {
                          _currentLanguage = newLanguage;
                        });

                        // Change the app language
                        FlutterLocalization.instance.translate(newLanguage);
                      }
                    },
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 2),
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.chevron_left_rounded, size: 36),
                      color: Palette.glazedWhite,
                      style: ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize.padded,
                        splashFactory: NoSplash.splashFactory,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 122,
                    child: Image.asset("assets/images/icon_full.png"),
                  ),
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
                            style: ButtonStyle(
                              splashFactory: NoSplash.splashFactory,
                            ),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocale.changeEmail.getString(context),
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
                            textInputAction: TextInputAction.go,
                            autovalidateMode: AutovalidateMode.always,
                            validator: validateEmail,
                            keyboardType: TextInputType.emailAddress,
                            onFieldSubmitted: _onEmailSubmitted,
                            controller: _emailController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              helperText: AppLocale.pressEnterFinish.getString(
                                context,
                              ),
                              labelStyle: TextStyle(color: Palette.primalBlack),
                              suffixIcon: IconButton(
                                onPressed: () => _emailController.clear(),
                                icon: Icon(
                                  Icons.delete,
                                  color: Palette.primalBlack.o(0.85),
                                  size: 26,
                                ),
                              ),
                              fillColor: Palette.glazedWhite,
                              filled: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              hintText: AppLocale.pressEnterDone.getString(
                                context,
                              ),
                              hintStyle: TextStyle(color: Palette.forgedGold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 42,
                    child: FilledButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Palette.shadowGrey,
                        ),
                        splashFactory: NoSplash.splashFactory,
                      ),
                      onPressed: _onResetPassword,
                      child: Text(AppLocale.changePw.getString(context)),
                    ),
                  ),
                  SizedBox(
                    height: 42,
                    child: FilledButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Palette.shadowGrey,
                        ),
                        splashFactory: NoSplash.splashFactory,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => BlockedUsersDialog(),
                        );
                      },
                      child: Text(AppLocale.blocks.getString(context)),
                    ),
                  ),
                  SizedBox(
                    height: 42,
                    child: FilledButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Palette.shadowGrey,
                        ),
                        splashFactory: NoSplash.splashFactory,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                backgroundColor: Palette.forgedGold,

                                title: Center(
                                  child: Text(
                                    AppLocale.areYouSure.getString(context),
                                    style: GoogleFonts.sometypeMono(
                                      textStyle: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                        Palette.glazedWhite,
                                      ),
                                    ),
                                    onPressed: () {
                                      auth.deleteUser();
                                      if (!context.mounted) return;
                                      if (mounted) {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) => LoginScreen(),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(
                                      AppLocale.deleteAcc.getString(context),
                                      style: TextStyle(
                                        color: Palette.primalBlack,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      AppLocale.cancel.getString(context),
                                      style: TextStyle(
                                        color: Palette.primalBlack,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        );
                      },
                      child: Text(AppLocale.deleteAcc.getString(context)),
                    ),
                  ),
                  SizedBox(
                    height: 42,
                    child: FilledButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Palette.shadowGrey,
                        ),
                        splashFactory: NoSplash.splashFactory,
                      ),
                      onPressed: () async {
                        await auth.signOut();
                        if (!context.mounted) {
                          return;
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text(AppLocale.logOut.getString(context)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 24, 12),
                      child: Text(
                        "version 1.0.3",
                        style: TextStyle(color: Palette.glazedWhite),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
