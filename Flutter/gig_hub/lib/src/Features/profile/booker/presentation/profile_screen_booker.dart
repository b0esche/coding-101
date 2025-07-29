import 'package:gig_hub/src/Data/app_imports.dart' hide UserStarRating;
import 'package:http/http.dart' as http;
import 'package:gig_hub/src/Features/profile/booker/presentation/star_rating_booker.dart';

class ProfileScreenBookerArgs {
  final Booker booker;
  final DatabaseRepository db;
  final bool showEditButton;

  ProfileScreenBookerArgs({
    required this.booker,
    required this.db,
    required this.showEditButton,
  });
}

class ProfileScreenBooker extends StatefulWidget {
  static const routeName = '/profileBooker';

  final Booker booker;
  final dynamic db;
  final bool showEditButton;

  const ProfileScreenBooker({
    super.key,
    required this.booker,
    required this.db,
    required this.showEditButton,
  });

  @override
  State<ProfileScreenBooker> createState() => _ProfileScreenBookerState();
}

class _ProfileScreenBookerState extends State<ProfileScreenBooker> {
  int index = 0;

  bool editMode = false;

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _infoController = TextEditingController(
    text: widget.booker.info,
  );
  late final TextEditingController _aboutController = TextEditingController(
    text: widget.booker.about,
  );
  late final TextEditingController _nameController = TextEditingController(
    text: widget.booker.name,
  );
  late final TextEditingController _locationController = TextEditingController(
    text: widget.booker.city,
  );
  String? _locationError;

