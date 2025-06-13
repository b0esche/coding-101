import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gig_hub/src/Theme/palette.dart';
import 'package:gig_hub/src/Features/search/presentation/custom_form_field.dart';
import 'package:http/http.dart' as http;

class LocationAutocompleteField extends StatefulWidget {
  final void Function(String) onCitySelected;
  final TextEditingController? controller;

  const LocationAutocompleteField({
    super.key,
    required this.onCitySelected,
    this.controller,
  });

  @override
  State<LocationAutocompleteField> createState() =>
      _LocationAutocompleteFieldState();
}

class _LocationAutocompleteFieldState extends State<LocationAutocompleteField> {
  late TextEditingController _internalController;
  String? _bestSuggestion;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _internalController = widget.controller ?? TextEditingController();
    _internalController.addListener(_onControllerTextChanged);
  }

  @override
  void dispose() {
    _internalController.removeListener(_onControllerTextChanged);
    _debounceTimer?.cancel();
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  void _onControllerTextChanged() {
    final input = _internalController.text;

    if (input.isEmpty) {
      setState(() {
        _bestSuggestion = null;
      });
      widget.onCitySelected('');
      return;
    }

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 350), () {
      if (input != _bestSuggestion) {
        _fetchBestSuggestion(input);
      }
    });

    widget.onCitySelected(input);
  }

  Future<void> _fetchBestSuggestion(String input) async {
    final apiKey = dotenv.env['GOOGLE_API_KEY'];
    if (apiKey == null || apiKey.isEmpty || input.isEmpty) {
      setState(() {
        _bestSuggestion = null;
      });
      return;
    }

    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json'
        '?input=$input'
        '&types=(cities)'
        '&language=en'
        '&key=$apiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'OK') {
          final predictions = data['predictions'] as List;

          if (predictions.isNotEmpty) {
            setState(() {
              _bestSuggestion = predictions.first['description'];
            });
          } else {
            setState(() {
              _bestSuggestion = null;
            });
          }
        } else {
          debugPrint('Google Places API Error: ${data['status']}');
          setState(() {
            _bestSuggestion = null;
          });
        }
      } else {
        debugPrint(
          'HTTP Error fetching suggestion: ${response.statusCode} - ${response.reasonPhrase}',
        );
        setState(() {
          _bestSuggestion = null;
        });
      }
    } catch (e) {
      debugPrint('Exception while fetching location suggestion: $e');
      setState(() {
        _bestSuggestion = null;
      });
    }
  }

  void _applySuggestion() {
    if (_bestSuggestion != null &&
        _bestSuggestion != _internalController.text) {
      final cityOnly = _bestSuggestion!.split(',')[0].trim();

      _internalController.text = cityOnly;
      _internalController.selection = TextSelection.fromPosition(
        TextPosition(offset: _internalController.text.length),
      );
      widget.onCitySelected(cityOnly);
      setState(() {
        _bestSuggestion = null;
      });
    } else if (_bestSuggestion != null) {
      final cityOnly = _internalController.text.split(',')[0].trim();
      widget.onCitySelected(cityOnly);
      setState(() {
        _bestSuggestion = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CustomFormField(
          controller: _internalController,
          readOnly: false,
          label: "location...",
          onPressed: null,
          onChanged: (value) {},
          suffixIcon:
              _bestSuggestion != null &&
                      _bestSuggestion != _internalController.text
                  ? GestureDetector(
                    onTap: _applySuggestion,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        _bestSuggestion!,
                        style: TextStyle(
                          color: Palette.forgedGold,
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  : null,
        ),
      ],
    );
  }
}
