import 'package:flutter/material.dart';
import 'package:gig_hub/src/Common/app_imports.dart';
import 'package:gig_hub/src/Data/auth_repository.dart';
import 'package:gig_hub/src/Features/chat/presentation/chat_list_screen.dart';
import 'package:gig_hub/src/Features/profile/dj/presentation/profile_screen_dj.dart';
import 'package:gig_hub/src/Theme/palette.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class CustomNavBar extends StatelessWidget {
  final DatabaseRepository repo;
  final AuthRepository auth;
  final DJ dj;
  const CustomNavBar({
    super.key,
    required this.repo,
    required this.auth,
    required this.dj,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(
        bottom: 36,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: LiquidGlass(
        shape: LiquidRoundedRectangle(borderRadius: Radius.circular(8)),
        settings: LiquidGlassSettings(thickness: 16, refractiveIndex: 1.275),
        child: Container(
          color: Palette.glazedWhite.o(0.075),
          height: 48,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.home_filled, color: Palette.forgedGold),
                ),
              ),
              VerticalDivider(color: Palette.primalBlack),
              IconButton(
                onPressed: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ProfileScreenDJ(
                          dj: dj,
                          repo: repo,
                          showChatButton: false,
                          showEditButton: true,
                        );
                      },
                    ),
                  );
                },
                icon: Icon(
                  Icons.account_box_rounded,
                  color: Palette.glazedWhite,
                ),
              ),
              VerticalDivider(color: Palette.primalBlack),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              ChatListScreen(repo: repo, currentUser: dj),
                    ),
                  );
                },
                icon: Icon(Icons.messenger_outline, color: Palette.glazedWhite),
              ),
              VerticalDivider(color: Palette.primalBlack),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Banner(
                  textStyle: GoogleFonts.sometypeMono(fontSize: 12),
                  message: 'soon',
                  location: BannerLocation.topEnd,
                  color: Palette.forgedGold,
                  child: IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(milliseconds: 650),
                          backgroundColor: Palette.forgedGold,
                          content: Center(
                            child: Text(
                              "coming soon: RAVE RADAR!",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.radar_rounded, color: Palette.glazedWhite),
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
