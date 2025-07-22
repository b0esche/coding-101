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
  Timer? _debounceTimer;

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
  late final TextEditingController _infoController = TextEditingController(
    text: widget.dj.info,
  );

  final SoundcloudAuth _soundcloudAuth = SoundcloudAuth();

  List<SoundcloudTrack> userTrackList = [];
  SoundcloudTrack? selectedTrackOne;
  SoundcloudTrack? selectedTrackTwo;

  @override
  void initState() {
    super.initState();

    _playerControllerOne = PlayerController();
    _playerControllerTwo = PlayerController();

    _locationFocusNode.addListener(_onLocationFocusChange);
    _locationController.addListener(_onLocationChanged);

    _loadTracksIfAvailable();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _locationFocusNode.removeListener(_onLocationFocusChange);
    _locationFocusNode.dispose();

    _locationController.removeListener(_onLocationChanged);

    _nameController.dispose();
    _locationController.dispose();
    _bpmController.dispose();
    _aboutController.dispose();
    _infoController.dispose();
    super.dispose();
  }

  void _onLocationChanged() {
    final input = _locationController.text.trim();

    _debounceTimer?.cancel();
    if (input.isEmpty) {
      setState(() => _locationError = ' ');
      _formKey.currentState?.validate();
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 350), () {
      _validateCity(input);
    });
  }

  void _onLocationFocusChange() {
    if (!_locationFocusNode.hasFocus) {
      _validateCity(_locationController.text);
    }
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
        setState(() {
          _locationError = ' ';
          if (editMode) {
            _formKey.currentState?.validate();
          }
        });
        throw Exception(
          'google places api error: ${data['status']} - ${data['error_message']}',
        );
      }
    } catch (e) {
      setState(() => _locationError = ' ');
      if (editMode) {
        _formKey.currentState?.validate();
      }
      throw Exception('network error during city validation: $e');
    }
  }

  Future<void> _loadTracksIfAvailable() async {
    final token = await _soundcloudAuth.getAccessToken();
    if (token == null) {
      Exception("no valid access token found");
      return;
    }

    final tracks = await SoundcloudService().fetchUserTracks();
    if (!mounted) return;
    setState(() {
      userTrackList = tracks;
    });
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
                      child: Icon(Icons.question_answer_outlined),
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
                          splashFactory: NoSplash.splashFactory,
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
                              color: Palette.gigGrey.o(0.85),
                            ),
                            shape: BoxShape.circle,
                            color: Palette.primalBlack.o(0.5),
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
                                      const Icon(
                                        Icons.location_pin,
                                        size: 15.5,
                                      ),
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
                            !editMode
                                ? Text(
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
                                      decorationStyle:
                                          TextDecorationStyle.dotted,
                                      decorationThickness: 2,
                                      fontSize: 15,
                                    ),
                                  ),
                                )
                                : SizedBox.shrink(),
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
                                : soundcloudFields(),
                          ],
                        ),
                        SizedBox(height: 36),
                        Column(
                          spacing: !editMode ? 0 : 8,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            !editMode
                                ? Text(
                                  (widget.dj.trackTitles.last.isNotEmpty)
                                      ? widget.dj.trackTitles.last
                                      : 'second track',
                                  style: GoogleFonts.sometypeMono(
                                    textStyle: TextStyle(
                                      color: Palette.glazedWhite,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Palette.glazedWhite,
                                      decorationStyle:
                                          TextDecorationStyle.dotted,
                                      decorationThickness: 2,
                                      wordSpacing: -3,
                                      fontSize: 15,
                                    ),
                                  ),
                                )
                                : SizedBox.shrink(),
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
                                : SizedBox.shrink(),
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
                                        .pickMultiImage(limit: 5);
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
                                            (selectedTrackOne == null ||
                                                selectedTrackTwo == null)) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              backgroundColor:
                                                  Palette.forgedGold,
                                              content: Center(
                                                child: Text(
                                                  'select 2 soundcloud tracks to save your profile!',
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        if (editMode &&
                                            _formKey.currentState!.validate() &&
                                            (selectedTrackOne != null &&
                                                selectedTrackTwo != null)) {
                                          !editMode
                                              ? PlayerController()
                                                  .stopAllPlayers()
                                              : PlayerController()
                                                  .overrideAudioSession;

                                          widget.dj.about =
                                              _aboutController.text;
                                          widget.dj.info = _infoController.text;
                                          widget.dj.name = _nameController.text;

                                          widget.dj.streamingUrls = [
                                            if (selectedTrackOne?.streamUrl !=
                                                null)
                                              selectedTrackOne!.streamUrl!,
                                            if (selectedTrackTwo?.streamUrl !=
                                                null)
                                              selectedTrackTwo!.streamUrl!,
                                          ];

                                          widget.dj.trackTitles = [
                                            selectedTrackOne?.title ?? '',
                                            selectedTrackTwo?.title ?? '',
                                          ];

                                          widget.dj.trackUrls = [
                                            selectedTrackOne?.permalinkUrl ??
                                                '',
                                            selectedTrackTwo?.permalinkUrl ??
                                                '',
                                          ];

                                          final bpmText =
                                              _bpmController.text.trim();
                                          final bpmParts = bpmText
                                              .split(' ')
                                              .first
                                              .split('-');
                                          if (bpmParts.length == 2) {
                                            widget.dj.bpm = [
                                              int.tryParse(
                                                    bpmParts[0].trim(),
                                                  ) ??
                                                  0,
                                              int.tryParse(
                                                    bpmParts[1].trim(),
                                                  ) ??
                                                  0,
                                            ];
                                          }

                                          if (_locationError == null) {
                                            widget.dj.city =
                                                _locationController.text;
                                          }

                                          if (!widget.dj.headImageUrl
                                              .startsWith('http')) {
                                            final headFile = File(
                                              widget.dj.headImageUrl,
                                            );
                                            final headStorageRef = FirebaseStorage
                                                .instance
                                                .ref()
                                                .child(
                                                  'head_images/${widget.dj.id}.jpg',
                                                );
                                            await headStorageRef.putFile(
                                              headFile,
                                            );
                                            widget.dj.headImageUrl =
                                                await headStorageRef
                                                    .getDownloadURL();
                                          }

                                          if (widget.dj.mediaImageUrls.any(
                                            (path) => !path.startsWith('http'),
                                          )) {
                                            List<String> newUrls = [];
                                            for (
                                              int i = 0;
                                              i <
                                                  widget
                                                      .dj
                                                      .mediaImageUrls
                                                      .length;
                                              i++
                                            ) {
                                              final path =
                                                  widget.dj.mediaImageUrls[i];
                                              if (path.startsWith('http')) {
                                                newUrls.add(path);
                                              } else {
                                                final file = File(path);
                                                final ref = FirebaseStorage
                                                    .instance
                                                    .ref()
                                                    .child(
                                                      'media_images/${widget.dj.id}_$i.jpg',
                                                    );
                                                await ref.putFile(file);
                                                final downloadUrl =
                                                    await ref.getDownloadURL();
                                                newUrls.add(downloadUrl);
                                              }
                                            }
                                            widget.dj.mediaImageUrls = newUrls;
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

  Column soundcloudFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildTrackDropdown(
          label: "first SoundCloud set",
          selectedTrack: selectedTrackOne,
          onChanged: (track) => setState(() => selectedTrackOne = track),
        ),
        const SizedBox(height: 36),
        _buildTrackDropdown(
          label: "second SoundCloud set",
          selectedTrack: selectedTrackTwo,
          onChanged: (track) => setState(() => selectedTrackTwo = track),
        ),
      ],
    );
  }

  Widget _buildTrackDropdown({
    required String label,
    required SoundcloudTrack? selectedTrack,
    required Function(SoundcloudTrack?) onChanged,
  }) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
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
          const SizedBox(height: 8),
          Container(
            width: 260,
            height: 48,
            decoration: BoxDecoration(
              border: Border.all(color: Palette.glazedWhite, width: 1),
              borderRadius: BorderRadius.circular(8),
              color: Palette.glazedWhite.o(0.2),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<SoundcloudTrack>(
                borderRadius: BorderRadius.circular(8),
                dropdownColor: Palette.primalBlack.o(0.85),
                iconEnabledColor: Palette.glazedWhite,
                value: selectedTrack,
                isExpanded: true,
                hint: Text(
                  'select track',
                  style: TextStyle(color: Palette.glazedWhite, fontSize: 11),
                ),
                style: TextStyle(color: Palette.glazedWhite, fontSize: 11),
                items:
                    userTrackList.map((track) {
                      return DropdownMenuItem<SoundcloudTrack>(
                        value: track,
                        child: Text(
                          track.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: Palette.concreteGrey,
                          ),
                        ),
                      );
                    }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
