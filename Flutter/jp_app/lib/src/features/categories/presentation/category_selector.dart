import 'package:flutter/material.dart';
import 'package:jp_app/src/features/categories/domain/category_pill.dart';

class CategorySelector extends StatelessWidget {
  final Animation<Offset> categoriesAnimation;
  final String selectedCategory;
  final void Function(String) onCategorySelected;

  const CategorySelector({
    super.key,
    required this.categoriesAnimation,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: categoriesAnimation,
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 112.0,
          left: 8.0,
          right: 2.0,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              CategoryPill(
                text: "All categories",
                isSelected: selectedCategory == "All categories",
                onTap: () => onCategorySelected("All categories"),
              ),
              const SizedBox(width: 12.0),
              CategoryPill(
                text: "Salty",
                isSelected: selectedCategory == "Salty",
                onTap: () => onCategorySelected("Salty"),
              ),
              const SizedBox(width: 12.0),
              CategoryPill(
                text: "Sweet",
                isSelected: selectedCategory == "Sweet",
                onTap: () => onCategorySelected("Sweet"),
              ),
              const SizedBox(width: 12.0),
              CategoryPill(
                text: "Dairy",
                isSelected: selectedCategory == "Dairy",
                onTap: () => onCategorySelected("Dairy"),
              ),
              const SizedBox(width: 12.0),
              CategoryPill(
                text: "Beef",
                isSelected: selectedCategory == "Beef",
                onTap: () => onCategorySelected("Beef"),
              ),
              const SizedBox(width: 12.0),
              CategoryPill(
                text: "Snacks",
                isSelected: selectedCategory == "Snacks",
                onTap: () => onCategorySelected("Snacks"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
