import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../theme/palette.dart';

class ContributePage extends StatelessWidget {
  const ContributePage({super.key});

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
              color: Palette.forgedGold.o(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Palette.forgedGold.o(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.add_circle_outline_rounded,
                      size: 32,
                      color: Palette.forgedGold,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Contribute to GigHub',
                      style: GoogleFonts.sometypeMono(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Palette.gigGrey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Help us build the future of music collaboration. Your contributions make a difference!',
                  style: GoogleFonts.sometypeMono(
                    fontSize: 16,
                    color: Palette.gigGrey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Ways to Contribute
          Text(
            'Ways to Contribute',
            style: GoogleFonts.sometypeMono(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Palette.primalBlack,
            ),
          ),

          const SizedBox(height: 16),

          _buildContributionCard(
            'Code Development',
            'Help us improve the platform with your programming skills',
            Icons.code_rounded,
            [
              'Frontend development (Flutter/Web)',
              'Backend improvements',
              'Bug fixes and optimizations',
              'New feature development',
            ],
          ),

          const SizedBox(height: 16),

          _buildContributionCard(
            'Design & UX',
            'Enhance user experience and visual design',
            Icons.design_services_rounded,
            [
              'UI/UX design improvements',
              'Create new icons and graphics',
              'User research and testing',
              'Accessibility improvements',
            ],
          ),

          const SizedBox(height: 16),

          _buildContributionCard(
            'Community Support',
            'Help build and moderate our community',
            Icons.people_rounded,
            [
              'Answer questions in forums',
              'Create tutorials and guides',
              'Moderate community discussions',
              'Organize events and meetups',
            ],
          ),

          const SizedBox(height: 16),

          _buildContributionCard(
            'Content Creation',
            'Share your knowledge and expertise',
            Icons.create_rounded,
            [
              'Write blog posts and articles',
              'Create video tutorials',
              'Share best practices',
              'Document features and workflows',
            ],
          ),

          const SizedBox(height: 32),

          // Get Started Section
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
                Text(
                  'Ready to Get Started?',
                  style: GoogleFonts.sometypeMono(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Palette.forgedGold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Join our contributor community and make an impact on the music industry.',
                  style: GoogleFonts.sometypeMono(
                    fontSize: 14,
                    color: Palette.glazedWhite,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        launchUrlString('https://github.com/b0esche/gig_hub');
                      },
                      icon: const Icon(Icons.code_rounded),
                      label: Text(
                        'View on GitHub',
                        style: GoogleFonts.sometypeMono(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      onPressed: () {
                        launchUrlString('https://discord.gg/DM2DykT3');
                      },
                      icon: Icon(Icons.chat_rounded, color: Palette.forgedGold),
                      label: Text(
                        'Join Discord',
                        style: GoogleFonts.sometypeMono(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Palette.forgedGold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Palette.forgedGold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContributionCard(
    String title,
    String description,
    IconData icon,
    List<String> items,
  ) {
    return Card(
      color: Palette.primalBlack.o(0.35),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Palette.forgedGold.o(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Palette.forgedGold, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
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
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: GoogleFonts.sometypeMono(
                          fontSize: 14,
                          color: Palette.concreteGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Palette.forgedGold,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: GoogleFonts.sometypeMono(
                          fontSize: 13,
                          color: Palette.concreteGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
