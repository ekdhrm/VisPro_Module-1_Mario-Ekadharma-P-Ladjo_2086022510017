import 'package:flutter/material.dart';
import '../../../main.dart';

class GameList extends StatelessWidget {
  const GameList({super.key, required this.games, required this.onGameTap});

  final List<GameProgress> games;
  final ValueChanged<GameProgress> onGameTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];

        return GameCard(game: game, onTap: () => onGameTap(game));
      },
    );
  }
}