  @override
  void dispose() {
    _infoController.dispose();
    _aboutController.dispose();
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> validateCityInput() async {
    final apiKey = dotenv.env['GOOGLE_API_KEY'];
    final trimmedValue = _locationController.text.trim();
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
          widget.booker.city = trimmedValue;
          _formKey.currentState?.validate();
        });
      } else {
        setState(() {
          _locationError = ' ';
          _formKey.currentState?.validate();
        });
      }
    } catch (e) {
      setState(() {
        _locationError = ' ';
        _formKey.currentState?.validate();
      });
    }
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
                SizedBox(
                  width: double.infinity,
                  height: 256,
                  child:
                      !widget.booker.headImageUrl.startsWith('http')
                          ? Image.file(
                            File(widget.booker.headImageUrl),
                            fit: BoxFit.cover,
                            colorBlendMode:
                                editMode ? BlendMode.difference : null,
                            color: editMode ? Palette.primalBlack : null,
                          )
                          : Image.network(
                            widget.booker.headImageUrl,
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
                          final XFile? newMedia = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );
                          if (newMedia != null) {
                            setState(() {
                              widget.booker.headImageUrl = newMedia.path;
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
                        Navigator.of(context).pop();
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
                      child:
                          !editMode
                              ? Text(
                                widget.booker.name,
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
                                      widget.booker.name = _nameController.text;
                                    });
                                  },
                                  style: TextStyle(
                                    color: Palette.glazedWhite,
                                    fontSize: 14,
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
                                  const Icon(Icons.location_pin, size: 18),
                                  const SizedBox(width: 4),
                                  !editMode
                                      ? Text(
                                        widget.booker.city,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Palette.primalBlack,
                                        ),
                                      )
                                      : SizedBox(
                                        width: 136,
                                        height: 24,
                                        child: TextFormField(
                                          onEditingComplete: validateCityInput,
                                          style: TextStyle(
                                            color: Palette.glazedWhite,
                                            fontSize: 14,
                                          ),
                                          controller: _locationController,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                              bottom: 12,
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: Palette.forgedGold,
                                                width: 2,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: Palette.glazedWhite,
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: Palette.alarmRed,
                                              ),
                                            ),
                                            errorText: _locationError,
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
                                  const Icon(
                                    Icons.house_siding_rounded,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 4),
                                  !editMode
                                      ? Text(
                                        widget.booker.category,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Palette.primalBlack,
                                        ),
                                      )
                                      : SizedBox(
                                        width: 136,
                                        height: 24,
                                        child: DropdownButtonFormField<String>(
                                          value:
                                              widget.booker.category.isNotEmpty
                                                  ? widget.booker.category
                                                  : 'Club',
                                          items:
                                              [
                                                    'Club',
                                                    'Event',
                                                    'Outdoor Event',
                                                    'Bar',
                                                    'Pop-Up',
                                                    'Collective',
                                                    'Festival',
                                                  ]
                                                  .map(
                                                    (cat) => DropdownMenuItem(
                                                      value: cat,
                                                      child: Text(
                                                        cat,
                                                        style: TextStyle(
                                                          color:
                                                              Palette
                                                                  .glazedWhite,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                          onChanged: (val) {
                                            if (val != null) {
                                              setState(() {
                                                widget.booker.category = val;
                                              });
                                            }
                                          },
                                          dropdownColor: Palette.gigGrey.o(0.9),
                                          decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 0,
                                                ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: Palette.glazedWhite,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: Palette.forgedGold,
                                                width: 2,
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
                                    widget.booker.about,
                                    style: TextStyle(
                                      color: Palette.primalBlack,
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
                                      widget.booker.about =
                                          _aboutController.text;
                                    });
                                  },
                                  minLines: 1,
                                  maxLines: 7,
                                  maxLength: 250,
                                  style: TextStyle(
                                    color: Palette.glazedWhite,
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
                      !editMode
                          ? widget.booker.mediaImageUrls.isEmpty
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
                                    if (widget.booker.mediaImageUrls.isNotEmpty)
                                      for (String path
                                          in widget.booker.mediaImageUrls)
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
                                    widget.booker.mediaImageUrls.addAll(
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
                                    widget.booker.info,
                                    style: TextStyle(
                                      color: Palette.primalBlack,
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
                                      widget.booker.info = _infoController.text;
                                    });
                                  },
                                  minLines: 1,
                                  maxLines: 7,
                                  maxLength: 250,
                                  cursorColor: Palette.forgedGold,

                                  style: TextStyle(
                                    color: Palette.glazedWhite,
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
                                        widget.booker.about =
                                            _aboutController.text;
                                        widget.booker.info =
                                            _infoController.text;
                                        widget.booker.name =
                                            _nameController.text;
                                        if (_locationError == null) {
                                          widget.booker.city =
                                              _locationController.text;
                                        }

                                        if (!widget.booker.headImageUrl
                                            .startsWith('http')) {
                                          final headFile = File(
                                            widget.booker.headImageUrl,
                                          );
                                          final headStorageRef = FirebaseStorage
                                              .instance
                                              .ref()
                                              .child(
                                                'booker_head_images/${widget.booker.id}.jpg',
                                              );
                                          await headStorageRef.putFile(
                                            headFile,
                                          );
                                          widget.booker.headImageUrl =
                                              await headStorageRef
                                                  .getDownloadURL();
                                        }

                                        if (widget.booker.mediaImageUrls.any(
                                          (path) => !path.startsWith('http'),
                                        )) {
                                          List<String> newUrls = [];
                                          for (
                                            int i = 0;
                                            i <
                                                widget
                                                    .booker
                                                    .mediaImageUrls
                                                    .length;
                                            i++
                                          ) {
                                            final path =
                                                widget.booker.mediaImageUrls[i];
                                            if (path.startsWith('http')) {
                                              newUrls.add(path);
                                            } else {
                                              final file = File(path);
                                              final ref = FirebaseStorage
                                                  .instance
                                                  .ref()
                                                  .child(
                                                    'booker_media_images/${widget.booker.id}_$i.jpg',
                                                  );
                                              await ref.putFile(file);
                                              final downloadUrl =
                                                  await ref.getDownloadURL();
                                              newUrls.add(downloadUrl);
                                            }
                                          }
                                          widget.booker.mediaImageUrls =
                                              newUrls;
                                        }

                                        try {
                                          await widget.db.updateBooker(
                                            widget.booker,
                                          );
                                        } catch (e) {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                backgroundColor:
                                                    Palette.forgedGold,
                                                content: Center(
                                                  child: Text(
                                                    'error: ${e.toString()}',
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      }
                                      setState(() {
                                        editMode = !editMode;
                                      });
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
