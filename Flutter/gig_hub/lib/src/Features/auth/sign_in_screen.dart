import 'package:flutter/material.dart';
import 'package:gig_hub/src/Common/main_screen.dart';
import 'package:gig_hub/src/Data/auth_repository.dart';
import 'package:gig_hub/src/Data/database_repository.dart';
import 'package:gig_hub/src/Features/auth/sign_up_bottomsheet.dart';
import 'package:gig_hub/src/Theme/palette.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:shimmer/shimmer.dart';

import '../../Common/app_imports.dart' as http;

class LoginScreen extends StatefulWidget {
  final DatabaseRepository repo;
  final AuthRepository auth;
  const LoginScreen({super.key, required this.repo, required this.auth});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _loginEmailController = TextEditingController(
    text: "loremipsum@email.com",
  );
  final TextEditingController _loginPasswordController = TextEditingController(
    text: "password",
  );
  Set<String> selected = {'dj'};
  bool _isObscured = true;

  // @override
  // void initState() {
  //   super.initState();
  //   initUniLinks();
  //   listenForRedirect();
  // }

  // void initUniLinks() {
  //   uriLinkStream.listen((Uri? uri) {
  //     if (uri != null && uri.scheme == 'gighub') {
  //       final authCode = uri.queryParameters['code'];
  //       if (authCode != null) {
  //         // Hier kannst du das Token mit dem code anfordern
  //         print('Authorization code: $authCode');
  //       }
  //     }
  //   });
  // }

  // Future<void> launchSoundCloudLogin() async {
  //   final authUrl = Uri.parse(
  //     '$authEndpoint'
  //     '?client_id=$clientId'
  //     '&redirect_uri=$redirectUri'
  //     '&response_type=code'
  //     '&scope=non-expiring',
  //   );

  //   if (await canLaunchUrl(authUrl)) {
  //     await launchUrl(authUrl, mode: LaunchMode.externalApplication);
  //   } else {
  //     throw 'Could not launch $authUrl';
  //   }
  // }

  // void listenForRedirect() {
  //   uriLinkStream.listen((Uri? uri) {
  //     if (uri != null && uri.scheme == 'gighub') {
  //       final code = uri.queryParameters['code'];
  //       if (code != null) {
  //         print('✅ Authorization Code erhalten: $code');
  //         exchangeCodeForToken(code);
  //       }
  //     }
  //   });
  // }

  // Future<void> exchangeCodeForToken(String code) async {
  //   final response = await http.post(
  //     Uri.parse(tokenEndpoint),
  //     body: {
  //       'client_id': clientId,
  //       'client_secret': clientSecret,
  //       'grant_type': 'authorization_code',
  //       'redirect_uri': redirectUri,
  //       'code': code,
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     final accessToken = data['access_token'];
  //     print('🎉 Access Token: $accessToken');

