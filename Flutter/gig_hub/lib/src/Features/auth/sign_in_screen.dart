import 'package:flutter/material.dart';
import 'package:gig_hub/src/Common/main_screen.dart';
import 'package:gig_hub/src/Data/database_repository.dart';
import 'package:gig_hub/src/Features/auth/sign_up_bottomsheet.dart';
import 'package:gig_hub/src/Theme/palette.dart';
import 'package:shimmer/shimmer.dart';

class LoginScreen extends StatefulWidget {
  final DatabaseRepository repo;
  const LoginScreen({super.key, required this.repo});

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
                      label: Text("    DJ    ", style: TextStyle(fontSize: 12)),
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

                      child: Column(
                        children: [
                          TextFormField(
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
                    ElevatedButton(
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.only(left: 124, right: 124),
                        ),
                        backgroundColor: WidgetStateProperty.all<Color>(
                          Palette.forgedGold,
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
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => MainScreen(repo: widget.repo),
                          ),
                        );
                      },
                      child: Text(
                        "log in",
                        style: TextStyle(
                          color: Palette.glazedWhite,
                          fontWeight: FontWeight.w800,
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
              Shimmer.fromColors(
                period: Duration(milliseconds: 2300),
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
                      padding: EdgeInsets.only(left: 96, right: 96),

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
                          builder: (context) => MainScreen(repo: widget.repo),
                        ),
                      );
                    },
                    child: Text(
                      "continue as guest",
                      style: TextStyle(
                        color: Palette.primalBlack,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
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
