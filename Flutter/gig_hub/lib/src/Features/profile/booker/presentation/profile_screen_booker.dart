import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:gig_hub/src/Data/user.dart';
import 'package:gig_hub/src/Theme/palette.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gig_hub/src/Data/database_repository.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class ProfileScreenBookerArgs {
  final Booker booker;
  final DatabaseRepository repo;

  ProfileScreenBookerArgs({required this.booker, required this.repo});
}

class ProfileScreenBooker extends StatefulWidget {
  static const routeName = '/profileBooker';

  final Booker booker;
  final dynamic repo;

  const ProfileScreenBooker({
    super.key,
    required this.booker,
    required this.repo,
  });

  @override
  State<ProfileScreenBooker> createState() => _ProfileScreenBookerState();
}

class _ProfileScreenBookerState extends State<ProfileScreenBooker> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.primalBlack,
      body: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 256,
                child: Image.network(widget.booker.headUrl, fit: BoxFit.cover),
              ),
              Positioned(
                top: 40,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: IconButton(
                    style: const ButtonStyle(
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
                      widget.booker.name,
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
                      value: widget.booker.rating ?? 0,
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
                                  widget.booker.city,
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
                                  widget.booker.type,
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
                              widget.booker.about,
                              style: TextStyle(
                                color: Palette.primalBlack,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),
                    widget.booker.mediaUrl == null
                        ? SizedBox.shrink()
                        : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ImageSlideshow(
                            width: double.infinity,
                            height: 220,
                            isLoop: true,
                            autoPlayInterval: 12000,
                            indicatorColor: Palette.shadowGrey,
                            indicatorBackgroundColor: Palette.gigGrey,
                            initialPage: index,
                            onPageChanged: (value) {
                              setState(() => index = value);
                            },
                            children: [
                              for (String url in widget.booker.mediaUrl!)
                                PinchZoom(
                                  zoomEnabled: true,
                                  maxScale: 2.5,
                                  child: Image.network(url, fit: BoxFit.cover),
                                ),
                            ],
                          ),
                        ),
                    const SizedBox(height: 36),
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
                              widget.booker.info,
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
