import 'package:gig_hub/src/Data/app_imports.dart';

class BpmDisplay extends StatelessWidget {
  const BpmDisplay({super.key, required this.widget});

  final ProfileScreenDJ widget;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${widget.dj.bpm.first}-${widget.dj.bpm.last} bpm',
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Palette.primalBlack,
      ),
    );
  }
}
