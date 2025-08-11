import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/palette.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Palette.primalBlack, Palette.primalBlack.o(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to GigHub Web',
                  style: GoogleFonts.sometypeMono(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Palette.forgedGold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Connect, Create, and Collaborate in the Digital Music Ecosystem',
                  style: GoogleFonts.sometypeMono(
                    fontSize: 16,
                    color: Palette.glazedWhite,
                  ),
                ),
                // const SizedBox(height: 24),
                // ElevatedButton.icon(
                //   onPressed: () {},
                //   icon: const Icon(Icons.play_arrow_rounded),
                //   label: Text(
                //     'Get Started',
                //     style: GoogleFonts.sometypeMono(
                //       fontWeight: FontWeight.w600,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Features Section
          Text(
            'What We Offer',
            style: GoogleFonts.sometypeMono(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Palette.gigGrey,
            ),
          ),

          const SizedBox(height: 16),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: MediaQuery.of(context).size.width > 800 ? 3 : 1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _buildFeatureCard(
                'DJ / Booker Profiles',
                'Create stunning profiles with SoundCloud integration',
                Icons.person_rounded,
              ),
              _buildFeatureCard(
                'Real-time Chat',
                'Connect with other artists and bookers instantly',
                Icons.chat_rounded,
              ),
              _buildFeatureCard(
                'Event Management',
                'Organize and discover amazing gigs',
                Icons.event_rounded,
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Stats Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Palette.shadowGrey,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Palette.shadowGrey),
            ),
            child: Column(
              children: [
                Text(
                  'Join Our Growing Community',
                  style: GoogleFonts.sometypeMono(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Palette.primalBlack,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem('0+', 'DJs'),
                    _buildStatItem('0+', 'Bookers'),
                    _buildStatItem('0+', 'Gigs'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(String title, String description, IconData icon) {
    return Card(
      color: Palette.primalBlack.o(0.35),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Palette.forgedGold.o(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 32, color: Palette.forgedGold),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.sometypeMono(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Palette.concreteGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: GoogleFonts.sometypeMono(
                fontSize: 12,
                color: Palette.gigGrey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: GoogleFonts.sometypeMono(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Palette.forgedGold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.sometypeMono(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Palette.gigGrey,
          ),
        ),
      ],
    );
  }
}
