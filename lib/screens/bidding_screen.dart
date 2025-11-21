import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:playing_cards/playing_cards.dart';
import '../providers/bidding_provider.dart';
import '../providers/game_provider.dart';
import '../models/bidding_model.dart';
import '../models/game_model.dart';

class BiddingScreen extends StatelessWidget {
  const BiddingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BiddingProvider(
        Provider.of<GameProvider>(context, listen: false).gameModel,
      )..startBidding(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bidding Practice'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => context.read<BiddingProvider>().resetBidding(),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () => Navigator.pop(context),
              tooltip: 'Back to Game',
            ),
          ],
        ),
        body: Column(
          children: [
            _buildBiddingTable(),
            const Divider(),
            _buildBidHistory(),
            const Divider(),
            _buildBidControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildBiddingTable() {
    return Consumer<BiddingProvider>(
      builder: (context, provider, _) {
        final currentPlayer = provider.currentPlayer;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Table(
            border: TableBorder.all(),
            columnWidths: const {
              0: FlexColumnWidth(1.5),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1),
            },
            children: [
              _buildTableHeader(),
              TableRow(
                children: PlayerPosition.values.map((position) {
                  final isCurrentPlayer = position == currentPlayer;
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    color: isCurrentPlayer
                        ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                        : null,
                    child: Text(
                      _getPlayerName(position),
                      style: TextStyle(
                        fontWeight: isCurrentPlayer ? FontWeight.bold : null,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  TableRow _buildTableHeader() {
    return const TableRow(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Bid', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('North', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('East', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('South', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('West', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        ),
      ],
    );
  }

  Widget _buildBidHistory() {
    return Expanded(
      child: Consumer<BiddingProvider>(
        builder: (context, provider, _) {
          final bids = provider.bids;
          if (bids.isEmpty) {
            return const Center(child: Text('No bids yet'));
          }

          return ListView.builder(
            itemCount: (bids.length / 4).ceil(),
            itemBuilder: (context, rowIndex) {
              final startIndex = rowIndex * 4;
              return Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    children: List.generate(4, (colIndex) {
                      final bidIndex = startIndex + colIndex;
                      if (bidIndex >= bids.length) return const SizedBox.shrink();

                      final bid = bids[bidIndex];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          bid.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _getBidColor(bid),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBidControls() {
    return Consumer<BiddingProvider>(
      builder: (context, provider, _) {
        if (provider.isBiddingComplete) {
          return _buildBiddingComplete(context, provider);
        }

        final validBids = provider.getValidBids();
        final currentHighBid = provider.getCurrentHighBid();

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (currentHighBid != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Current contract: ${currentHighBid.toString()}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8.0,
                runSpacing: 8.0,
                children: validBids.map((bid) {
                  return ElevatedButton(
                    onPressed: () => provider.makeBid(bid),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getBidButtonColor(bid),
                      foregroundColor: _getBidTextColor(bid),
                    ),
                    child: Text(
                      bid.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBiddingComplete(BuildContext context, BiddingProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.green[50],
      child: Column(
        children: [
          Text(
            'Bidding Complete!',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.green[800],
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Contract: ${provider.finalContract?.toString() ?? 'Passed out'}\n'
            'Declarer: ${provider.declarer != null ? _getPlayerName(provider.declarer!) : 'None'}\n'
            'Vulnerable: ${provider.isVulnerable(provider.declarer ?? PlayerPosition.north) ? 'Yes' : 'No'}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              provider.resetBidding();
              provider.startBidding();
            },
            child: const Text('Start New Bidding'),
          ),
        ],
      ),
    );
  }

  String _getPlayerName(PlayerPosition position) {
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

  Color _getBidColor(Bid bid) {
    if (bid.type == BidType.pass) return Colors.grey;
    if (bid.type == BidType.double) return Colors.red;
    if (bid.type == BidType.redouble) return Colors.red[900]!;

    // Handle null suit (No Trump)
    if (bid.suit == null) return Colors.blue[900]!;

    switch (bid.suit!) {
      case Suit.clubs:
      case Suit.spades:
        return Colors.black;
      case Suit.diamonds:
      case Suit.hearts:
        return Colors.red;
      case Suit.joker:
        return Colors.purple;
      default:
        return Colors.black;
    }
  }

  Color _getBidButtonColor(Bid bid) {
    if (bid.type == BidType.pass) return Colors.grey[200]!;
    if (bid.type == BidType.double) return Colors.red[100]!;
    if (bid.type == BidType.redouble) return Colors.red[200]!;

    // Handle null suit case (No Trump)
    if (bid.suit == null) return Colors.blue[50]!;

    switch (bid.suit!) {
      case Suit.clubs:
      case Suit.spades:
        return Colors.grey[100]!;
      case Suit.diamonds:
      case Suit.hearts:
        return Colors.red[50]!;
      case Suit.joker:
        return Colors.purple[50]!;
      default:
        return Colors.grey[100]!;
    }
  }

  Color _getBidTextColor(Bid bid) {
    if (bid.type == BidType.pass) return Colors.black;
    if (bid.type == BidType.double || bid.type == BidType.redouble) {
      return Colors.red[900]!;
    }

    // Handle null suit case (No Trump)
    if (bid.suit == null) return Colors.blue[900]!;

    switch (bid.suit!) {
      case Suit.clubs:
      case Suit.spades:
        return Colors.black;
      case Suit.diamonds:
      case Suit.hearts:
        return Colors.red[900]!;
      case Suit.joker:
        return Colors.purple[900]!;
      default:
        return Colors.black;
    }
  }
}
