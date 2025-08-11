import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/palette.dart';
import '../providers/navigation_provider.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
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
                    AppPage.home,
                    navigationProvider.currentPage == AppPage.home,
                    () => navigationProvider.setPage(AppPage.home),
                  ),
                  _buildNavItem(
                    context,
                    'Contribute',
                    Icons.add_circle_outline_rounded,
                    AppPage.contribute,
                    navigationProvider.currentPage == AppPage.contribute,
                    () => navigationProvider.setPage(AppPage.contribute),
                  ),
                  _buildNavItem(
                    context,
                    'Q&A',
                    Icons.help_outline_rounded,
                    AppPage.qa,
                    navigationProvider.currentPage == AppPage.qa,
                    () => navigationProvider.setPage(AppPage.qa),
                  ),
                  _buildNavItem(
                    context,
                    'Portfolio',
                    Icons.work_outline_rounded,
                    AppPage.portfolio,
                    navigationProvider.currentPage == AppPage.portfolio,
                    () => navigationProvider.setPage(AppPage.portfolio),
                  ),
                  _buildNavItem(
                    context,
                    'Impressum',
                    Icons.info_outline_rounded,
                    AppPage.impressum,
                    navigationProvider.currentPage == AppPage.impressum,
                    () => navigationProvider.setPage(AppPage.impressum),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    String label,
    IconData icon,
    AppPage page,
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
