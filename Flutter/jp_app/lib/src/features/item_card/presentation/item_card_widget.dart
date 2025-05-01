import 'package:flutter/material.dart';
import 'package:jp_app/src/features/item_card/domain/item_card.dart';

class ItemCardWidget extends StatelessWidget {
  final Animation<double> itemCardAnimation;

  const ItemCardWidget({super.key, required this.itemCardAnimation});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: itemCardAnimation,
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.29,
            bottom: MediaQuery.of(context).size.height * 0,
          ),
          child: const ItemCard(),
        ),
      ),
    );
  }
}
