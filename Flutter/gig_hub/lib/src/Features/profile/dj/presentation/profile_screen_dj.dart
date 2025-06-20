import 'dart:convert';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gig_hub/src/Data/user.dart';
import 'package:gig_hub/src/Features/chat/presentation/chat_screen.dart';
import 'package:gig_hub/src/Features/profile/dj/presentation/audio_player.dart';
import 'package:gig_hub/src/Features/search/presentation/widgets/bpm_selection_dialog.dart';
import 'package:gig_hub/src/Features/search/presentation/widgets/genre_selection_dialog.dart';
import 'package:gig_hub/src/Theme/palette.dart';
import 'package:gig_hub/src/Common/genre_bubble.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gig_hub/src/Data/database_repository.dart';
import 'package:http/http.dart' as http;
import 'package:pinch_zoom/pinch_zoom.dart';

class ProfileScreenDJArgs {
  final DJ dj;
  final DatabaseRepository repo;
  final bool showChatButton, showEditButton;

  ProfileScreenDJArgs({
    required this.dj,
    required this.repo,
    this.showChatButton = true,
    this.showEditButton = false,
  });
}

class ProfileScreenDJ extends StatefulWidget {
  static const routeName = '/profileDj';

  final DJ dj;
  final dynamic repo;
  final bool showChatButton, showEditButton;
  const ProfileScreenDJ({
    super.key,
    required this.dj,
    required this.repo,
    required this.showChatButton,
    required this.showEditButton,
  });

  @override
  State<ProfileScreenDJ> createState() => _ProfileScreenDJState();
}

class _ProfileScreenDJState extends State<ProfileScreenDJ> {
  int index = 0;

  bool editMode = false;
  final _formKey = GlobalKey<FormState>();
  final _locationFocusNode = FocusNode();
  String? _locationError;

  late final PlayerController _playerControllerOne, _playerControllerTwo;
  late final TextEditingController _nameController = TextEditingController(
    text: widget.dj.name,
  );
  late final TextEditingController _locationController = TextEditingController(
    text: widget.dj.city,
  );
  late final TextEditingController _bpmController = TextEditingController(
    text: "${widget.dj.bpmMin}-${widget.dj.bpmMax} bpm",
  );
  late final TextEditingController _aboutController = TextEditingController(
    text: widget.dj.about,
  );
  late final TextEditingController _soundcloudControllerOne =
      TextEditingController(text: widget.dj.set1Url);
  late final TextEditingController _soundcloudControllerTwo =
      TextEditingController(text: widget.dj.set2Url);
  late final TextEditingController _infoController = TextEditingController(
    text: widget.dj.info,
  );
  @override
  void initState() {
    super.initState();

    _playerControllerOne = PlayerController();
    _playerControllerTwo = PlayerController();

    _locationFocusNode.addListener(_onLocationFocusChange);
  }

  void _onLocationFocusChange() {
    if (!_locationFocusNode.hasFocus) {
      _validateCity(_locationController.text);
    }
  }

  @override
  void dispose() {
    _locationFocusNode.removeListener(_onLocationFocusChange);
    _locationFocusNode.dispose();

    _playerControllerOne.dispose();
    _playerControllerTwo.dispose();

    _nameController.dispose();
    _locationController.dispose();
    _bpmController.dispose();
    _aboutController.dispose();
    _soundcloudControllerOne.dispose();
    _soundcloudControllerTwo.dispose();
    _infoController.dispose();

    super.dispose();
  }

