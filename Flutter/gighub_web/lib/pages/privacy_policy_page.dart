import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/palette.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Palette.primalBlack,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.privacy_tip_rounded,
                      size: 32,
                      color: Palette.forgedGold,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Privacy Policy',
                      style: GoogleFonts.sometypeMono(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Palette.forgedGold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Learn how GigHub collects, uses, and protects your personal data.',
                  style: GoogleFonts.sometypeMono(
                    fontSize: 16,
                    color: Palette.glazedWhite,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Effective Date
          _buildSection(
            'Effective Date',
            'This Privacy Policy is effective as of January 1, 2024, and was last updated on ${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}.',
          ),

          const SizedBox(height: 24),

          // Data Controller
          _buildSection(
            'Data Controller',
            'GigHub is operated by Leon Bösche. For privacy-related inquiries, please contact us at b0eschex@gmail.com.',
          ),

          const SizedBox(height: 24),

          // Information We Collect
          _buildComplexSection('Information We Collect', [
            _buildSubSection(
              'Account Information',
              'When you create an account, we collect your email address, chosen username, profile information (name, bio, city), and any profile images you upload.',
            ),
            _buildSubSection(
              'SoundCloud Integration',
              'If you connect your SoundCloud account, we access your public SoundCloud tracks and profile information to display in your GigHub profile.',
            ),
            _buildSubSection(
              'Chat Messages',
              'All chat messages are encrypted using AES-256 encryption before being stored. We cannot read your encrypted messages.',
            ),
            _buildSubSection(
              'Event Data',
              'When you create or participate in events (Raves), we collect event details, location information, and participation status.',
            ),
            _buildSubSection(
              'Usage Data',
              'We collect app usage analytics through Firebase Analytics to improve our service, including app crashes and performance data.',
            ),
          ]),

          const SizedBox(height: 24),

          // How We Use Your Information
          _buildComplexSection('How We Use Your Information', [
            _buildSubSection(
              'Service Provision',
              'To provide core app functionality including profile creation, messaging, event management, and SoundCloud integration.',
            ),
            _buildSubSection(
              'Communication',
              'To send push notifications about new messages, event updates, and important app announcements.',
            ),
            _buildSubSection(
              'Improvement',
              'To analyze app usage patterns and improve features, fix bugs, and enhance user experience.',
            ),
            _buildSubSection(
              'Legal Compliance',
              'To comply with applicable laws, respond to legal requests, and protect the rights and safety of our users.',
            ),
          ]),

          const SizedBox(height: 24),

          // Data Storage and Security
          _buildComplexSection('Data Storage and Security', [
            _buildSubSection(
              'Cloud Storage',
              'Your data is stored securely using Google Firebase services with industry-standard security measures.',
            ),
            _buildSubSection(
              'Encryption',
              'All chat messages are encrypted using AES-256 encryption. Profile images and media are stored securely in Firebase Storage.',
            ),
            _buildSubSection(
              'Access Controls',
              'We implement strict access controls and authentication mechanisms to protect your data from unauthorized access.',
            ),
            _buildSubSection(
              'Data Retention',
              'We retain your data as long as your account is active. You can request account deletion at any time.',
            ),
          ]),

          const SizedBox(height: 24),

          // Third-Party Services
          _buildComplexSection('Third-Party Services', [
            _buildSubSection(
              'Firebase (Google)',
              'We use Firebase for authentication, database, storage, analytics, and push notifications. Data is processed according to Google\'s Privacy Policy.',
            ),
            _buildSubSection(
              'SoundCloud',
              'When you connect SoundCloud, we access your public profile and tracks according to SoundCloud\'s API terms and privacy policy.',
            ),
            _buildSubSection(
              'Social Login',
              'If you use Google, Apple, or Facebook login, we receive basic profile information according to their respective privacy policies.',
            ),
          ]),

          const SizedBox(height: 24),

          // Your Rights
          _buildComplexSection('Your Rights (GDPR)', [
            _buildSubSection(
              'Access',
              'You can request a copy of all personal data we have about you.',
            ),
            _buildSubSection(
              'Rectification',
              'You can update your profile information directly in the app or request corrections.',
            ),
            _buildSubSection(
              'Erasure',
              'You can request account deletion, which will remove all your personal data from our systems.',
            ),
            _buildSubSection(
              'Portability',
              'You can request your data in a machine-readable format.',
            ),
            _buildSubSection(
              'Objection',
              'You can object to processing of your personal data for marketing purposes.',
            ),
          ]),

          const SizedBox(height: 24),

          // Children's Privacy
          _buildSection(
            'Children\'s Privacy',
            'GigHub is not intended for children under 16 years of age. We do not knowingly collect personal information from children under 16. If you believe we have collected information from a child under 16, please contact us immediately.',
          ),

          const SizedBox(height: 24),

          // International Transfers
          _buildSection(
            'International Data Transfers',
            'Your data may be transferred to and processed in countries other than your country of residence, including the United States where Firebase servers are located. We ensure appropriate safeguards are in place for such transfers.',
          ),

          const SizedBox(height: 24),

          // Changes to Policy
          _buildSection(
            'Changes to This Privacy Policy',
            'We may update this Privacy Policy from time to time. We will notify you of any material changes by posting the new Privacy Policy in the app and updating the "last updated" date.',
          ),

          const SizedBox(height: 24),

          // Contact Information
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Palette.forgedGold.o(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Palette.forgedGold.o(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Us',
                  style: GoogleFonts.sometypeMono(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Palette.primalBlack,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'If you have any questions about this Privacy Policy or our data practices, please contact us:',
                  style: GoogleFonts.sometypeMono(
                    fontSize: 14,
                    color: Palette.primalBlack,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Email: b0eschex@gmail.com\nAddress: Braugasse 23, 50859 Cologne, Germany',
                  style: GoogleFonts.sometypeMono(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Palette.forgedGold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Last Updated
          Center(
            child: Text(
              'Last updated: ${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}',
              style: GoogleFonts.sometypeMono(
                fontSize: 12,
                color: Palette.gigGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Card(
      color: Palette.primalBlack.o(0.35),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.sometypeMono(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Palette.shadowGrey,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: GoogleFonts.sometypeMono(
                fontSize: 14,
                color: Palette.gigGrey,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplexSection(String title, List<Widget> subsections) {
    return Card(
      color: Palette.primalBlack.o(0.35),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.sometypeMono(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Palette.shadowGrey,
              ),
            ),
            const SizedBox(height: 16),
            ...subsections,
          ],
        ),
      ),
    );
  }

  Widget _buildSubSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.sometypeMono(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Palette.forgedGold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: GoogleFonts.sometypeMono(
              fontSize: 13,
              color: Palette.gigGrey,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
