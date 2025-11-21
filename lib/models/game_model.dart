import 'package:flutter/foundation.dart';
import 'package:playing_cards/playing_cards.dart';

enum PlayerPosition { north, east, south, west }

class GameModel extends ChangeNotifier {
  List<PlayingCard> _deck = [];
  Map<PlayerPosition, List<PlayingCard>> _hands = {};
  PlayerPosition? _dealer;
  PlayerPosition? _currentPlayer;

  // Initialize a new game
  void newGame() {
    // Create a standard deck of 52 cards
    _deck = [];
    for (var suit in [Suit.clubs, Suit.diamonds, Suit.hearts, Suit.spades]) {
      for (var value in [
        CardValue.ace, CardValue.two, CardValue.three, CardValue.four,
        CardValue.five, CardValue.six, CardValue.seven, CardValue.eight,
        CardValue.nine, CardValue.ten, CardValue.jack, CardValue.queen,
        CardValue.king
      ]) {
        _deck.add(PlayingCard(suit, value));
      }
    }

    _deck.shuffle();

    // Initialize empty hands
    _hands = {
      PlayerPosition.north: [],
      PlayerPosition.east: [],
      PlayerPosition.south: [],
      PlayerPosition.west: [],
    };

    // Deal cards
    int cardIndex = 0;
    for (int i = 0; i < 13; i++) {
      for (var position in PlayerPosition.values) {
        if (cardIndex < _deck.length) {
          _hands[position]!.add(_deck[cardIndex]);
          cardIndex++;
        }
      }
    }

    // Sort each player's hand
    for (var hand in _hands.values) {
      hand.sort((a, b) {
        if (a.suit != b.suit) {
          return a.suit.index.compareTo(b.suit.index);
        }
        return b.value.index.compareTo(a.value.index);
      });
    }

    // Set initial dealer (random for now)
    _dealer = PlayerPosition.values[DateTime.now().millisecond % 4];
    _currentPlayer = _nextPlayer(_dealer!);

    notifyListeners();
  }

  PlayerPosition _nextPlayer(PlayerPosition current) {
    switch (current) {
      case PlayerPosition.north:
        return PlayerPosition.east;
      case PlayerPosition.east:
        return PlayerPosition.south;
      case PlayerPosition.south:
        return PlayerPosition.west;
      case PlayerPosition.west:
        return PlayerPosition.north;
    }
  }

  // Getters
  List<PlayingCard> getDeck() => List.from(_deck);

  List<PlayingCard> getHand(PlayerPosition position) =>
      List.from(_hands[position] ?? []);

  PlayerPosition? get currentPlayer => _currentPlayer;
  PlayerPosition? get dealer => _dealer;

  // Play a card
  void playCard(PlayerPosition player, PlayingCard card) {
    if (_currentPlayer != player) return;

    // Remove card from player's hand
    _hands[player]?.removeWhere((c) =>
      c.suit == card.suit && c.value == card.value);

    // Move to next player
    _currentPlayer = _nextPlayer(player);

    notifyListeners();
  }
}
