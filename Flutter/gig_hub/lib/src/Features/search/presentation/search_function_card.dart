import 'package:flutter/material.dart';
import 'package:gig_hub/src/Data/database_repository.dart';
import 'package:gig_hub/src/Data/user.dart';
import 'package:gig_hub/src/Features/search/presentation/custom_form_field.dart';
import 'package:gig_hub/src/Features/search/presentation/widgets/bpm_selection_dialog.dart';
import 'package:gig_hub/src/Features/search/presentation/widgets/genre_selection_dialog.dart';
import 'package:gig_hub/src/Features/search/presentation/widgets/location_picker.dart';
import 'package:gig_hub/src/Theme/palette.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchFunctionCard extends StatefulWidget {
  final void Function(List<DJ>) onSearchResults;
  final void Function(bool) onSearchLoading;

  const SearchFunctionCard({
    required this.onSearchResults,
    required this.onSearchLoading,
    super.key,
  });

  @override
  State<SearchFunctionCard> createState() => _SearchFunctionCardState();
}

class _SearchFunctionCardState extends State<SearchFunctionCard> {
  List<String> selectedGenres = [];
  List<int>? selectedBpm;
  String? selectedCity;
  final TextEditingController genreController = TextEditingController();
  final TextEditingController bpmController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  void _showGenreDialog() async {
    final List<String>? result = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return GenreSelectionDialog(initialSelectedGenres: selectedGenres);
      },
    );

    if (result != null && mounted) {
      setState(() {
        selectedGenres = result;
        genreController.text = selectedGenres.join(', ');
      });
    }
  }

  void _showBpmDialog() async {
    final List<int>? bpmValues = await showDialog<List<int>>(
      context: context,
      builder: (BuildContext context) {
        return BpmSelectionDialog(intialSelectedBpm: selectedBpm);
      },
    );
    if (bpmValues != null && mounted) {
      setState(() {
        selectedBpm = bpmValues;
        bpmController.text =
            bpmValues[0] == bpmValues[1]
                ? "${bpmValues[0]}"
                : "${bpmValues[0]} - ${bpmValues[1]}";
      });
    }
  }

  Future<void> _search() async {
    widget.onSearchLoading(true);

    final repo = MockDatabaseRepository();
    final results = await repo.searchDJs(
      city: selectedCity,
      genres: selectedGenres,
      bpmRange: selectedBpm,
    );

    widget.onSearchResults(results);

    if (mounted) {
      widget.onSearchLoading(false);
    }
  }

  @override
  void dispose() {
    genreController.dispose();
    bpmController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 192,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 3,
        color: Palette.glazedWhite,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomFormField(
                readOnly: true,
                label: "genre...",
                onPressed: _showGenreDialog,
                controller: genreController,
              ),
              const SizedBox(height: 8),
              CustomFormField(
                readOnly: true,
                label: "bpm...",
                onPressed: _showBpmDialog,
                controller: bpmController,
              ),
              const SizedBox(height: 8),
              LocationAutocompleteField(
                controller: locationController,
                onCitySelected: (city) {
                  setState(() {
                    selectedCity = city;
                  });
                },
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(width: 85),
                  ElevatedButton(
                    onPressed: _search,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.shadowGrey,
                      splashFactory: NoSplash.splashFactory,
                      maximumSize: const Size(150, 24),
                      minimumSize: const Size(88, 22),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Palette.concreteGrey),
                      ),
                      elevation: 3,
                    ),
                    child: Text(
                      "search",
                      style: GoogleFonts.sometypeMono(
                        textStyle: TextStyle(
                          color: Palette.primalBlack,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.resolveWith<Color>((
                        states,
                      ) {
                        if (states.contains(WidgetState.pressed)) {
                          return Palette.forgedGold;
                        }
                        return Palette.primalBlack;
                      }),
                      alignment: Alignment.bottomCenter,
                      splashFactory: NoSplash.splashFactory,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedGenres.clear();
                        selectedBpm = null;
                        selectedCity = null;
                        genreController.clear();
                        bpmController.clear();
                        locationController.clear();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Palette.shadowGrey,
                        border: Border.all(color: Palette.concreteGrey),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(6),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Palette.gigGrey,
                            blurRadius: 4,
                            offset: const Offset(0.5, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                        child: Text(
                          "clear",
                          style: GoogleFonts.sometypeMono(
                            textStyle: const TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
