import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:gig_hub/src/Data/user.dart';
import 'package:gig_hub/src/Features/chat/presentation/chat_screen.dart';
import 'package:gig_hub/src/Theme/palette.dart';

import 'package:google_fonts/google_fonts.dart';

class UserProfileBooker extends StatelessWidget {
  final Booker booker;
  final dynamic repo;
  final bool showChatButton;
  const UserProfileBooker({
    super.key,
    required this.booker,
    required this.repo,
    this.showChatButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.primalBlack,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ChatScreen(
                    chatPartner: booker,
                    repo: repo,
                    currentUser: booker,
                  ),
            ),
          );
          debugPrint("Jetzt wird gechattet!");
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Palette.glazedWhite, Palette.gigGrey],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, 0.8],
            ),
            shape: BoxShape.circle,
          ),
          child: const Padding(
            padding: EdgeInsets.all(14.0),
            child: Icon(Icons.chat_outlined),
          ),
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 256,
                child: Image.network(booker.headUrl, fit: BoxFit.cover),
              ),
              Positioned(
                top: 40,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: IconButton(
                    style: ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.padded,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.chevron_left,
                      shadows: [
                        BoxShadow(blurRadius: 4, color: Palette.primalBlack),
                      ],
                    ),
                    iconSize: 32,
                    color: Palette.concreteGrey,
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Palette.primalBlack.o(0.5),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      border: Border.all(
                        color: Palette.gigGrey.o(0.6),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      booker.name,
                      style: GoogleFonts.sometypeMono(
                        textStyle: TextStyle(
                          color: Palette.glazedWhite,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 140,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      topLeft: Radius.circular(12),
                    ),
                    color: Palette.primalBlack.o(0.7),
                    border: Border(
                      left: BorderSide(width: 2, color: Palette.gigGrey.o(0.6)),
                      top: BorderSide(width: 2, color: Palette.gigGrey.o(0.6)),
                      bottom: BorderSide(
                        width: 2,
                        color: Palette.gigGrey.o(0.6),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2, top: 2, bottom: 2),
                    child: RatingStars(
                      value: booker.rating ?? 0,
                      starBuilder:
                          (index, color) =>
                              Icon(Icons.star, color: color, size: 18),
                      starCount: 5,
                      maxValue: 5,
                      axis: Axis.vertical,
                      angle: 15,
                      starSpacing: 0,
                      starSize: 18,
                      valueLabelVisibility: false,
                      animationDuration: const Duration(milliseconds: 350),
                      starOffColor: Palette.shadowGrey,
                      starColor: Palette.forgedGold,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                left: 0,
                bottom: 0,
                child: Divider(
                  height: 0,
                  thickness: 2,
                  color: Palette.gigGrey.o(0.6),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Palette.shadowGrey.o(0.6),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Palette.concreteGrey),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                              children: [
                                const Icon(Icons.place, size: 20),
                                const SizedBox(width: 4),
                                Text(
                                  booker.city,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Palette.primalBlack,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Palette.shadowGrey.o(0.6),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Palette.concreteGrey),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.house_siding_rounded,
                                  size: 22,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  booker.type,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Palette.primalBlack,
                                  ),
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
                          " about",
                          style: GoogleFonts.sometypeMono(
                            textStyle: TextStyle(
                              color: Palette.glazedWhite,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Palette.shadowGrey,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              booker.about,
                              style: TextStyle(
                                color: Palette.primalBlack,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 160,
                      child: Placeholder(
                        child: Center(
                          child: Text(
                            "Media URLs",
                            style: TextStyle(color: Palette.glazedWhite),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          " info / requirements",
                          style: GoogleFonts.sometypeMono(
                            textStyle: TextStyle(
                              color: Palette.glazedWhite,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Palette.shadowGrey,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              booker.info,
                              style: TextStyle(
                                color: Palette.primalBlack,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
