import 'package:flutter/material.dart';

class RangeTryout extends StatefulWidget {
  const RangeTryout({super.key});

  @override
  State<RangeTryout> createState() => _RangeTryoutState();
}

class _RangeTryoutState extends State<RangeTryout> {
  RangeValues _currentRange = const RangeValues(80, 200);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("RangeSlider Tryout")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RangeSlider(
              values: _currentRange,
              min: 80,
              max: 200,
              divisions: 24,
              labels: RangeLabels(
                _currentRange.start.round().toString(),
                _currentRange.end.round().toString(),
              ),
              onChanged: (RangeValues newRange) {
                setState(() {
                  _currentRange = newRange;
                });
              },
            ),
            const SizedBox(height: 20),
            Text(
              "Selected Range: ${_currentRange.start.round()} - ${_currentRange.end.round()}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
