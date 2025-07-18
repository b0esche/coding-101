import "dart:io";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:hive_flutter/hive_flutter.dart";
import "package:liquid_glass_renderer/liquid_glass_renderer.dart";
import "package:provider/provider.dart";
import "package:url_launcher/url_launcher_string.dart";

import "../../../../Data/app_imports.dart";
import "../../../../Data/app_imports.dart" as http;

class ProfileScreenDJArgs {
  final DJ dj;
  final DatabaseRepository db;
  final bool showChatButton, showEditButton, showFavoriteIcon;
  final AppUser currentUser;

  ProfileScreenDJArgs({
    required this.dj,
    required this.db,
    required this.currentUser,
    required this.showChatButton,
    required this.showEditButton,
    required this.showFavoriteIcon,
  });
}

class ProfileScreenDJ extends StatefulWidget {
  static const routeName = '/profileDj';

  final DJ dj;

  final bool showChatButton, showEditButton, showFavoriteIcon;
  final AppUser currentUser;
  const ProfileScreenDJ({
    super.key,
    required this.dj,

    required this.currentUser,
    required this.showChatButton,
    required this.showEditButton,
    required this.showFavoriteIcon,
  });

  @override
  State<ProfileScreenDJ> createState() => _ProfileScreenDJState();
}

class _ProfileScreenDJState extends State<ProfileScreenDJ> {
  int index = 0;

