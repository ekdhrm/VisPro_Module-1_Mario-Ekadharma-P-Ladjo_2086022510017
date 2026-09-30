import 'package:flutter/material.dart';
import '../../../main.dart';

class GameCard extends StatelessWidget {
  const GameCard({super.key, required this.game, required this.onTap});

  final GameProgress game;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(game.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(game.currentProgress),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: game.progress),
            const SizedBox(height: 4),
            Text(
              '${game.completedObjectives} / '
              '${game.totalObjectives} objectives',
            ),
          ],
        ),
      ),
    );
  }
}
