import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';
import '../utils/card_utils.dart';

class PlayingCardView extends StatelessWidget {
  final PlayingCard card;
  final bool showBack;
  final double cardWidth;
  final double cardHeight;
  final VoidCallback? onTap;

  const PlayingCardView({
    Key? key,
    required this.card,
    this.showBack = false,
    this.cardWidth = 80.0,
    this.cardHeight = 120.0,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (showBack) {
      return _buildCardBack();
    }
    return _buildCardFront();
  }

  Widget _buildCardFront() {
    final isRed = card.suit == PlayingCardSuit.hearts ||
        card.suit == PlayingCardSuit.diamonds;
    final cardColor = isRed ? Colors.red[800] : Colors.black;
    final value = CardUtils.valueToString(card.value);
    final suit = CardUtils.suitToString(card.suit);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey.shade300, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top-left corner
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      color: cardColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Center suit
            Text(
              suit,
              style: TextStyle(
                color: cardColor,
                fontSize: 24,
              ),
            ),

            // Bottom-right corner (rotated)
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Transform.rotate(
                angle: 3.1416, // 180 degrees in radians
                child: Text(
                  value,
                  style: TextStyle(
                    color: cardColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      width: cardWidth,
      height: cardHeight,
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      decoration: BoxDecoration(
        color: Colors.blue[800],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.blue[900]!, width: 2.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white24, width: 2.0),
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      ),
    );
  }
}
