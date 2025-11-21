import 'package:flutter/foundation.dart';
import 'package:playing_cards/playing_cards.dart';
import '../models/game_model.dart';

enum BidType { pass, double, redouble, normal }

class Bid {
  final BidType type;
  final int level;
  final Suit? suit;
  final PlayerPosition player;

  Bid({
    required this.type,
    this.level = 0,
    this.suit,
    required this.player,
  });

  @override
  String toString() {
    switch (type) {
      case BidType.pass:
        return 'Pass';
      case BidType.double:
        return 'X';
      case BidType.redouble:
        return 'XX';
      case BidType.normal:
        return '$level${_suitToString(suit!)}';
    }
  }

  String _suitToString(Suit s) {
    switch (s) {
      case Suit.clubs:
        return '♣';
      case Suit.diamonds:
        return '♦';
      case Suit.hearts:
        return '♥';
      case Suit.spades:
        return '♠';
      default:
        return 'NT';
    }
  }
}

class BiddingModel extends ChangeNotifier {
  List<Bid> _bids = [];
  int _currentBidderIndex = 0;
  bool _isBiddingComplete = false;
  PlayerPosition? _declarer;
  Bid? _finalContract;

  List<Bid> get bids => List.unmodifiable(_bids);
  bool get isBiddingComplete => _isBiddingComplete;
  PlayerPosition? get declarer => _declarer;
  Bid? get finalContract => _finalContract;

  PlayerPosition get currentPlayer {
    final positions = PlayerPosition.values;
    return positions[(_currentBidderIndex) % positions.length];
  }

  void addBid(Bid bid) {
    if (_isBiddingComplete) return;

    _bids.add(bid);
    _currentBidderIndex++;

    // Check if bidding is complete (three consecutive passes after first bid)
    _checkBiddingComplete();

    notifyListeners();
  }

  void _checkBiddingComplete() {
    if (_bids.length < 4) return; // Need at least 4 bids to complete

    // Check for three consecutive passes
    int lastIndex = _bids.length - 1;
    if (_bids[lastIndex].type == BidType.pass &&
        _bids[lastIndex - 1].type == BidType.pass &&
        _bids[lastIndex - 2].type == BidType.pass) {

      _isBiddingComplete = true;

      // Find the last non-pass bid to determine the contract
      for (int i = _bids.length - 4; i >= 0; i--) {
        if (_bids[i].type == BidType.normal) {
          _finalContract = _bids[i];
          _declarer = _bids[i].player;
          break;
        }
      }
    }
  }

  void reset() {
    _bids.clear();
    _currentBidderIndex = 0;
    _isBiddingComplete = false;
    _declarer = null;
    _finalContract = null;
    notifyListeners();
  }

  // Helper method to get all valid bids for the current player
  List<Bid> getValidBids(PlayerPosition player) {
    if (player != currentPlayer) return [];

    final bids = <Bid>[];

    // Always allow pass
    bids.add(Bid(type: BidType.pass, player: player));

    // Allow double/redouble based on last bid
    if (_bids.isNotEmpty && _bids.last.type == BidType.normal) {
      // Check if this is the first opportunity to double
      final canDouble = !_bids.any((b) => b.type == BidType.double || b.type == BidType.redouble);
      if (canDouble) {
        bids.add(Bid(type: BidType.double, player: player));
      }
    } else if (_bids.isNotEmpty && _bids.last.type == BidType.double) {
      // Allow redouble after double
      bids.add(Bid(type: BidType.redouble, player: player));
    }

    // Add normal bids (1-7 in each suit and NT)
    final lastNormalBid = _bids.lastWhere(
      (b) => b.type == BidType.normal,
      orElse: () => Bid(type: BidType.normal, level: 0, suit: Suit.clubs, player: player),
    );

    for (int level = 1; level <= 7; level++) {
      for (final suit in Suit.values) {
        if (level > lastNormalBid.level ||
            (level == lastNormalBid.level &&
             _suitValue(suit) > _suitValue(lastNormalBid.suit!))) {
          bids.add(Bid(
            type: BidType.normal,
            level: level,
            suit: suit,
            player: player,
          ));
        }
      }
    }

    return bids;
  }

  int _suitValue(Suit suit) {
    switch (suit) {
      case Suit.clubs:
        return 1;
      case Suit.diamonds:
        return 2;
      case Suit.hearts:
        return 3;
      case Suit.spades:
        return 4;
      default:
        return 5; // No Trump
    }
  }
}
