import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gig_hub/src/Data/user.dart';
import 'package:gig_hub/src/Features/chat/presentation/chat_screen.dart';
import 'package:gig_hub/src/Features/profile/dj/presentation/audio_player.dart';
import 'package:gig_hub/src/Theme/palette.dart';
import 'package:gig_hub/src/Common/genre_bubble.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gig_hub/src/Data/database_repository.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class ProfileScreenDJArgs {
  final DJ dj;
  final DatabaseRepository repo;
  final bool showChatButton;

  ProfileScreenDJArgs({
    required this.dj,
    required this.repo,
    this.showChatButton = true,
  });
}

class ProfileScreenDJ extends StatefulWidget {
  static const routeName = '/profileDj';

  final DJ dj;
  final dynamic repo;
  final bool showChatButton;
  const ProfileScreenDJ({
    super.key,
    required this.dj,
    required this.repo,
    required this.showChatButton,
  });

  @override
  State<ProfileScreenDJ> createState() => _ProfileScreenDJState();
}

class _ProfileScreenDJState extends State<ProfileScreenDJ> {
  late final PlayerController _playerControllerOne;
  late final PlayerController _playerControllerTwo;
  int index = 0;

  @override
  void initState() {
    _playerControllerOne = PlayerController();
    _playerControllerTwo = PlayerController();
    super.initState();
  }

  @override
  void dispose() {
    _playerControllerOne.dispose();
    _playerControllerTwo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.primalBlack,
      floatingActionButton:
          widget.showChatButton
              ? FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    ChatScreen.routeName,
                    arguments: ChatScreenArgs(
                      chatPartner: widget.dj,
                      repo: widget.repo,
                      currentUser: widget.dj,
                    ),
                  );
                  debugPrint("Jetzt wird getalkt!");
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Palette.glazedWhite, Palette.gigGrey],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: const [0, 0.8],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Icon(Icons.chat_outlined),
                  ),
                ),
              )
              : null,
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 256,
                child: Image.network(widget.dj.headUrl, fit: BoxFit.cover),
              ),
              Positioned(
                top: 40,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.chevron_left,
                      shadows: [
                        BoxShadow(blurRadius: 4, color: Palette.primalBlack),
                      ],
                    ),
                    iconSize: 36,
                    color: Palette.shadowGrey,
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.padded,
                    ),
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
                      color: Palette.primalBlack.o(0.6),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      border: Border(
                        left: BorderSide(
                          color: Palette.gigGrey.o(0.6),
                          width: 2,
                        ),
                        right: BorderSide(
                          color: Palette.gigGrey.o(0.6),
                          width: 2,
                        ),
                        top: BorderSide(
                          color: Palette.gigGrey.o(0.6),
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      widget.dj.name,
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
                    borderRadius: const BorderRadius.only(
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
                      value: widget.dj.rating ?? 0,
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
                                  widget.dj.city,
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
                                const Icon(Icons.speed, size: 22),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.dj.bpmMin}-${widget.dj.bpmMax} bpm',
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
                              widget.dj.about,
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
                    Center(
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        children:
                            widget.dj.genres
                                .map(
                                  (genreString) =>
                                      GenreBubble(genre: genreString),
                                )
                                .toList(),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "set 1 name", // TODO: artist info von soundcloud api fetchen
                          style: GoogleFonts.sometypeMono(
                            textStyle: TextStyle(
                              color: Palette.glazedWhite,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: Palette.glazedWhite,
                              decorationStyle: TextDecorationStyle.dotted,
                              decorationThickness: 2,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AudioPlayerWidget(
                              audioUrl:
                                  // widget.dj.set1Url TODO: über die eingegebene URL die Audiodaten von Soundcloud API fetchen
                                  'https://samplelib.com/lib/preview/mp3/sample-9s.mp3',
                              playerController: _playerControllerOne,
                            ),
                            const SizedBox(width: 2),
                            IconButton(
                              onPressed: () {
                                debugPrint(
                                  "soundcloud öffnen",
                                ); // TODO: soundcloud link über browser oder app öffnen
                              },
                              icon: SvgPicture.asset(
                                'assets/icons/soundcloud.svg',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "set 2 name", // TODO: artist info von soundcloud api fetchen
                          style: GoogleFonts.sometypeMono(
                            textStyle: TextStyle(
                              color: Palette.glazedWhite,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: Palette.glazedWhite,
                              decorationStyle: TextDecorationStyle.dotted,
                              decorationThickness: 2,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AudioPlayerWidget(
                              audioUrl:
                                  // widget.dj.set2URl TODO: über die eingegebene URL die Audiodaten von Soundcloud API fetchen
                                  'https://samplelib.com/lib/preview/mp3/sample-12s.mp3',
                              playerController: _playerControllerTwo,
                            ),
                            const SizedBox(width: 2),
                            IconButton(
                              onPressed: () {
                                debugPrint(
                                  "soundcloud öffnen", // TODO: soundcloud link über browser oder app öffnen
                                );
                              },
                              icon: SvgPicture.asset(
                                'assets/icons/soundcloud.svg',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: widget.dj.mediaUrl == null ? 24 : 36),
                    widget.dj.mediaUrl == null
                        ? SizedBox.shrink()
                        : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ImageSlideshow(
                            width: double.infinity,
                            height: 240,
                            isLoop: true,
                            autoPlayInterval: 12000,
                            indicatorColor: Palette.shadowGrey,
                            indicatorBackgroundColor: Palette.gigGrey,
                            initialPage: index,
                            onPageChanged: (value) {
                              setState(() => index = value);
                            },
                            children: [
                              for (String url in widget.dj.mediaUrl!)
                                PinchZoom(
                                  zoomEnabled: true,
                                  maxScale: 2.5,
                                  child: Image.network(url, fit: BoxFit.cover),
                                ),
                            ],
                          ),
                        ),
                    SizedBox(height: widget.dj.mediaUrl == null ? 24 : 36),
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
                              widget.dj.info,
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
