import 'package:firebase_auth/firebase_auth.dart';
import 'package:gig_hub/src/Common/main_screen.dart';
import 'package:gig_hub/src/Data/app_imports.dart';
import 'package:gig_hub/src/Data/auth_repository.dart';
import 'package:gig_hub/src/Features/auth/sign_up_bottomsheet.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../Data/app_imports.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();
  Set<String> selected = {'dj'};
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthRepository>();
    final db = context.watch<DatabaseRepository>();
    return Scaffold(
      backgroundColor: Palette.primalBlack,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            spacing: 8,
            children: [
              SizedBox(height: 52),
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
                                return SignUpSheet();
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
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: [AutofillHints.email],
                              controller: _loginEmailController,
                              showCursor: true,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: 'email',
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
                              keyboardType: TextInputType.visiblePassword,
                              autofillHints: [AutofillHints.password],
                              controller: _loginPasswordController,
                              showCursor: true,
                              maxLines: 1,
                              obscureText: _isObscured,
                              obscuringCharacter: "✱",
                              decoration: InputDecoration(
                                hintText: 'password',
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
                            await auth.signInWithEmailAndPassword(
                              _loginEmailController.text,
                              _loginPasswordController.text,
                            );
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(milliseconds: 950),
                                backgroundColor: Palette.forgedGold,
                                content: Center(
                                  child: Text(
                                    "invalid credentials!",
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
              SizedBox(height: 2),
              SizedBox(
                height: 72,
                width: 300,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          debugPrint("mit apple einloggen");
                        },
                        icon: Image.asset(
                          'assets/images/apple_logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          try {
                            await auth.signInWithGoogle();
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Palette.forgedGold,
                                content: Center(
                                  child: Text(
                                    "access failed, please retry!",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        icon: Image.asset(
                          'assets/images/google_logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          try {
                            await auth.signInWithFacebook();
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Palette.forgedGold,
                                content: Center(
                                  child: Text(
                                    "access failed, please retry!",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        icon: Image.asset(
                          'assets/images/facebook_logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              Divider(color: Palette.glazedWhite.o(0.5)),
              SizedBox(height: 20),
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
                      onPressed: () async {
                        final userCredential =
                            await FirebaseAuth.instance.signInAnonymously();
                        final uid = userCredential.user?.uid;

                        if (uid == null) {
                          throw Exception("failed to create guest key");
                        }

                        final guestUser = Guest(id: uid);

                        await db.createGuest(guestUser);
                        if (!context.mounted) return;
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder:
                                (context) => MainScreen(initialUser: guestUser),
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
