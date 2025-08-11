import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/palette.dart';

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

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
              gradient: LinearGradient(
                colors: [Palette.forgedGold.o(0.2), Palette.forgedGold.o(0.1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Palette.forgedGold.o(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.work_outline_rounded,
                      size: 32,
                      color: Palette.forgedGold,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Our Portfolio',
                      style: GoogleFonts.sometypeMono(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Palette.shadowGrey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Showcasing successful projects and collaborations in the music industry.',
                  style: GoogleFonts.sometypeMono(
                    fontSize: 16,
                    color: Palette.concreteGrey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Featured Projects
          Text(
            'Featured Projects',
            style: GoogleFonts.sometypeMono(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Palette.gigGrey,
            ),
          ),

          const SizedBox(height: 16),

          _buildProjectCard(
            'GigHub Mobile App',
            'Cross-platform Flutter app connecting DJs and bookers',
            ['Flutter', 'Firebase', 'SoundCloud API', 'AES Encryption'],
            Icons.phone_android_rounded,
            'Live on App Stores',
            true,
          ),

          const SizedBox(height: 16),

          _buildProjectCard(
            'Real-time Chat System',
            'End-to-end encrypted messaging with Firebase integration',
            [
              'Firebase Firestore',
              'AES-256',
              'WebSocket',
              'Push Notifications',
            ],
            Icons.chat_rounded,
            'Integrated in App',
            true,
          ),

          const SizedBox(height: 16),

          _buildProjectCard(
            'DJ Profile System',
            'Rich profiles with SoundCloud streaming and media galleries',
            ['SoundCloud SDK', 'Firebase Storage', 'Image Processing'],
            Icons.person_rounded,
            'Integrated in App',
            true,
          ),

          const SizedBox(height: 16),

          _buildProjectCard(
            'Event Management Platform',
            'Comprehensive gig booking and management system',
            ['Calendar Integration', 'Payment Processing', 'Notifications'],
            Icons.event_rounded,
            'Coming Soon',
            false,
          ),

          const SizedBox(height: 32),

          // Technologies Section
          Text(
            'Technologies We Use',
            style: GoogleFonts.sometypeMono(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Palette.primalBlack,
            ),
          ),

          const SizedBox(height: 16),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: MediaQuery.of(context).size.width > 800 ? 4 : 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
            children: [
              _buildTechCard('Flutter', Icons.phone_android_rounded),
              _buildTechCard('Firebase', Icons.cloud_rounded),
              _buildTechCard('Dart', Icons.code_rounded),
              _buildTechCard('Node.js', Icons.javascript_rounded),
              _buildTechCard('SoundCloud', Icons.music_note_rounded),
              _buildTechCard('Git', Icons.source_rounded),
              _buildTechCard('VS Code', Icons.edit_rounded),
              _buildTechCard('Figma', Icons.design_services_rounded),
            ],
          ),

          const SizedBox(height: 32),

          // Success Metrics
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
                  'Project Impact',
                  style: GoogleFonts.sometypeMono(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Palette.forgedGold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMetricItem('99.9%', 'Uptime'),
                    _buildMetricItem('< 100ms', 'Response Time'),
                    _buildMetricItem('0+', 'Active Users'),
                    _buildMetricItem('1+', 'Countries'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(
    String title,
    String description,
    List<String> technologies,
    IconData icon,
    String status,
    bool isLive,
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isLive
                              ? Palette.okGreen.o(0.1)
                              : Palette.gigGrey.o(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          status,
                          style: GoogleFonts.sometypeMono(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isLive ? Palette.okGreen : Palette.gigGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: GoogleFonts.sometypeMono(
                fontSize: 14,
                color: Palette.gigGrey,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: technologies
                  .map(
                    (tech) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Palette.forgedGold.o(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Palette.forgedGold.o(0.3)),
                      ),
                      child: Text(
                        tech,
                        style: GoogleFonts.sometypeMono(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Palette.forgedGold,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechCard(String name, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Palette.forgedGold),
            const SizedBox(height: 12),
            Text(
              name,
              style: GoogleFonts.sometypeMono(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Palette.primalBlack,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.sometypeMono(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Palette.forgedGold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.sometypeMono(
            fontSize: 12,
            color: Palette.glazedWhite,
          ),
        ),
      ],
    );
  }
}
