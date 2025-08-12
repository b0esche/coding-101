import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../theme/palette.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.path;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Palette.primalBlack,
        boxShadow: [
          BoxShadow(
            color: Palette.forgedGold.o(0.3),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(
                context,
                'Home',
                Icons.home_rounded,
                '/',
                currentLocation == '/',
                () => context.go('/'),
              ),
              _buildNavItem(
                context,
                'Contribute',
                Icons.add_circle_outline_rounded,
                '/contribute',
                currentLocation == '/contribute',
                () => context.go('/contribute'),
              ),
              _buildNavItem(
                context,
                'Q&A',
                Icons.help_outline_rounded,
                '/qa',
                currentLocation == '/qa',
                () => context.go('/qa'),
              ),
              _buildNavItem(
                context,
                'Portfolio',
                Icons.work_outline_rounded,
                '/portfolio',
                currentLocation == '/portfolio',
                () => context.go('/portfolio'),
              ),
              _buildNavItem(
                context,
                'Impressum',
                Icons.info_outline_rounded,
                '/impressum',
                currentLocation == '/impressum',
                () => context.go('/impressum'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    String label,
    IconData icon,
    String route,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Palette.forgedGold.o(0.2) : Colors.transparent,
          border: isSelected
              ? Border.all(color: Palette.forgedGold, width: 1)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Palette.forgedGold : Palette.glazedWhite,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.sometypeMono(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Palette.forgedGold : Palette.glazedWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
