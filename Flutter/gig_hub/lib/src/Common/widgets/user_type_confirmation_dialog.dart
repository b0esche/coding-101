import 'package:gig_hub/src/Data/app_imports.dart';

class UserTypeConfirmationDialog extends StatelessWidget {
  final String selectedUserType; // 'dj' or 'booker'
  final String userEmail;

  const UserTypeConfirmationDialog({
    super.key,
    required this.selectedUserType,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    final isDJ = selectedUserType == 'dj';
    final userTypeText = isDJ ? 'DJ' : 'Booker';
    final alternateType = isDJ ? 'Booker' : 'DJ';

    return AlertDialog(
      backgroundColor: Palette.primalBlack,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Palette.forgedGold, width: 2),
      ),
      title: Center(
        child: Text(
          'Continue as $userTypeText?',
          style: GoogleFonts.outfit(
            color: Palette.glazedWhite,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'You selected $userTypeText before signing in.',
            style: TextStyle(color: Palette.glazedWhite.o(0.8), fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'Would you like to continue as a $userTypeText or switch to $alternateType?',
            style: TextStyle(color: Palette.glazedWhite.o(0.8), fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigate to alternate type profile creation
                  _navigateToProfileCreation(context, !isDJ, userEmail);
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Palette.glazedWhite, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Change to $alternateType',
                  style: TextStyle(color: Palette.glazedWhite, fontSize: 12),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigate to selected type profile creation
                  _navigateToProfileCreation(context, isDJ, userEmail);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.forgedGold,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Continue as $userTypeText',
                  style: TextStyle(
                    color: Palette.primalBlack,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _navigateToProfileCreation(
    BuildContext context,
    bool isDJ,
    String email,
  ) {
    if (isDJ) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder:
              (context) => CreateProfileScreenDJ(
                email: email,
                pw: '', // Social login doesn't use password
              ),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder:
              (context) => CreateProfileScreenBooker(
                email: email,
                pw: '', // Social login doesn't use password
              ),
        ),
      );
    }
  }
}
