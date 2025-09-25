import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/palette.dart';
import '../widgets/contact_support_dialog.dart';

class QAPage extends StatefulWidget {
  const QAPage({super.key});

  @override
  State<QAPage> createState() => _QAPageState();
}

class _QAPageState extends State<QAPage> {
  final List<FAQ> faqs = [
    FAQ(
      question: 'What is GigHub?',
      answer:
          'GigHub is a cross-platform mobile app that connects DJs and bookers. Users can create profiles, stream SoundCloud tracks, chat in real-time with encryption, and collaborate around gigs and bookings.',
    ),
    FAQ(
      question: 'How do I create a DJ profile?',
      answer:
          'To create a DJ profile, you need to sign up with your email or social accounts, connect your SoundCloud account, and fill out your profile information including your genres, BPM range, and bio.',
    ),
    FAQ(
      question: 'Is the chat really encrypted?',
      answer:
          'Yes! GigHub uses AES-256 encryption for all chat messages to ensure your conversations remain private and secure.',
    ),
    FAQ(
      question: 'How does SoundCloud integration work?',
      answer:
          'After connecting your SoundCloud account, you can stream your tracks directly in the app. Other users can listen to your music while browsing your profile.',
    ),
    FAQ(
      question: 'Can I use GigHub on web?',
      answer:
          'GigHub is primarily a mobile app for Android and iOS with full features. This website serves as an information hub and showcase for the mobile app.',
    ),
    FAQ(
      question: 'How do I find gigs?',
      answer:
          'Bookers can use the search function to find DJs in their area. You can filter by location, genres, BPM range, and other criteria to find the perfect match.',
    ),
    FAQ(
      question: 'Is GigHub free to use?',
      answer:
          'Yes, GigHub is free to use with all core features available. We may introduce premium features in the future.',
    ),
    FAQ(
      question: 'How do I report inappropriate content?',
      answer:
          'You can report inappropriate content or users through the app\'s reporting system. We take all reports seriously and review them promptly.',
    ),
    FAQ(
      question: 'What languages does GigHub support?',
      answer:
          'GigHub supports 12+ languages including German, English, Spanish, French, Italian, Japanese, Korean, Chinese, Arabic, Turkish, Polish, and Ukrainian.',
    ),
    FAQ(
      question: 'Can I create events in GigHub?',
      answer:
          'Yes! Bookers can create events (called "Raves") with detailed information, location data, and group chats for collaboration. You can create single-day or multi-day events.',
    ),
  ];

  int? expandedIndex;

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
              color: Palette.accentBlue.o(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Palette.accentBlue.o(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.help_outline_rounded,
                      size: 32,
                      color: Palette.accentBlue,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Frequently Asked\nQuestions',
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
                  'Find answers to common questions about GigHub and how to use our platform.',
                  style: GoogleFonts.sometypeMono(
                    fontSize: 16,
                    color: Palette.concreteGrey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // FAQ List
          Text(
            'Common Questions',
            style: GoogleFonts.sometypeMono(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Palette.gigGrey,
            ),
          ),

          const SizedBox(height: 16),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: faqs.length,
            itemBuilder: (context, index) {
              return _buildFAQItem(faqs[index], index);
            },
          ),

          const SizedBox(height: 32),

          // Contact Section
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
                  'Still have questions?',
                  style: GoogleFonts.sometypeMono(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Palette.forgedGold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Can\'t find what you\'re looking for? Get in touch with our support team.',
                  style: GoogleFonts.sometypeMono(
                    fontSize: 14,
                    color: Palette.glazedWhite,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const ContactSupportDialog(),
                    );
                  },
                  icon: const Icon(Icons.email_rounded),
                  label: Text(
                    'Contact Support',
                    style: GoogleFonts.sometypeMono(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(FAQ faq, int index) {
    final isExpanded = expandedIndex == index;

    return Card(
      color: Palette.primalBlack.o(0.35),
      margin: const EdgeInsets.only(bottom: 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                setState(() {
                  expandedIndex = isExpanded ? null : index;
                });
              },
              title: Text(
                faq.question,
                style: GoogleFonts.sometypeMono(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Palette.shadowGrey,
                ),
              ),
              trailing: AnimatedRotation(
                turns: isExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Palette.forgedGold,
                ),
              ),
            ),
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Palette.shadowGrey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    faq.answer,
                    style: GoogleFonts.sometypeMono(
                      fontSize: 14,
                      color: Palette.primalBlack,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class FAQ {
  final String question;
  final String answer;

  FAQ({required this.question, required this.answer});
}
