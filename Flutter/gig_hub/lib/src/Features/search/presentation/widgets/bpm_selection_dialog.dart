import 'package:flutter/material.dart';
import 'package:gig_hub/src/Theme/palette.dart';

class BpmSelectionDialog extends StatefulWidget {
  final List<int>? intialSelectedBpm;

  const BpmSelectionDialog({super.key, required this.intialSelectedBpm});

  @override
  State<BpmSelectionDialog> createState() => _BpmSelectionDialogState();
}

class _BpmSelectionDialogState extends State<BpmSelectionDialog> {
  RangeValues bpmRange = const RangeValues(80, 140);

  @override
  void initState() {
    super.initState();
    if (widget.intialSelectedBpm != null &&
        widget.intialSelectedBpm!.length == 2) {
      bpmRange = RangeValues(
        widget.intialSelectedBpm![0].toDouble(),
        widget.intialSelectedBpm![1].toDouble(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Center(
        child: Text(
          "select bpm range",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Palette.primalBlack,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
      backgroundColor: Palette.forgedGold.o(0.95),
      children: [
        SizedBox(
          height: 160,
          width: 300,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            color: Palette.shadowGrey.o(0.6),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '${bpmRange.start.round()} - ${bpmRange.end.round()} bpm',
                    style: TextStyle(
                      color: Palette.primalBlack,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(
                      context,
                    ).copyWith(showValueIndicator: ShowValueIndicator.never),
                    child: RangeSlider(
                      min: 60,
                      max: 200,
                      divisions: 140,
                      labels: RangeLabels(
                        bpmRange.start.round().toString(),
                        bpmRange.end.round().toString(),
                      ),
                      values: bpmRange,
                      activeColor: Palette.forgedGold.o(0.9),
                      inactiveColor: Palette.primalBlack.o(0.3),
                      onChanged: (RangeValues values) {
                        setState(() {
                          bpmRange = values;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 12, top: 8),
            child: Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                border: BoxBorder.all(color: Palette.shadowGrey),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: IconButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).pop([bpmRange.start.round(), bpmRange.end.round()]);
                  },
                  icon: Icon(Icons.check, color: Palette.shadowGrey, size: 19),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