  String? soundcloudValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'enter url to your set on soundcloud';
    }

    final uri = Uri.tryParse(value);
    if (uri == null ||
        !uri.hasAbsolutePath ||
        !(uri.isScheme('http') || uri.isScheme('https'))) {
      return 'invalid url';
    }

    if (!value.contains('soundcloud.com')) {
      return 'invalid url';
    }

    return null;
  }

  Future<void> _validateCity(String value) async {
    final apiKey = dotenv.env['GOOGLE_API_KEY'];
    final trimmedValue = value.trim();

    if (trimmedValue.isEmpty) {
      setState(() => _locationError = ' ');
      _formKey.currentState?.validate();
      return;
    }

    final query = Uri.encodeComponent(trimmedValue);
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json'
      '?input=$query&types=(cities)&language=en&key=$apiKey',
    );

    setState(() {
      _locationError = null;
    });

    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      bool isValidCityFound = false;
      if (response.statusCode == 200 && data['status'] == 'OK') {
        final predictions = data['predictions'] as List;

        if (predictions.isNotEmpty) {
          for (var prediction in predictions) {
            final String mainText =
                prediction['structured_formatting']['main_text']
                    ?.toString()
                    .trim() ??
                '';
            final List types = prediction['types'] ?? [];

            if (mainText.toLowerCase() == trimmedValue.toLowerCase() &&
                (types.contains('locality') ||
                    types.contains('administrative_area_level_3') ||
                    types.contains('political'))) {
              isValidCityFound = true;
              break;
            }
          }
        }

        setState(() {
          _locationError = isValidCityFound ? null : ' ';
          if (editMode) {
            _formKey.currentState?.validate();
          }
        });
      } else {
        debugPrint(
          'Google Places API Error: ${data['status']} - ${data['error_message']}',
        );
        setState(() {
          _locationError = ' ';
          if (editMode) {
            _formKey.currentState?.validate();
          }
        });
      }
    } catch (e) {
      debugPrint('Network error during city validation: $e');
      setState(() => _locationError = ' ');
      if (editMode) {
        _formKey.currentState?.validate();
      }
    }
  }

  Future<void> _showGenreDialog() async {
    final result = await showDialog<List<String>>(
      context: context,
      builder:
          (context) =>
              GenreSelectionDialog(initialSelectedGenres: widget.dj.genres),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        widget.dj.genres
          ..clear()
          ..addAll(result);
      });
    }
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
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 256,
                  child: Image.network(
                    widget.dj.headUrl,
                    fit: BoxFit.cover,
                    colorBlendMode: editMode ? BlendMode.difference : null,
                    color: editMode ? Palette.primalBlack : null,
                  ),
                ),

                editMode
                    ? Positioned(
                      top: 120,
                      left: 180,
                      child: IconButton(
                        style: ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.padded,
                          splashFactory: NoSplash.splashFactory,
                        ),
                        onPressed: () {}, // TODO: image picker fit machen
                        icon: Icon(
                          Icons.file_upload_rounded,
                          color: Palette.concreteGrey,
                          size: 48,
                        ),
                      ),
                    )
                    : Positioned(child: SizedBox.shrink()),
                Positioned(
                  top: 40,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: IconButton(
                      onPressed: () {
                        PlayerController().stopAllPlayers();

                        Navigator.pop(context);
                      },
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
                      child:
                          !editMode
                              ? Text(
                                widget.dj.name,
                                style: GoogleFonts.sometypeMono(
                                  textStyle: TextStyle(
                                    color: Palette.glazedWhite,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                              : Container(
                                width: 160,
                                height: 28,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Palette.glazedWhite,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Palette.glazedWhite.o(0.2),
                                ),
                                child: TextFormField(
                                  onEditingComplete: () {
                                    setState(() {
                                      widget.dj.name = _nameController.text;
                                    });
                                  },
                                  style: TextStyle(
                                    color: Palette.glazedWhite,
                                    fontSize: 12,
                                  ),
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Palette.forgedGold,
                                        width: 3,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: Palette.forgedGold,
                                      ),
                                    ),
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
                        left: BorderSide(
                          width: 2,
                          color: Palette.gigGrey.o(0.6),
                        ),
                        top: BorderSide(
                          width: 2,
                          color: Palette.gigGrey.o(0.6),
                        ),
                        bottom: BorderSide(
                          width: 2,
                          color: Palette.gigGrey.o(0.6),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 2,
                        top: 2,
                        bottom: 2,
                      ),
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
                                  !editMode
                                      ? Text(
                                        widget.dj.city,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Palette.primalBlack,
                                        ),
                                      )
                                      : Container(
                                        width: 100,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Palette.glazedWhite,
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          color: Palette.glazedWhite.o(0.2),
                                        ),
                                        child: TextFormField(
                                          style: TextStyle(
                                            color: Palette.glazedWhite,
                                            fontSize: 10,
                                          ),
                                          controller: _locationController,
                                          focusNode: _locationFocusNode,
                                          validator: (value) {
                                            return _locationError;
                                          },
                                          autovalidateMode:
                                              AutovalidateMode
                                                  .onUserInteraction,
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Palette.forgedGold,
                                                width: 3,
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: Palette.forgedGold,
                                              ),
                                            ),
                                            errorStyle: TextStyle(
                                              fontSize: 0,
                                              height: 0,
                                            ),
                                          ),
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
                                  !editMode
                                      ? Text(
                                        '${widget.dj.bpmMin}-${widget.dj.bpmMax} bpm',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Palette.primalBlack,
                                        ),
                                      )
                                      : Container(
                                        width: 100,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Palette.glazedWhite,
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          color: Palette.glazedWhite.o(0.2),
                                        ),
                                        child: TextFormField(
                                          readOnly: true,
                                          onTap: () async {
                                            final result =
                                                await showDialog<List<int>>(
                                                  context: context,
                                                  builder:
                                                      (context) =>
                                                          BpmSelectionDialog(
                                                            intialSelectedBpm: [
                                                              widget.dj.bpmMin,
                                                              widget.dj.bpmMax,
                                                            ],
                                                          ),
                                                );

                                            if (result != null &&
                                                result.length == 2) {
                                              setState(() {
                                                widget.dj.bpmMin = result[0];
                                                widget.dj.bpmMax = result[1];
                                                _bpmController.text =
                                                    '${result[0]}-${result[1]} bpm';
                                              });
                                            }
                                          },
                                          style: TextStyle(
                                            color: Palette.glazedWhite,
                                            fontSize: 10,
                                          ),
                                          controller: _bpmController,
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Palette.forgedGold,
                                                width: 3,
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: Palette.forgedGold,
                                              ),
                                            ),
                                          ),
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
                          !editMode
                              ? Container(
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
                              )
                              : Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Palette.glazedWhite,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Palette.glazedWhite.o(0.2),
                                ),
                                child: TextFormField(
                                  onEditingComplete: () {
                                    setState(() {
                                      widget.dj.about = _aboutController.text;
                                    });
                                  },
                                  minLines: 1,
                                  maxLines: 7,
                                  maxLength: 250,
                                  style: TextStyle(
                                    color: Palette.glazedWhite,
                                    fontSize: 14,
                                    overflow: TextOverflow.visible,
                                  ),
                                  controller: _aboutController,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Palette.forgedGold,
                                        width: 3,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: Palette.forgedGold,
                                      ),
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
                              !editMode
                                  ? widget.dj.genres
                                      .map(
                                        (genreString) =>
                                            GenreBubble(genre: genreString),
                                      )
                                      .toList()
                                  : [
                                    ...widget.dj.genres.map(
                                      (genreString) =>
                                          GenreBubble(genre: genreString),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Palette.forgedGold,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: GestureDetector(
                                        onTap: _showGenreDialog,

                                        child: const GenreBubble(
                                          genre: " edit genres ",
                                        ),
                                      ),
                                    ),
                                  ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      Column(
                        spacing: !editMode ? 0 : 8,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "first SoundCloud link", // TODO: artist info von soundcloud api fetchen
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
                          !editMode
                              ? Row(
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
                              )
                              : Center(
                                child: Container(
                                  width: 260,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Palette.glazedWhite,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Palette.glazedWhite.o(0.2),
                                  ),
                                  child: TextFormField(
                                    style: TextStyle(
                                      color: Palette.glazedWhite,
                                      fontSize: 10,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    controller: _soundcloudControllerOne,
                                    validator: soundcloudValidator,
                                    autovalidateMode:
                                        AutovalidateMode.onUnfocus,

                                    decoration: InputDecoration(
                                      prefixIcon:
                                          _soundcloudControllerOne.text.isEmpty
                                              ? null
                                              : IconButton(
                                                style: ButtonStyle(
                                                  splashFactory:
                                                      NoSplash.splashFactory,
                                                ),
                                                onPressed:
                                                    _soundcloudControllerOne
                                                        .clear,
                                                icon: Icon(
                                                  Icons.close,
                                                  color: Palette.glazedWhite,
                                                  size: 18,
                                                ),
                                              ),

                                      suffixIcon: IconButton(
                                        style: ButtonStyle(
                                          splashFactory: NoSplash.splashFactory,
                                        ),
                                        icon: Icon(
                                          Icons.paste_rounded,
                                          color: Palette.forgedGold,
                                          size: 20,
                                        ),
                                        onPressed: () async {
                                          final data = await Clipboard.getData(
                                            Clipboard.kTextPlain,
                                          );
                                          if (data != null &&
                                              data.text != null) {
                                            _soundcloudControllerOne.text =
                                                data.text!;
                                          }
                                        },
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Palette.forgedGold,
                                          width: 3,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: Palette.forgedGold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        ],
                      ),
                      SizedBox(height: !editMode ? 4 : 24),
                      Column(
                        spacing: !editMode ? 0 : 8,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "second SoundCloud link", // TODO: artist info von soundcloud api fetchen
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
                          !editMode
                              ? Row(
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
                              )
                              : Center(
                                child: Container(
                                  width: 260,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Palette.glazedWhite,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Palette.glazedWhite.o(0.2),
                                  ),
                                  child: TextFormField(
                                    style: TextStyle(
                                      color: Palette.glazedWhite,
                                      fontSize: 10,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    controller: _soundcloudControllerTwo,
                                    validator: soundcloudValidator,
                                    autovalidateMode:
                                        AutovalidateMode.onUnfocus,
                                    decoration: InputDecoration(
                                      prefixIcon:
                                          _soundcloudControllerTwo.text.isEmpty
                                              ? null
                                              : IconButton(
                                                style: ButtonStyle(
                                                  splashFactory:
                                                      NoSplash.splashFactory,
                                                ),
                                                onPressed:
                                                    _soundcloudControllerTwo
                                                        .clear,
                                                icon: Icon(
                                                  Icons.close,
                                                  color: Palette.glazedWhite,
                                                  size: 18,
                                                ),
                                              ),
                                      suffixIcon: IconButton(
                                        style: ButtonStyle(
                                          splashFactory: NoSplash.splashFactory,
                                        ),
                                        icon: Icon(
                                          Icons.paste_rounded,
                                          color: Palette.forgedGold,
                                          size: 20,
                                        ),
                                        onPressed: () async {
                                          final data = await Clipboard.getData(
                                            Clipboard.kTextPlain,
                                          );
                                          if (data != null &&
                                              data.text != null) {
                                            _soundcloudControllerTwo.text =
                                                data.text!;
                                          }
                                        },
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Palette.forgedGold,
                                          width: 3,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: Palette.forgedGold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        ],
                      ),
                      SizedBox(height: widget.dj.mediaUrl == null ? 24 : 36),
                      !editMode
                          ? widget.dj.mediaUrl == null
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
                                        child: Image.network(
                                          url,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                  ],
                                ),
                              )
                          : Center(
                            child: Container(
                              height: 160,
                              width: 240,
                              decoration: BoxDecoration(
                                border: Border.all(color: Palette.forgedGold),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                style: ButtonStyle(
                                  tapTargetSize: MaterialTapTargetSize.padded,
                                ),
                                onPressed: () {
                                  // TODO: image picker fit machen
                                },
                                icon: Icon(
                                  Icons.file_upload_rounded,
                                  color: Palette.concreteGrey,
                                  size: 48,
                                ),
                              ),
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
                          !editMode
                              ? Container(
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
                              )
                              : Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Palette.glazedWhite,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Palette.glazedWhite.o(0.2),
                                ),
                                child: TextFormField(
                                  onEditingComplete: () {
                                    setState(() {
                                      widget.dj.info = _infoController.text;
                                    });
                                  },
                                  minLines: 1,
                                  maxLines: 7,
                                  maxLength: 250,
                                  cursorColor: Palette.forgedGold,

                                  style: TextStyle(
                                    color: Palette.glazedWhite,
                                    fontSize: 14,
                                    overflow: TextOverflow.visible,
                                  ),
                                  controller: _infoController,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Palette.forgedGold,
                                        width: 3,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: Palette.forgedGold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        ],
                      ),
                      Center(
                        child: SizedBox(
                          height: 100,
                          child:
                              !widget.showEditButton
                                  ? OutlinedButton(
                                    onPressed: () {
                                      if (editMode &&
                                          _formKey.currentState!.validate()) {
                                        !editMode
                                            ? PlayerController()
                                                .stopAllPlayers()
                                            : PlayerController()
                                                .overrideAudioSession;

                                        widget.dj.about = _aboutController.text;
                                        widget.dj.info = _infoController.text;
                                        widget.dj.name = _nameController.text;
                                        widget.dj.set1Url =
                                            _soundcloudControllerOne.text;
                                        widget.dj.set2Url =
                                            _soundcloudControllerTwo.text;

                                        final bpmText =
                                            _bpmController.text.trim();
                                        final bpmParts = bpmText
                                            .split(' ')
                                            .first
                                            .split('-');

                                        if (bpmParts.length == 2) {
                                          widget.dj.bpmMin =
                                              int.tryParse(
                                                bpmParts[0].trim(),
                                              ) ??
                                              0;
                                          widget.dj.bpmMax =
                                              int.tryParse(
                                                bpmParts[1].trim(),
                                              ) ??
                                              0;
                                        }

                                        if (_locationError == null) {
                                          widget.dj.city =
                                              _locationController.text;
                                        }

                                        setState(() => editMode = !editMode);
                                      } else if (!editMode) {
                                        PlayerController().stopAllPlayers();
                                        setState(() => editMode = !editMode);
                                      }
                                    },
                                    style: ButtonStyle(
                                      splashFactory: NoSplash.splashFactory,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Palette.forgedGold,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Row(
                                          spacing: 4,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              !editMode
                                                  ? "edit profile"
                                                  : "done",
                                              style: GoogleFonts.sometypeMono(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13,
                                                  color: Palette.glazedWhite,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationColor:
                                                      Palette.glazedWhite,
                                                ),
                                              ),
                                            ),
                                            Icon(
                                              !editMode
                                                  ? Icons.edit
                                                  : Icons.done,
                                              size: 14,
                                              color: Palette.glazedWhite,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  : SizedBox.shrink(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
