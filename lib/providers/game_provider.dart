import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';
import '../models/game_model.dart';

class GameProvider extends ChangeNotifier {
  final GameModel _gameModel = GameModel();

  // Expose game model state
  List<PlayingCard> getDeck() => _gameModel.getDeck();

  List<PlayingCard> getHand(PlayerPosition position) =>
      _gameModel.getHand(position);

  PlayerPosition? get currentPlayer => _gameModel.currentPlayer;
  PlayerPosition? get dealer => _gameModel.dealer;

  // Game actions
  GameModel get gameModel => _gameModel;

  void newGame() {
    _gameModel.newGame();
    notifyListeners();
  }

  void playCard(PlayerPosition player, PlayingCard card) {
    _gameModel.playCard(player, card);
    notifyListeners();
  }

  // Helper methods
  String getPlayerName(PlayerPosition position) {
    switch (position) {
      case PlayerPosition.north:
        return 'North';
      case PlayerPosition.east:
        return 'East';
      case PlayerPosition.south:
        return 'South';
      case PlayerPosition.west:
        return 'West';
    }
  }
}
