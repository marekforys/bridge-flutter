import 'package:playing_cards/playing_cards.dart';

class CardUtils {
  // Convert card suit to a display string
  static String suitToString(PlayingCardSuit suit) {
    switch (suit) {
      case PlayingCardSuit.spades:
        return '♠';
      case PlayingCardSuit.hearts:
        return '♥';
      case PlayingCardSuit.diamonds:
        return '♦';
      case PlayingCardSuit.clubs:
        return '♣';
    }
  }

  // Convert card value to a display string
  static String valueToString(PlayingCardValue value) {
    switch (value) {
      case PlayingCardValue.ace:
        return 'A';
      case PlayingCardValue.two:
        return '2';
      case PlayingCardValue.three:
        return '3';
      case PlayingCardValue.four:
        return '4';
      case PlayingCardValue.five:
        return '5';
      case PlayingCardValue.six:
        return '6';
      case PlayingCardValue.seven:
        return '7';
      case PlayingCardValue.eight:
        return '8';
      case PlayingCardValue.nine:
        return '9';
      case PlayingCardValue.ten:
        return '10';
      case PlayingCardValue.jack:
        return 'J';
      case PlayingCardValue.queen:
        return 'Q';
      case PlayingCardValue.king:
        return 'K';
    }
  }

  // Get the color for a card suit
  static Color getSuitColor(PlayingCardSuit suit) {
    return suit == PlayingCardSuit.hearts || suit == PlayingCardSuit.diamonds
        ? Colors.red
        : Colors.black;
  }

  // Get the value of a card for scoring
  static int getCardValue(PlayingCard card, {PlayingCardSuit? trumpSuit}) {
    bool isTrump = trumpSuit != null && card.suit == trumpSuit;

    if (isTrump) {
      switch (card.value) {
        case PlayingCardValue.jack:
          return 20; // Right bower (jack of trump suit)
        case PlayingCardValue.jack when _isLeftBower(card, trumpSuit):
          return 15; // Left bower (jack of same color as trump)
        case PlayingCardValue.ace:
          return 14;
        case PlayingCardValue.king:
          return 13;
        case PlayingCardValue.queen:
          return 12;
        case PlayingCardValue.ten:
          return 10;
        default:
          return card.value.index + 1; // Other trump cards by index
      }
    } else {
      // Non-trump cards
      switch (card.value) {
        case PlayingCardValue.ace:
          return 14;
        case PlayingCardValue.king:
          return 13;
        case PlayingCardValue.queen:
          return 12;
        case PlayingCardValue.jack:
          return 11;
        default:
          return card.value.index + 1;
      }
    }
  }

  // Check if a card is the left bower (jack of the same color as trump)
  static bool _isLeftBower(PlayingCard card, PlayingCardSuit trumpSuit) {
    if (card.value != PlayingCardValue.jack) return false;

    return (trumpSuit == PlayingCardSuit.spades && card.suit == PlayingCardSuit.clubs) ||
           (trumpSuit == PlayingCardSuit.clubs && card.suit == PlayingCardSuit.spades) ||
           (trumpSuit == PlayingCardSuit.hearts && card.suit == PlayingCardSuit.diamonds) ||
           (trumpSuit == PlayingCardSuit.diamonds && card.suit == PlayingCardSuit.hearts);
  }
}