  bool editMode = false;
  bool get isFavorite {
    final id = widget.dj.id;

    if (widget.currentUser is Guest) {
      return (widget.currentUser as Guest).favoriteUIds.contains(id);
    } else if (widget.currentUser is Booker) {
      return (widget.currentUser as Booker).favoriteUIds.contains(id);
    } else if (widget.currentUser is DJ) {
      return (widget.currentUser as DJ).favoriteUIds.contains(id);
    }
    return false;
  }

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
    text: "${widget.dj.bpm.first}-${widget.dj.bpm.last} bpm",
  );
  late final TextEditingController _aboutController = TextEditingController(
    text: widget.dj.about,
  );
  late final TextEditingController _soundcloudControllerOne =
      TextEditingController(text: widget.dj.streamingUrls.first);
  late final TextEditingController _soundcloudControllerTwo =
      TextEditingController(text: widget.dj.streamingUrls.last);
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
    final db = context.watch<DatabaseRepository>();
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        PlayerController().stopAllPlayers();
      },
      canPop: true,
      child: Scaffold(
        backgroundColor: Palette.primalBlack,
        floatingActionButton:
            (widget.showChatButton &&
                    widget.currentUser is! Guest &&
                    !(widget.currentUser is DJ &&
                        (widget.currentUser as DJ).id == widget.dj.id))
                ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ChatScreen(
                              chatPartner: widget.dj,

                              currentUser: widget.currentUser,
                            ),
                      ),
                    );
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
                    child:
                        !widget.dj.headImageUrl.startsWith('http')
                            ? Image.file(
                              File(widget.dj.headImageUrl),
                              fit: BoxFit.cover,
                              colorBlendMode:
                                  editMode ? BlendMode.difference : null,
                              color: editMode ? Palette.primalBlack : null,
                            )
                            : Image.network(
                              widget.dj.headImageUrl,
                              fit: BoxFit.cover,
                              colorBlendMode:
                                  editMode ? BlendMode.difference : null,
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
                          onPressed: () async {
                            final XFile? newMedia = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            if (newMedia != null) {
                              setState(() {
                                widget.dj.headImageUrl = newMedia.path;
                              });
                            }
                          },
                          icon: Icon(
                            Icons.file_upload_rounded,
                            color: Palette.concreteGrey,
                            size: 48,
                          ),
                        ),
                      )
                      : Positioned(child: SizedBox.shrink()),
                  Positioned(
                    top: 32,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: IconButton(
                        onPressed: () {
                          PlayerController().stopAllPlayers().whenComplete(() {
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          });
                        },
                        icon: Icon(
                          Icons.chevron_left,
                          shadows: [
                            BoxShadow(
                              blurRadius: 4,
                              color: Palette.primalBlack,
                            ),
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
                  (widget.showFavoriteIcon &&
                          !(widget.currentUser is DJ &&
                              (widget.currentUser as DJ).id == widget.dj.id))
                      ? Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.5,
                              color: Palette.gigGrey.o(0.65),
                            ),
                            shape: BoxShape.circle,
                            color: Palette.primalBlack.o(0.35),
                          ),
                          child: IconButton(
                            style: ButtonStyle(
                              splashFactory: NoSplash.splashFactory,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color:
                                  isFavorite
                                      ? Palette.favoriteRed
                                      : Palette.glazedWhite,
                              size: 22,
                            ),
                            onPressed: () async {
                              final String targetId = widget.dj.id;
                              final String userId = widget.currentUser.id;
                              final myFavoritesBox = Hive.box('favoritesBox');
                              final userDocRef = FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userId);

                              final bool newFavoriteStatus = !isFavorite;

                              setState(() {});

                              if (newFavoriteStatus) {
                                await userDocRef.update({
                                  'favoriteUIds': FieldValue.arrayUnion([
                                    targetId,
                                  ]),
                                });
                                myFavoritesBox.put(targetId, targetId);

                                if (widget.currentUser is Guest) {
                                  (widget.currentUser as Guest).favoriteUIds
                                      .add(targetId);
                                } else if (widget.currentUser is Booker) {
                                  (widget.currentUser as Booker).favoriteUIds
                                      .add(targetId);
                                } else if (widget.currentUser is DJ) {
                                  (widget.currentUser as DJ).favoriteUIds.add(
                                    targetId,
                                  );
                                }
                              } else {
                                await userDocRef.update({
                                  'favoriteUIds': FieldValue.arrayRemove([
                                    targetId,
                                  ]),
                                });
                                myFavoritesBox.delete(targetId);

                                if (widget.currentUser is Guest) {
                                  (widget.currentUser as Guest).favoriteUIds
                                      .remove(targetId);
                                } else if (widget.currentUser is Booker) {
                                  (widget.currentUser as Booker).favoriteUIds
                                      .remove(targetId);
                                } else if (widget.currentUser is DJ) {
                                  (widget.currentUser as DJ).favoriteUIds
                                      .remove(targetId);
                                }
                              }

                              setState(() {});
                            },
                          ),
                        ),
                      )
                      : SizedBox.shrink(),
                  Positioned.fill(
                    bottom: 2,
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
                  UserStarRating(widget: widget),
                  Positioned(
                    right: 0,
                    left: 0,
                    bottom: 0,
                    child: Divider(
                      height: 0,
                      thickness: 2,
                      color: Palette.forgedGold.o(0.8),
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
                            LiquidGlass(
                              shape: LiquidRoundedRectangle(
                                borderRadius: Radius.circular(8),
                              ),
                              settings: LiquidGlassSettings(thickness: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Palette.shadowGrey.o(0.4),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Palette.concreteGrey,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.place, size: 18),
                                      const SizedBox(width: 4),
                                      !editMode
                                          ? Text(
                                            widget.dj.city,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
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
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            Palette.forgedGold,
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
                            ),
                            LiquidGlass(
                              shape: LiquidRoundedRectangle(
                                borderRadius: Radius.circular(8),
                              ),
                              settings: LiquidGlassSettings(thickness: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Palette.shadowGrey.o(0.4),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Palette.concreteGrey,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.speed, size: 20),
                                      const SizedBox(width: 4),
                                      !editMode
                                          ? Text(
                                            '${widget.dj.bpm.first}-${widget.dj.bpm.last} bpm',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
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
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Palette.glazedWhite.o(0.2),
                                            ),
                                            child: TextFormField(
                                              readOnly: true,
                                              onTap: () async {
                                                final result = await showDialog<
                                                  List<int>
                                                >(
                                                  context: context,
                                                  builder:
                                                      (
                                                        context,
                                                      ) => BpmSelectionDialog(
                                                        intialSelectedBpm: [
                                                          widget.dj.bpm.first,
                                                          widget.dj.bpm.last,
                                                        ],
                                                      ),
                                                );

                                                if (result != null &&
                                                    result.length == 2) {
                                                  setState(() {
                                                    widget.dj.bpm.first =
                                                        result[0];
                                                    widget.dj.bpm.last =
                                                        result[1];
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
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            Palette.forgedGold,
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
                        const SizedBox(height: 36),
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
                                            width: 2.7,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
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
                        const SizedBox(height: 36),
                        Column(
                          spacing: !editMode ? 0 : 8,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              (widget.dj.trackTitles.isNotEmpty)
                                  ? widget.dj.trackTitles.first
                                  : 'first Track',
                              style: GoogleFonts.sometypeMono(
                                textStyle: TextStyle(
                                  wordSpacing: -3,
                                  color: Palette.glazedWhite,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Palette.glazedWhite,
                                  decorationStyle: TextDecorationStyle.dotted,
                                  decorationThickness: 2,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            !editMode
                                ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    AudioPlayerWidget(
                                      audioUrl: widget.dj.streamingUrls.first,
                                      playerController: _playerControllerOne,
                                    ),
                                    const SizedBox(width: 2),
                                    IconButton(
                                      onPressed: () {
                                        launchUrlString(
                                          widget.dj.trackUrls.first,
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
                                      controller: _soundcloudControllerOne,
                                      validator: soundcloudValidator,
                                      autovalidateMode:
                                          AutovalidateMode.onUnfocus,

                                      decoration: InputDecoration(
                                        prefixIcon:
                                            _soundcloudControllerOne
                                                    .text
                                                    .isEmpty
                                                ? null
                                                : RemoveButton(
                                                  soundcloudController:
                                                      _soundcloudControllerOne,
                                                ),

                                        suffixIcon: PasteButton(
                                          soundcloudController:
                                              _soundcloudControllerOne,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Palette.forgedGold,
                                            width: 3,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                        SizedBox(height: 36),
                        Column(
                          spacing: !editMode ? 0 : 8,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              (widget.dj.trackTitles.last.isNotEmpty)
                                  ? widget.dj.trackTitles.last
                                  : 'second track',
                              style: GoogleFonts.sometypeMono(
                                textStyle: TextStyle(
                                  color: Palette.glazedWhite,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Palette.glazedWhite,
                                  decorationStyle: TextDecorationStyle.dotted,
                                  decorationThickness: 2,
                                  wordSpacing: -3,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            !editMode
                                ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    AudioPlayerWidget(
                                      audioUrl: widget.dj.streamingUrls.last,
                                      playerController: _playerControllerTwo,
                                    ),
                                    const SizedBox(width: 2),
                                    IconButton(
                                      onPressed: () {
                                        launchUrlString(
                                          widget.dj.trackUrls.last,
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
                                            _soundcloudControllerTwo
                                                    .text
                                                    .isEmpty
                                                ? null
                                                : RemoveButton(
                                                  soundcloudController:
                                                      _soundcloudControllerTwo,
                                                ),
                                        suffixIcon: PasteButton(
                                          soundcloudController:
                                              _soundcloudControllerTwo,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Palette.forgedGold,
                                            width: 3,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                        SizedBox(height: 36),
                        !editMode
                            ? widget.dj.mediaImageUrls.isEmpty
                                ? SizedBox.shrink()
                                : ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: ImageSlideshow(
                                    width: double.infinity,
                                    height: 240,
                                    isLoop:
                                        widget.dj.mediaImageUrls.length == 1
                                            ? false
                                            : true,
                                    autoPlayInterval: 12000,

                                    indicatorColor:
                                        widget.dj.mediaImageUrls.length == 1
                                            ? Colors.transparent
                                            : Palette.shadowGrey,
                                    indicatorBackgroundColor:
                                        widget.dj.mediaImageUrls.length == 1
                                            ? Colors.transparent
                                            : Palette.gigGrey,
                                    initialPage: index,
                                    onPageChanged: (value) {
                                      setState(() => index = value);
                                    },
                                    children: [
                                      if (widget.dj.mediaImageUrls.isNotEmpty)
                                        for (String path
                                            in widget.dj.mediaImageUrls)
                                          PinchZoom(
                                            zoomEnabled: true,
                                            maxScale: 2.5,
                                            child:
                                                path.startsWith('http')
                                                    ? Image.network(
                                                      path,
                                                      fit: BoxFit.cover,
                                                    )
                                                    : Image.file(
                                                      File(path),
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
                                  onPressed: () async {
                                    List<XFile> medias = await ImagePicker()
                                        .pickMultiImage(limit: 10);
                                    List<String> mediaUrls =
                                        medias
                                            .map((element) => element.path)
                                            .toList();
                                    setState(() {
                                      widget.dj.mediaImageUrls.addAll(
                                        mediaUrls,
                                      );
                                    });
                                  },
                                  icon: Icon(
                                    Icons.file_upload_rounded,
                                    color: Palette.concreteGrey,
                                    size: 48,
                                  ),
                                ),
                              ),
                            ),
                        SizedBox(
                          height:
                              widget.dj.mediaImageUrls.isNotEmpty ? null : 24,
                        ),
                        (widget.dj.mediaImageUrls.isNotEmpty && editMode)
                            ? Center(
                              child: TextButton(
                                onPressed:
                                    () => setState(
                                      () => widget.dj.mediaImageUrls.clear(),
                                    ),
                                child: Text(
                                  "remove all images",
                                  style: TextStyle(
                                    color: Palette.alarmRed.o(0.7),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                            : SizedBox.shrink(),

                        widget.dj.mediaImageUrls.isNotEmpty
                            ? SizedBox(height: 36)
                            : SizedBox.shrink(),

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
                                      onPressed: () async {
                                        if (editMode &&
                                            _formKey.currentState!.validate()) {
                                          !editMode
                                              ? PlayerController()
                                                  .stopAllPlayers()
                                              : PlayerController()
                                                  .overrideAudioSession;

                                          widget.dj.about =
                                              _aboutController.text;
                                          widget.dj.info = _infoController.text;
                                          widget.dj.name = _nameController.text;
                                          widget.dj.streamingUrls[0] =
                                              _soundcloudControllerOne.text;

                                          widget.dj.streamingUrls[1] =
                                              _soundcloudControllerTwo.text;

                                          final bpmText =
                                              _bpmController.text.trim();
                                          final bpmParts = bpmText
                                              .split(' ')
                                              .first
                                              .split('-');

                                          if (bpmParts.length == 2) {
                                            widget.dj.bpm.first =
                                                int.tryParse(
                                                  bpmParts[0].trim(),
                                                ) ??
                                                0;
                                            widget.dj.bpm.last =
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
                                          await db.updateDJ(widget.dj);
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
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
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
                                                        TextDecoration
                                                            .underline,
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
      ),
    );
  }
}
