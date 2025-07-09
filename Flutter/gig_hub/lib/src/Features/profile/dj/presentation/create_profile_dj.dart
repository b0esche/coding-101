import "dart:io";

import "package:firebase_auth/firebase_auth.dart";
import "package:gig_hub/src/Data/auth_repository.dart";
import "package:gig_hub/src/Data/firestore_repository.dart";

import "../../../../Data/app_imports.dart";
import "../../../../Data/app_imports.dart" as http;

class CreateProfileScreenDJ extends StatefulWidget {
  final DatabaseRepository repo;
  final AuthRepository auth;
  final String email;
  final String pw;
  const CreateProfileScreenDJ({
    super.key,
    required this.repo,
    required this.auth,
    required this.email,
    required this.pw,
  });

  @override
  State<CreateProfileScreenDJ> createState() => _CreateProfileScreenDJState();
}

class _CreateProfileScreenDJState extends State<CreateProfileScreenDJ> {
  DatabaseRepository repo = FirestoreDatabaseRepository();
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController();
  late final _locationController = TextEditingController(text: 'your city');
  late final _bpmController = TextEditingController(text: 'your tempo');
  late final _aboutController = TextEditingController();
  late final _infoController = TextEditingController();
  late final _soundcloudControllerOne = TextEditingController();
  late final _soundcloudControllerTwo = TextEditingController();
  final _locationFocusNode = FocusNode();
  String? headUrl;
  String? _locationError;
  String? bpmMin;
  String? bpmMax;
  String? about;
  String? info;
  List<String>? genres;
  List<String>? mediaUrl;
  int index = 0;
  bool isSoundcloudConnected = false;
  @override
  void initState() {
    _locationFocusNode.addListener(_onLocationFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    _locationFocusNode.removeListener(_onLocationFocusChange);
    _locationFocusNode.dispose();
    _nameController.dispose();
    _aboutController.dispose();
    _infoController.dispose();
    _locationController.dispose();
    _bpmController.dispose();
    super.dispose();
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
          _formKey.currentState?.validate();
        });
      } else {
        debugPrint(
          'Google Places API Error: ${data['status']} - ${data['error_message']}',
        );
        setState(() {
          _locationError = ' ';
          _formKey.currentState?.validate();
        });
      }
    } catch (e) {
      debugPrint('Network error during city validation: $e');
      setState(() {
        _locationError = ' ';
        _formKey.currentState?.validate();
      });
    }
  }

  Future<void> _showGenreDialog() async {
    final result = await showDialog<List<String>>(
      context: context,
      builder:
          (context) =>
              GenreSelectionDialog(initialSelectedGenres: genres ?? []),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        genres = result;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.primalBlack,
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 256,
                  color: Palette.gigGrey,
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 200),
                    child:
                        headUrl != null
                            ? Image.file(
                              File(headUrl!),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              key: ValueKey(headUrl!),
                            )
                            : null,
                  ),
                ),
                Center(
                  heightFactor: 4,
                  child: IconButton(
                    style: ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.padded,
                      splashFactory: NoSplash.splashFactory,
                    ),
                    onPressed: () async {
                      final XFile? newUserHeadUrl = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (newUserHeadUrl != null) {
                        setState(() {
                          headUrl = newUserHeadUrl.path;
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
                      child: Container(
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
                          onTap: _nameController.clear,
                          controller: _nameController,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Palette.glazedWhite,
                            fontSize: 12,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 14),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Palette.forgedGold,
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                          ),
                        ),
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
                          Container(
                            decoration: BoxDecoration(
                              color: Palette.shadowGrey.o(0.35),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Palette.concreteGrey),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Icon(Icons.place, size: 20),
                                  const SizedBox(width: 4),
                                  SizedBox(
                                    width: 100,
                                    height: 24,
                                    child: TextFormField(
                                      onTap: _locationController.clear,
                                      style: TextStyle(
                                        color: Palette.glazedWhite,
                                        fontSize: 10,
                                      ),
                                      textAlign: TextAlign.center,
                                      controller: _locationController,
                                      focusNode: _locationFocusNode,
                                      validator: (value) {
                                        return _locationError;
                                      },
                                      autovalidateMode:
                                          AutovalidateMode.onUnfocus,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide(
                                            color: Palette.alarmRed,
                                            width: 2,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide(
                                            color: Palette.alarmRed,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide(
                                            color: Palette.forgedGold,
                                            width: 2,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide(
                                            color: Palette.glazedWhite,
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
                              color: Palette.shadowGrey.o(0.35),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Palette.concreteGrey),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.speed, size: 24),
                                  const SizedBox(width: 4),
                                  SizedBox(
                                    width: 100,
                                    height: 24,
                                    child: TextFormField(
                                      readOnly: true,
                                      textAlign: TextAlign.center,
                                      onTap: () async {
                                        final result = await showDialog<
                                          List<int>
                                        >(
                                          context: context,
                                          builder:
                                              (context) => BpmSelectionDialog(
                                                intialSelectedBpm: [
                                                  int.tryParse(
                                                        bpmMin?.toString() ??
                                                            '',
                                                      ) ??
                                                      100,
                                                  int.tryParse(
                                                        bpmMax?.toString() ??
                                                            '',
                                                      ) ??
                                                      130,
                                                ],
                                              ),
                                        );

                                        if (result != null &&
                                            result.length == 2) {
                                          setState(() {
                                            bpmMin = result[0].toString();
                                            bpmMax = result[1].toString();
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
                                        contentPadding: EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide(
                                            color: Palette.forgedGold,
                                            width: 2,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          borderSide: BorderSide(
                                            color: Palette.glazedWhite,
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
                          Container(
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
                                  about = _aboutController.text;
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
                      const SizedBox(height: 40),
                      Center(
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: [
                            if (genres != null && genres!.isNotEmpty) ...[
                              ...genres!.map(
                                (genre) => GenreBubble(genre: genre),
                              ),
                            ],
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Palette.forgedGold,
                                  width: 2.7,
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
                      const SizedBox(height: 48),
                      IndexedStack(
                        index: isSoundcloudConnected ? 0 : 1,
                        children: [
                          soundcloudFields(),
                          connectToSoundcloudButton(),
                        ],
                      ),

                      SizedBox(height: isSoundcloudConnected ? 72 : 0),
                      (mediaUrl != null && mediaUrl!.isNotEmpty)
                          ? ClipRRect(
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
                              children:
                                  mediaUrl!.map((path) {
                                    return PinchZoom(
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
                                    );
                                  }).toList(),
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
                                  List<String> newMediaUrls =
                                      medias
                                          .map((element) => element.path)
                                          .toList();
                                  setState(() {
                                    mediaUrl = newMediaUrls;
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
                      SizedBox(height: 8),
                      (mediaUrl != null && mediaUrl!.isNotEmpty)
                          ? Center(
                            child: TextButton(
                              onPressed:
                                  () => setState(() {
                                    mediaUrl!.clear();
                                  }),
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
                              ),
                            ),
                          ),

                          Container(
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
                                setState(() => info = _infoController.text);
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
                          child: OutlinedButton(
                            onPressed: () async {
                              FocusManager.instance.primaryFocus?.unfocus();

                              if (headUrl?.isNotEmpty == true &&
                                  bpmMin?.isNotEmpty == true &&
                                  bpmMax?.isNotEmpty == true &&
                                  _nameController.text.isNotEmpty) {
                                try {
                                  // 1. User anlegen
                                  await widget.auth
                                      .createUserWithEmailAndPassword(
                                        widget.email,
                                        widget.pw,
                                      );

                                  // 2. UID abrufen
                                  final userId =
                                      FirebaseAuth.instance.currentUser?.uid;
                                  if (userId == null) {
                                    throw Exception(
                                      "Fehler beim Abrufen der UID nach Registrierung.",
                                    );
                                  }

                                  // 3. DJ speichern
                                  final dj = DJ(
                                    id: userId,
                                    genres: genres!,
                                    headImageUrl: headUrl!,
                                    avatarImageUrl: 'https://picsum.photos/100',
                                    bpm: [
                                      int.parse(bpmMin!),
                                      int.parse(bpmMax!),
                                    ],
                                    about: _aboutController.text,
                                    streamingUrls: [],
                                    mediaImageUrls: mediaUrl ?? [],
                                    info: _infoController.text,
                                    name: _nameController.text,
                                    userRating: 0,
                                    city: _locationController.text,
                                    favoriteUIds: [],
                                  );

                                  await repo.createDJ(dj);
                                } catch (e) {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Palette.forgedGold,
                                      content: Center(
                                        child: Text(
                                          "failed to create profile, try again later!",
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            style: ButtonStyle(
                              splashFactory: NoSplash.splashFactory,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                                      "done",
                                      style: GoogleFonts.sometypeMono(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: Palette.glazedWhite,
                                          decoration: TextDecoration.underline,
                                          decorationColor: Palette.glazedWhite,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.done,
                                      size: 14,
                                      color: Palette.glazedWhite,
                                    ),
                                  ],
                                ),
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
      ),
    );
  }

  Column soundcloudFields() {
    return Column(
      children: [
        Column(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "first SoundCloud set link", // TODO: artist info von soundcloud api fetchen
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
            Center(
              child: Container(
                width: 260,
                height: 48,
                decoration: BoxDecoration(
                  border: Border.all(color: Palette.glazedWhite, width: 1),
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
                  autovalidateMode: AutovalidateMode.onUnfocus,

                  decoration: InputDecoration(
                    prefixIcon:
                        _soundcloudControllerOne.text.isEmpty
                            ? null
                            : RemoveButton(
                              soundcloudController: _soundcloudControllerOne,
                            ),

                    suffixIcon: PasteButton(
                      soundcloudController: _soundcloudControllerOne,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Palette.forgedGold,
                        width: 3,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Palette.forgedGold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
        Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "second SoundCloud set link", // TODO: artist info von soundcloud api fetchen
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
            Center(
              child: Container(
                width: 260,
                height: 48,
                decoration: BoxDecoration(
                  border: Border.all(color: Palette.glazedWhite, width: 1),
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
                  autovalidateMode: AutovalidateMode.onUnfocus,
                  decoration: InputDecoration(
                    prefixIcon:
                        _soundcloudControllerTwo.text.isEmpty
                            ? null
                            : RemoveButton(
                              soundcloudController: _soundcloudControllerTwo,
                            ),
                    suffixIcon: PasteButton(
                      soundcloudController: _soundcloudControllerTwo,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Palette.forgedGold,
                        width: 3,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Palette.forgedGold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget connectToSoundcloudButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            isSoundcloudConnected = !isSoundcloudConnected;
          });
        },
        child: Text('moin'),
      ),
    );
  }
}
