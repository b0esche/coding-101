import 'package:gig_hub/src/Data/app_imports.dart';
import 'package:gig_hub/src/Features/auth/sign_up_bottomsheet.dart';
import 'package:gig_hub/src/Features/chat/presentation/chat_list_screen.dart';
import 'package:gig_hub/src/Features/profile/booker/presentation/profile_screen_booker.dart';
import 'package:gig_hub/src/Features/profile/dj/presentation/profile_screen_dj.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:provider/provider.dart';

class CustomNavBar extends StatelessWidget {
  final AppUser currentUser;
  const CustomNavBar({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    final db = context.watch<DatabaseRepository>();
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
                  if (currentUser is DJ) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) => ProfileScreenDJ(
                              currentUser: currentUser,
                              dj: currentUser as DJ,

                              showChatButton: false,
                              showEditButton: false,
                              showFavoriteIcon: false,
                            ),
                      ),
                    );
                  } else if (currentUser is Booker) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) => ProfileScreenBooker(
                              booker: currentUser as Booker,
                              db: db,

                              showEditButton: false,
                            ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(milliseconds: 950),
                        backgroundColor: Palette.forgedGold,
                        content: Center(
                          child: Text(
                            'sign up as DJ or booker to create a profile!',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    );
                  }
                },
                icon: Icon(
                  Icons.account_box_rounded,
                  color: Palette.glazedWhite,
                ),
              ),
              VerticalDivider(color: Palette.primalBlack),
              IconButton(
                onPressed: () {
                  if (currentUser is Guest) {
                    showModalBottomSheet(
                      showDragHandle: true,
                      backgroundColor: Colors.transparent,
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return SignUpSheet();
                      },
                    );
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ChatListScreen(currentUser: currentUser),
                    ),
                  );
                },
                icon: Icon(
                  Icons.question_answer_outlined,
                  color: Palette.glazedWhite,
                ),
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
