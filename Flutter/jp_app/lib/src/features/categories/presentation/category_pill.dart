import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jp_app/src/theme/palette.dart';

class CategoryPill extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryPill({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              color:
                  isSelected ? Palette.jpWhite.o(0.5) : Palette.jpWhite.o(0.1),
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: Palette.jpWhite.o(0.5), width: 1.0),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
                color:
                    isSelected
                        ? const Color.fromARGB(255, 30, 30, 30)
                        : Palette.jpWhite,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
