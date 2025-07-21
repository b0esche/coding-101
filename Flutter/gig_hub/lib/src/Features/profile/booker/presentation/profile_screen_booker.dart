import 'package:gig_hub/src/Data/app_imports.dart' hide UserStarRating;
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
  late final TextEditingController _infoController = TextEditingController();
  late final TextEditingController _aboutController = TextEditingController();
  late final TextEditingController _nameController = TextEditingController();
  @override
  void dispose() {
    _infoController.dispose();
    _aboutController.dispose();
    _nameController.dispose();
    super.dispose();
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
                                    widget.booker.name,
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
                                      widget.booker.about =
                                          _aboutController.text;
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
                                      widget.booker.info = _infoController.text;
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
