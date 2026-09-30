import 'package:flutter/material.dart';

void main() {
  runApp(const GameProgressApp());
}

class GameProgressApp extends StatelessWidget {
  const GameProgressApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Game Progress',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GameProgressScreen(),
    );
  }
}

class GameProgress {
  const GameProgress({
    required this.title,
    required this.currentProgress,
    required this.completedObjectives,
    required this.totalObjectives,
  });

  final String title;
  final String currentProgress;
  final int completedObjectives;
  final int totalObjectives;

  double get progress {
    if (totalObjectives == 0) {
      return 0;
    }

    return completedObjectives / totalObjectives;
  }
}

class GameProgressScreen extends StatefulWidget {
  const GameProgressScreen({super.key});

  @override
  State<GameProgressScreen> createState() => _GameProgressScreenState();
}

class _GameProgressScreenState extends State<GameProgressScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _query = '';

  final List<GameProgress> _games = const [
    GameProgress(
      title: 'Stardew Valley',
      currentProgress: 'Spring, Year 2',
      completedObjectives: 12,
      totalObjectives: 15,
    ),
    GameProgress(
      title: 'Coral Island',
      currentProgress: 'Summer, Year 1',
      completedObjectives: 8,
      totalObjectives: 16,
    ),
    GameProgress(
      title: 'A Space for the Unbound',
      currentProgress: 'Chapter 4',
      completedObjectives: 7,
      totalObjectives: 10,
    ),
    GameProgress(
      title: 'Until Then',
      currentProgress: 'Chapter 3',
      completedObjectives: 5,
      totalObjectives: 12,
    ),
  ];

  List<GameProgress> get _filteredGames {
    if (_query.trim().isEmpty) {
      return _games;
    }

    final query = _query.toLowerCase().trim();

    return _games.where((game) {
      return game.title.toLowerCase().contains(query);
    }).toList();
  }

  int get _totalObjectives {
    return _filteredGames.fold(
      0,
      (total, game) => total + game.totalObjectives,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openGame(GameProgress game) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Selected ${game.title}')));
  }

  @override
  Widget build(BuildContext context) {
    final games = _filteredGames;

    return Scaffold(
      appBar: AppBar(title: const Text('Game Progress')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProgressHeader(),

            const SizedBox(height: 20),

            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _query = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search games...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();

                          setState(() {
                            _query = '';
                          });
                        },
                        icon: const Icon(Icons.clear),
                      ),
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            Text('My Games', style: Theme.of(context).textTheme.titleLarge),

            const SizedBox(height: 12),

            Expanded(
              child: games.isEmpty
                  ? const Center(child: Text('No games found.'))
                  : ListView.builder(
                      itemCount: games.length,
                      itemBuilder: (context, index) {
                        final game = games[index];

                        return GameCard(
                          game: game,
                          onTap: () => _openGame(game),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 12),

            ProgressSummary(
              gameCount: games.length,
              objectiveCount: _totalObjectives,
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressHeader extends StatelessWidget {
  const ProgressHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Track Your Games',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text('Keep track of where you left off.'),
      ],
    );
  }
}

class GameCard extends StatelessWidget {
  const GameCard({super.key, required this.game, required this.onTap});

  final GameProgress game;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                game.title,
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 6),

              Text(game.currentProgress),

              const SizedBox(height: 12),

              LinearProgressIndicator(value: game.progress),

              const SizedBox(height: 6),

              Text(
                '${game.completedObjectives} / '
                '${game.totalObjectives} objectives',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProgressSummary extends StatelessWidget {
  const ProgressSummary({
    super.key,
    required this.gameCount,
    required this.objectiveCount,
  });

  final int gameCount;
  final int objectiveCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$gameCount games'),
            Text('$objectiveCount objectives'),
          ],
        ),
      ),
    );
  }
}