  //     // Optional: Speichern (z. B. mit shared_preferences) & API aufrufen
  //   } else {
  //     print('❌ Fehler beim Token-Austausch: ${response.body}');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.primalBlack,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            spacing: 8,
            children: [
              SizedBox(height: 72),
              SizedBox(
                height: 110,
                width: 110,
                child: Hero(
                  tag: context,
                  child: Image.asset('assets/images/gighub_logo.png'),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 48,
                width: 270,
                child: LiquidGlass(
                  shape: LiquidRoundedRectangle(
                    borderRadius: Radius.circular(16),
                  ),
                  settings: LiquidGlassSettings(
                    thickness: 16,
                    refractiveIndex: 1.1,
                    chromaticAberration: 0.2,
                  ),
                  child: SegmentedButton<String>(
                    expandedInsets: EdgeInsets.all(2),
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment<String>(
                        value: 'booker',
                        label: Text("booker", style: TextStyle(fontSize: 12)),
                      ),
                      ButtonSegment<String>(
                        value: 'dj',
                        label: Text(
                          "    DJ    ",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                    selected: selected,
                    onSelectionChanged: (Set<String> newSelection) {
                      setState(() {
                        selected = newSelection;
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                        states,
                      ) {
                        if (states.contains(WidgetState.selected)) {
                          return Palette.shadowGrey;
                        }
                        return Palette.shadowGrey.o(0.35);
                      }),
                      foregroundColor: WidgetStateProperty.all(
                        Palette.primalBlack,
                      ),
                      textStyle: WidgetStateProperty.resolveWith<TextStyle?>((
                        states,
                      ) {
                        return TextStyle(
                          fontWeight:
                              states.contains(WidgetState.selected)
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                        );
                      }),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Palette.shadowGrey, width: 2),
                        ),
                      ),
                      padding: WidgetStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(horizontal: 24),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: 310,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "  don't have an account?",
                          style: TextStyle(color: Palette.glazedWhite),
                        ),
                        TextButton(
                          style: ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              showDragHandle: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return SignUpSheet(
                                  repo: widget.repo,
                                  auth: widget.auth,
                                );
                              },
                            );
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Palette.forgedGold,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Palette.glazedWhite,
                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: AutofillGroup(
                        child: Column(
                          children: [
                            TextFormField(
                              autofillHints: [AutofillHints.email],
                              controller: _loginEmailController,
                              showCursor: true,
                              maxLines: 1,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(12),
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Palette.primalBlack,
                                  size: 20,
                                ),
                              ),
                            ),
                            Divider(color: Palette.concreteGrey),
                            TextFormField(
                              autofillHints: [AutofillHints.password],
                              controller: _loginPasswordController,
                              showCursor: true,
                              maxLines: 1,
                              obscureText: _isObscured,
                              obscuringCharacter: "✱",
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.lock_outline_rounded,
                                  color: Palette.primalBlack,
                                  size: 20,
                                ),
                                suffixIcon: IconButton(
                                  onPressed:
                                      () => setState(() {
                                        _isObscured = !_isObscured;
                                      }),
                                  icon:
                                      !_isObscured
                                          ? Icon(
                                            Icons.visibility,
                                            color: Palette.concreteGrey,
                                          )
                                          : Icon(
                                            Icons.visibility_off,
                                            color: Palette.concreteGrey,
                                          ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            dismissDirection: DismissDirection.horizontal,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Palette.gigGrey.o(0.8),
                            elevation: 2,
                            showCloseIcon: true,
                            closeIconColor: Palette.glazedWhite.o(0.3),
                            margin: EdgeInsets.fromLTRB(24, 0, 24, 0),
                            shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            content: Text(
                              "Pech",
                              style: TextStyle(
                                color: Palette.glazedWhite,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            duration: Duration(seconds: 4),
                          ),
                        );
                      },
                      child: Text(
                        "forgot your password?",
                        style: TextStyle(
                          color: Palette.glazedWhite.o(0.7),
                          decoration: TextDecoration.underline,
                          decorationColor: Palette.glazedWhite.o(0.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),

                    LiquidGlass(
                      shape: LiquidRoundedRectangle(
                        borderRadius: Radius.circular(16),
                      ),
                      settings: LiquidGlassSettings(
                        thickness: 24,
                        refractiveIndex: 1.1,
                        chromaticAberration: 0.35,
                      ),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.only(left: 120, right: 120),
                          ),
                          backgroundColor: WidgetStateProperty.all<Color>(
                            Palette.forgedGold.o(0.8),
                          ),
                          shape: WidgetStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: Palette.concreteGrey.o(0.7),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          try {
                            await widget.auth.signInWithEmailAndPassword(
                              _loginEmailController.text,
                              _loginPasswordController.text,
                            );
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Palette.forgedGold,
                                content: Center(
                                  child: Text(
                                    "login error: invalid credentials!",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        child: Text(
                          "log in",
                          style: GoogleFonts.sometypeMono(
                            textStyle: TextStyle(
                              color: Palette.glazedWhite,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              wordSpacing: -8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    child: Divider(color: Palette.glazedWhite.o(0.5)),
                  ),
                  Text(
                    "  or  ",
                    style: TextStyle(color: Palette.glazedWhite, fontSize: 18),
                  ),
                  SizedBox(
                    width: 150,
                    child: Divider(color: Palette.glazedWhite.o(0.5)),
                  ),
                ],
              ),

              SizedBox(
                height: 48,
                width: 280,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {
                          debugPrint("mit apple einloggen");
                        },
                        icon: Icon(
                          Icons.apple,
                          color: Palette.glazedWhite,
                          size: 48,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          debugPrint("mit google einloggen");
                        },
                        icon: Icon(
                          Icons.g_mobiledata,
                          color: Palette.glazedWhite,
                          size: 56,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          debugPrint("mit facebook einloggen");
                        },
                        icon: Icon(
                          Icons.facebook,
                          color: Palette.glazedWhite,
                          size: 44,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Divider(color: Palette.glazedWhite.o(0.5)),
              SizedBox(height: 24),
              LiquidGlass(
                shape: LiquidRoundedRectangle(
                  borderRadius: Radius.circular(16),
                ),
                settings: LiquidGlassSettings(
                  thickness: 20,
                  refractiveIndex: 1.1,
                  chromaticAberration: 0.35,
                ),
                child: Shimmer.fromColors(
                  period: Duration(milliseconds: 2600),
                  baseColor: Palette.glazedWhite,
                  highlightColor: Palette.forgedGold,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.transparent,
                        padding: EdgeInsets.only(left: 78, right: 78),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: Palette.glazedWhite.o(0.7),
                            width: 2,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder:
                                (context) => MainScreen(
                                  repo: widget.repo,
                                  auth: widget.auth,
                                ),
                          ),
                        );
                      },
                      child: Text(
                        "continue as guest",
                        style: GoogleFonts.sometypeMono(
                          textStyle: TextStyle(
                            color: Palette.primalBlack,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
