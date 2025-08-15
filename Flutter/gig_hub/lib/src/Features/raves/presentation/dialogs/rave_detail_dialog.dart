import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import '../../../../Data/models/rave.dart';
import '../../../../Data/services/localization_service.dart';
import '../../../../Data/app_imports.dart';

class RaveDetailDialog extends StatelessWidget {
  final Rave rave;
  final bool isAttending;
  final VoidCallback? onAttendToggle;
  final List<AppUser> djs;
  final List<AppUser> collaborators;
  final String organizerName;
  final String? organizerAvatarUrl;

  const RaveDetailDialog({
    super.key,
    required this.rave,
    this.isAttending = false,
    this.onAttendToggle,
    this.djs = const [],
    this.collaborators = const [],
    this.organizerName = 'Unknown',
    this.organizerAvatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Palette.primalBlack,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Palette.forgedGold, width: 2),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              rave.name,
              style: TextStyle(
                color: Palette.forgedGold,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close, color: Palette.glazedWhite.o(0.7)),
          ),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoRow(Icons.location_on, rave.location),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.calendar_today, _formatDate()),
              if (rave.startTime.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildInfoRow(Icons.access_time, rave.startTime),
              ],

              if (rave.description.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildSection(
                  AppLocale.raveDescription.getString(context),
                  rave.description,
                ),
              ],

              const SizedBox(height: 16),
              _buildSection(
                AppLocale.organizer.getString(context),
                organizerName,
              ),

              if (djs.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildDJSection(),
              ],

              if (collaborators.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildCollaboratorsSection(),
              ],

              if (rave.attendingUserIds.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildSection(
                  AppLocale.attending.getString(context),
                  '${rave.attendingUserIds.length} people',
                ),
              ],

              if (rave.ticketShopLink != null ||
                  rave.additionalLink != null) ...[
                const SizedBox(height: 16),
                _buildLinksSection(),
              ],
            ],
          ),
        ),
      ),
      actions: [
        if (onAttendToggle != null)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onAttendToggle,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isAttending ? Colors.transparent : const Color(0xFFD4AF37),
                foregroundColor:
                    isAttending ? const Color(0xFFD4AF37) : Colors.black,
                side: BorderSide(color: const Color(0xFFD4AF37), width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                isAttending ? 'Leave Event' : 'Attend Event',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFD4AF37), size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFD4AF37),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildDJSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DJs',
          style: const TextStyle(
            color: Color(0xFFD4AF37),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: djs.map((dj) => _buildUserAvatar(dj)).toList(),
        ),
      ],
    );
  }

  Widget _buildCollaboratorsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Collaborators',
          style: const TextStyle(
            color: Color(0xFFD4AF37),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              collaborators.map((user) => _buildUserAvatar(user)).toList(),
        ),
      ],
    );
  }

  Widget _buildUserAvatar(AppUser user) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFD4AF37), width: 2),
      ),
      child: ClipOval(
        child:
            user.avatarUrl.isNotEmpty
                ? Image.network(
                  user.avatarUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: const Color(0xFF333333),
                      child: const Icon(
                        Icons.person,
                        color: Color(0xFFD4AF37),
                        size: 25,
                      ),
                    );
                  },
                )
                : Container(
                  color: const Color(0xFF333333),
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFFD4AF37),
                    size: 25,
                  ),
                ),
      ),
    );
  }

  Widget _buildLinksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Links',
          style: TextStyle(
            color: Color(0xFFD4AF37),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        if (rave.ticketShopLink != null)
          _buildLinkButton(
            'Tickets',
            rave.ticketShopLink!,
            Icons.confirmation_number,
          ),
        if (rave.additionalLink != null) ...[
          if (rave.ticketShopLink != null) const SizedBox(height: 8),
          _buildLinkButton('More Info', rave.additionalLink!, Icons.link),
        ],
      ],
    );
  }

  Widget _buildLinkButton(String label, String url, IconData icon) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _launchUrl(url),
        icon: Icon(icon, size: 16),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFD4AF37),
          side: const BorderSide(color: Color(0xFFD4AF37), width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }

  String _formatDate() {
    if (rave.endDate != null) {
      final startFormat = DateFormat('MMM dd');
      final endFormat =
          rave.startDate.year == rave.endDate!.year
              ? DateFormat('MMM dd, yyyy')
              : DateFormat('MMM dd, yyyy');

      return '${startFormat.format(rave.startDate)} - ${endFormat.format(rave.endDate!)}';
    } else {
      return DateFormat('EEEE, MMM dd, yyyy').format(rave.startDate);
    }
  }

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Handle error silently or show a snackbar
    }
  }
}
