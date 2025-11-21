import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/game_model.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bridge Game'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<GameProvider>().newGame(),
          ),
        ],
      ),
      body: Consumer<GameProvider>(
        builder: (context, game, _) {
          return Stack(
            children: [
              // North player (top)
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: _buildPlayerHand(
                  context,
                  PlayerPosition.north,
                  game.getHand(PlayerPosition.north),
                ),
              ),

              // East player (right)
              Positioned(
                top: 200,
                right: 10,
                bottom: 200,
                child: _buildVerticalHand(
                  context,
                  PlayerPosition.east,
                  game.getHand(PlayerPosition.east),
                ),
              ),

              // South player (bottom)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: _buildPlayerHand(
                  context,
                  PlayerPosition.south,
                  game.getHand(PlayerPosition.south),
                ),
              ),

              // West player (left)
              Positioned(
                top: 200,
                left: 10,
                bottom: 200,
                child: _buildVerticalHand(
                  context,
                  PlayerPosition.west,
                  game.getHand(PlayerPosition.west),
                ),
              ),

              // Center area for tricks and bidding
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Bridge Table', style: TextStyle(fontSize: 24)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: game.newGame,
                      child: const Text('New Game'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPlayerHand(BuildContext context, PlayerPosition position, List<PlayingCard> hand) {
    final isCurrentPlayer = context.watch<GameProvider>().currentPlayer == position;
    final playerName = context.read<GameProvider>().getPlayerName(position);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$playerName${isCurrentPlayer ? ' (Your Turn)' : ''}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isCurrentPlayer ? Colors.blue : Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hand.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: isCurrentPlayer
                    ? () => context.read<GameProvider>().playCard(position, hand[index])
                    : null,
                child: SizedBox(
                  width: 80,
                  height: 110,
                  child: PlayingCardView(
                    card: hand[index],
                    showBack: !isCurrentPlayer, // Show back of cards for other players
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalHand(BuildContext context, PlayerPosition position, List<PlayingCard> hand) {
    final isCurrentPlayer = context.watch<GameProvider>().currentPlayer == position;
    final playerName = context.read<GameProvider>().getPlayerName(position);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RotatedBox(
          quarterTurns: 3,
          child: Text(
            '$playerName${isCurrentPlayer ? ' (Your Turn)' : ''}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isCurrentPlayer ? Colors.blue : Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 120,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: hand.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: GestureDetector(
                  onTap: isCurrentPlayer
                      ? () => context.read<GameProvider>().playCard(position, hand[index])
                      : null,
                  child: SizedBox(
                    width: 80,
                    height: 110,
                    child: PlayingCardView(
                      card: hand[index],
                      showBack: !isCurrentPlayer,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
