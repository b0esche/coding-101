import 'package:cloud_functions/cloud_functions.dart';
import 'package:gig_hub/src/Data/app_imports.dart';

class UserStarRating extends StatefulWidget {
  const UserStarRating({super.key, required this.widget});

  final ProfileScreenDJ widget;

  @override
  State<UserStarRating> createState() => _UserStarRatingState();
}

class _UserStarRatingState extends State<UserStarRating> {
  double currentRating = 0;
  int ratingCount = 0;

  Future<void> submitRating(double value) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    try {
      final functions = FirebaseFunctions.instanceFor(
        app: Firebase.app(),
        region: 'us-central1',
      );

      final callable = functions.httpsCallable('submitRating');

      final result = await callable.call({
        'raterId': currentUser!.uid,
        'targetUserId': widget.widget.dj.id,
        'rawRating': value,
      });

      setState(() {
        currentRating = (result.data['avgRating'] as num).toDouble();
        ratingCount = result.data['ratingCount'] ?? ratingCount;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Palette.forgedGold,
            duration: Duration(milliseconds: 950),
            content: Center(
              child: Text('rating submitted!', style: TextStyle(fontSize: 16)),
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('request error: $e');
    }
  }

  @override
  void initState() {
    currentRating = widget.widget.dj.avgRating;
    ratingCount = widget.widget.dj.ratingCount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 140,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12),
            topLeft: Radius.circular(12),
          ),
          color: Palette.primalBlack.o(0.7),
          border: Border(
            left: BorderSide(width: 2, color: Palette.gigGrey.o(0.6)),
            top: BorderSide(width: 2, color: Palette.gigGrey.o(0.6)),
            bottom: BorderSide(width: 2, color: Palette.gigGrey.o(0.6)),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 2, top: 2, bottom: 2),
          child: RatingStars(
            value: currentRating,
            starBuilder:
                (index, color) => Icon(Icons.star, color: color, size: 18),
            starCount: 5,
            maxValue: 5,
            axis: Axis.vertical,
            angle: 15,
            starSpacing: 0,
            starSize: 18,
            valueLabelVisibility: false,
            animationDuration: const Duration(milliseconds: 350),
            starOffColor: Palette.shadowGrey,
            starColor: Palette.forgedGold,
            onValueChanged: (value) async {
              await submitRating(value);
            },
          ),
        ),
      ),
    );
  }
}
