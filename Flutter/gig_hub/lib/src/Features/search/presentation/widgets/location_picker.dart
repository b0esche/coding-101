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

  @override
  void initState() {
    super.initState();
    _internalController = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController.dispose();
    }
    super.dispose();
  }

  Future<void> _fetchBestSuggestion(String input) async {
    final apiKey = dotenv.env['GOOGLE_API_KEY'];
    if (apiKey == null || apiKey.isEmpty || input.isEmpty) return;

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json'
      '?input=$input'
      '&types=geocode'
      '&components=country:de'
      '&language=de'
      '&key=$apiKey',
    );

    final response = await http.get(url);
    final data = jsonDecode(response.body);

    if (data['status'] == 'OK') {
      final predictions = data['predictions'] as List;

      final onlyCities =
          predictions.where((p) {
            final types = List<String>.from(p['types']);
            return types.contains('locality') ||
                types.contains('administrative_area_level_1');
          }).toList();

      if (onlyCities.isNotEmpty) {
        setState(() {
          _bestSuggestion = onlyCities.first['description'];
        });
      }
    }
  }

  void _applySuggestion() {
    if (_bestSuggestion != null) {
      _internalController.text = _bestSuggestion!;
      widget.onCitySelected(_bestSuggestion!);
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
          onChanged: (value) {
            _fetchBestSuggestion(value);
            widget.onCitySelected(value);
          },
          suffixIcon:
              _bestSuggestion != null &&
                      _bestSuggestion != _internalController.text
                  ? IconButton(
                    icon: Icon(
                      Icons.arrow_circle_down,
                      color: Palette.forgedGold,
                    ),
                    onPressed: _applySuggestion,
                    tooltip: _bestSuggestion,
                  )
                  : null,
        ),
      ],
    );
  }
}
