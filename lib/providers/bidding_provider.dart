import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';
import '../models/bidding_model.dart';
import '../models/game_model.dart';

class BiddingProvider extends ChangeNotifier {
  final BiddingModel _biddingModel = BiddingModel();
  final GameModel _gameModel;

  BiddingProvider(this._gameModel);

  // Expose bidding model state
  List<Bid> get bids => _biddingModel.bids;
  bool get isBiddingComplete => _biddingModel.isBiddingComplete;
  PlayerPosition? get declarer => _biddingModel.declarer;
  Bid? get finalContract => _biddingModel.finalContract;
  PlayerPosition get currentPlayer => _biddingModel.currentPlayer;

  // Get valid bids for the current player
  List<Bid> getValidBids() {
    return _biddingModel.getValidBids(currentPlayer);
  }

  // Make a bid
  void makeBid(Bid bid) {
    _biddingModel.addBid(bid);
    notifyListeners();
  }

  // Reset the bidding
  void resetBidding() {
    _biddingModel.reset();
    notifyListeners();
  }

  // Start a new bidding round
  void startBidding() {
    resetBidding();
    // You might want to set the dealer from the game model here
    // _biddingModel.setDealer(_gameModel.dealer);
    notifyListeners();
  }

  // Get the current vulnerability (for scoring)
  bool isVulnerable(PlayerPosition position) {
    // This is a simplified version - in a real game, vulnerability rotates
    return position == PlayerPosition.north || position == PlayerPosition.south;
  }

  // Get the current player's hand for reference during bidding
  List<PlayingCard> getCurrentPlayerHand() {
    return _gameModel.getHand(currentPlayer);
  }

  // Get the current high bid (last non-pass bid)
  Bid? getCurrentHighBid() {
    for (var i = _biddingModel.bids.length - 1; i >= 0; i--) {
      if (_biddingModel.bids[i].type == BidType.normal) {
        return _biddingModel.bids[i];
      }
    }
    return null;
  }

  // Check if the current player is the partner of the last bidder
  bool isPartnerBidding() {
    if (_biddingModel.bids.isEmpty) return false;
    final lastBidder = _biddingModel.bids.last.player;
    return (lastBidder.index + 2) % 4 == currentPlayer.index;
  }
}
