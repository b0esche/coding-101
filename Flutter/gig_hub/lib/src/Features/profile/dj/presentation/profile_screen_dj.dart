import 'package:gig_hub/src/Features/profile/dj/presentation/widgets/track_selection_dropdown.dart';
import 'package:gig_hub/src/data/services/image_compression_service.dart';
import "../../../../Data/app_imports.dart";
import "../../../../Data/app_imports.dart" as http;
import 'package:gig_hub/src/data/services/places_validation_service.dart';

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

  bool isUploading = false;

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
    final trimmedValue = value.trim();

    if (trimmedValue.isEmpty) {
      setState(() => _locationError = ' ');
      _formKey.currentState?.validate();
      return;
    }

    setState(() {
      _locationError = null;
    });

    try {
      final isValidCityFound = await PlacesValidationService.validateCity(
        trimmedValue,
      );
      setState(() {
        _locationError = isValidCityFound ? null : ' ';
        if (editMode) {
          _formKey.currentState?.validate();
        }
      });
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

                  if (editMode)
                    Positioned(
                      top: 120,
                      left: 180,
                      child: IconButton(
                        style: ButtonStyle(
                          tapTargetSize: MaterialTapTargetSize.padded,
                          splashFactory: NoSplash.splashFactory,
                        ),
                        onPressed: () async {
                          final XFile? picked = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );

                          if (picked != null) {
                            final File originalFile = File(picked.path);
                            final File compressedFile =
                                await ImageCompressionService.compressImage(
                                  originalFile,
                                );

                            setState(() {
                              widget.dj.headImageUrl = compressedFile.path;
                            });
                          }
                        },
                        icon: Icon(
                          Icons.file_upload_rounded,
                          color: Palette.concreteGrey,
                          size: 48,
                        ),
                      ),
                    ),
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
                  if (widget.showFavoriteIcon &&
                      !(widget.currentUser is DJ &&
                          (widget.currentUser as DJ).id == widget.dj.id))
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.65,
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
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color:
                                isFavorite
                                    ? Palette.favoriteRed
                                    : Palette.glazedWhite,
                            size: 22,
                          ),
                          onPressed: () async {
                            final String targetId = widget.dj.id;
                            final String userId = widget.currentUser.id;
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

                              if (widget.currentUser is Guest) {
                                (widget.currentUser as Guest).favoriteUIds.add(
                                  targetId,
                                );
                              } else if (widget.currentUser is Booker) {
                                (widget.currentUser as Booker).favoriteUIds.add(
                                  targetId,
                                );
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

                              if (widget.currentUser is Guest) {
                                (widget.currentUser as Guest).favoriteUIds
                                    .remove(targetId);
                              } else if (widget.currentUser is Booker) {
                                (widget.currentUser as Booker).favoriteUIds
                                    .remove(targetId);
                              } else if (widget.currentUser is DJ) {
                                (widget.currentUser as DJ).favoriteUIds.remove(
                                  targetId,
                                );
                              }
                            }

                            setState(() {});
                          },
                        ),
                      ),
                    ),
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
                                      fontSize: 15,
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
                  if (!editMode) UserStarRating(widget: widget),

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
                                      Icon(
                                        Icons.location_pin,
                                        size: 17,
                                        color: Palette.primalBlack,
                                      ),
                                      const SizedBox(width: 4),
                                      !editMode
                                          ? Text(
                                            widget.dj.city,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: Palette.primalBlack,
                                            ),
                                          )
                                          : Container(
                                            width: 136,
                                            height: 32,
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
                                                fontSize: 14,
                                                color: Palette.glazedWhite,
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
                                      const Icon(Icons.speed, size: 22),
                                      const SizedBox(width: 4),
                                      !editMode
                                          ? Text(
                                            '${widget.dj.bpm.first}-${widget.dj.bpm.last} bpm',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: Palette.primalBlack,
                                            ),
                                          )
                                          : Container(
                                            width: 136,
                                            height: 32,
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
                                                fontSize: 14,
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
                                  fontSize: 15,
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
                            if (!editMode)
                              Text(
                                (widget.dj.trackTitles.isNotEmpty)
                                    ? widget.dj.trackTitles.first
                                    : 'first Track',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.sometypeMono(
                                  textStyle: TextStyle(
                                    wordSpacing: -3,
                                    color: Palette.glazedWhite,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Palette.glazedWhite,
                                    decorationStyle: TextDecorationStyle.dotted,
                                    decorationThickness: 2,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 8),
                            !editMode
                                ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    AudioPlayerWidget(
                                      audioUrl: widget.dj.streamingUrls.first,
                                      playerController: _playerControllerOne,
                                    ),
                                    IconButton(
                                      style: ButtonStyle(
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
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
                        const SizedBox(height: 36),
                        Column(
                          spacing: !editMode ? 0 : 8,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (!editMode)
                              Text(
                                (widget.dj.trackTitles.last.isNotEmpty)
                                    ? widget.dj.trackTitles.last
                                    : 'second track',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.sometypeMono(
                                  textStyle: TextStyle(
                                    color: Palette.glazedWhite,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Palette.glazedWhite,
                                    decorationStyle: TextDecorationStyle.dotted,
                                    decorationThickness: 2,
                                    wordSpacing: -3,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 8),
                            if (!editMode)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  AudioPlayerWidget(
                                    audioUrl: widget.dj.streamingUrls.last,
                                    playerController: _playerControllerTwo,
                                  ),
                                  IconButton(
                                    style: ButtonStyle(
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    onPressed: () {
                                      launchUrlString(widget.dj.trackUrls.last);
                                    },
                                    icon: SvgPicture.asset(
                                      'assets/icons/soundcloud.svg',
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 36),
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
                                    List<String> newMediaUrls = [];
                                    for (XFile xfile in medias) {
                                      File originalFile = File(xfile.path);
                                      File compressedFile =
                                          await ImageCompressionService.compressImage(
                                            originalFile,
                                          );
                                      newMediaUrls.add(compressedFile.path);
                                    }
                                    List<String> mediaUrls = newMediaUrls;
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
                        if (widget.dj.mediaImageUrls.isNotEmpty && editMode)
                          Center(
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
                          ),

                        if (widget.dj.mediaImageUrls.isNotEmpty)
                          SizedBox(height: 36),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              " info / requirements",
                              style: GoogleFonts.sometypeMono(
                                textStyle: TextStyle(
                                  color: Palette.glazedWhite,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
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
                                        !editMode
                                            ? PlayerController()
                                                .stopAllPlayers()
                                            : PlayerController()
                                                .overrideAudioSession;
                                        if (editMode &&
                                            _formKey.currentState!.validate() &&
                                            (selectedTrackOne != null &&
                                                selectedTrackTwo != null)) {
                                          if (editMode) {
                                            setState(() {
                                              isUploading = !isUploading;
                                            });
                                          }

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

                                          setState(() {
                                            isUploading = !isUploading;
                                            editMode = !editMode;
                                          });
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
                                              !isUploading
                                                  ? Text(
                                                    !editMode
                                                        ? "edit profile"
                                                        : "done",
                                                    style:
                                                        GoogleFonts.sometypeMono(
                                                          textStyle: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 14,
                                                            color:
                                                                Palette
                                                                    .glazedWhite,
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                            decorationColor:
                                                                Palette
                                                                    .glazedWhite,
                                                          ),
                                                        ),
                                                  )
                                                  : SizedBox.square(
                                                    dimension: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                          color:
                                                              Palette
                                                                  .forgedGold,
                                                          strokeWidth: 2,
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
        TrackSelectionDropdown(
          userTrackList: userTrackList,
          label: "first SoundCloud set",
          selectedTrack: selectedTrackOne,
          onChanged: (track) => setState(() => selectedTrackOne = track),
        ),
        const SizedBox(height: 36),
        TrackSelectionDropdown(
          userTrackList: userTrackList,
          label: "second SoundCloud set",
          selectedTrack: selectedTrackTwo,
          onChanged: (track) => setState(() => selectedTrackTwo = track),
        ),
      ],
    );
  }
}
