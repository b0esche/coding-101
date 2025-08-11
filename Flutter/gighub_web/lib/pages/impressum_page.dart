import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/palette.dart';

class ImpressumPage extends StatelessWidget {
  const ImpressumPage({super.key});

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
                      Icons.info_outline_rounded,
                      size: 32,
                      color: Palette.forgedGold,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Impressum',
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
                  'Legal information and contact details as required by law.',
                  style: GoogleFonts.sometypeMono(
                    fontSize: 16,
                    color: Palette.glazedWhite,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Company Information
          _buildSection('Company Information', [
            _buildInfoRow('Company Name:', '/'),
            _buildInfoRow('Managing Director:', '/'),
            _buildInfoRow('Registration Number:', '/'),
            _buildInfoRow('Registration Court:', '/'),
            _buildInfoRow('VAT ID:', '/'),
          ]),

          const SizedBox(height: 24),

          // Contact Information
          _buildSection('Contact Information', [
            _buildInfoRow('Address:', 'Braugasse 23\n50859 Cologne\nGermany'),
            _buildInfoRow('Phone:', '+49 (0) 160 99110299'),
            _buildInfoRow('Email:', 'b0eschex@gmail.com'),
            _buildInfoRow('Website:', 'https://gig-hub-8ac24.web.app/'),
          ]),

          // const SizedBox(height: 24),

          // // Responsible for Content
          // _buildSection('Responsible for Content', [
          //   _buildInfoRow('Editorial Responsibility:', 'Alex Developer'),
          //   _buildInfoRow(
          //     'Address:',
          //     'Musterstraße 123\n10115 Berlin\nGermany',
          //   ),
          //   _buildInfoRow('Email:', 'editorial@gighub.de'),
          // ]),

          // const SizedBox(height: 24),

          // // Data Protection Officer
          // _buildSection('Data Protection Officer', [
          //   _buildInfoRow('Name:', 'Dr. Privacy Expert'),
          //   _buildInfoRow('Email:', 'privacy@gighub.de'),
          //   _buildInfoRow(
          //     'Address:',
          //     'Datenschutzstraße 456\n10115 Berlin\nGermany',
          //   ),
          // ]),
          const SizedBox(height: 24),

          // Disclaimer
          _buildSection('Disclaimer', [
            _buildTextBlock(
              'Liability for Content',
              'The contents of our pages have been created with the utmost care. However, we cannot guarantee the contents\' accuracy, completeness or topicality. According to statutory provisions, we are furthermore responsible for our own content on these web pages. In this matter, please note that we are not under obligation to supervise merely the transmitted or saved information of third parties, or investigate circumstances pointing to illegal activity.',
            ),
            _buildTextBlock(
              'Liability for Links',
              'Our offer contains links to external third parties\' websites. We have no influence on the contents of those websites, therefore we cannot guarantee for those contents. Providers or administrators of linked websites are always responsible for the contents of the linked websites. The linked websites had been checked for possible violations of law at the time of the establishment of the link.',
            ),
            _buildTextBlock(
              'Copyright',
              'Contents and compilations published on these websites by the providers are subject to German copyright laws. Reproduction, editing, distribution as well as the use of any kind outside the scope of the copyright law require a written permission of the author or originator.',
            ),
          ]),

          const SizedBox(height: 24),

          // Privacy Policy Link
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Palette.lightGrey,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Palette.shadowGrey),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy & Data Protection',
                  style: GoogleFonts.sometypeMono(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Palette.primalBlack,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'For information about how we collect, use, and protect your personal data, please refer to our Privacy Policy.',
                  style: GoogleFonts.sometypeMono(
                    fontSize: 14,
                    color: Palette.gigGrey,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.privacy_tip_rounded),
                  label: Text(
                    'View Privacy Policy',
                    style: GoogleFonts.sometypeMono(
                      fontWeight: FontWeight.w600,
                    ),
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

  Widget _buildSection(String title, List<Widget> content) {
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
            ...content,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: GoogleFonts.sometypeMono(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Palette.forgedGold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.sometypeMono(
                fontSize: 14,
                color: Palette.gigGrey,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextBlock(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.sometypeMono(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Palette.forgedGold,
            ),
          ),
          const SizedBox(height: 8),
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
