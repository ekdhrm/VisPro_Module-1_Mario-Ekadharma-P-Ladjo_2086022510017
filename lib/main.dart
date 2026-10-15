import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';

void main() => runApp(const LabHarness());

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
    if (totalObjectives == 0) return 0;
    return completedObjectives / totalObjectives;
  }
}

const List<GameProgress> kNormalGames = [
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

const String kExtremelyLongText =
    'An extremely long game title that spans more than 200 characters so we can verify that the text overflow rules work perfectly and do not create those terrible yellow-and-black stripes on the screen when we test it. Let us keep typing so it is undeniably very long.';

const List<GameProgress> kLongGames = [
  GameProgress(
    title: kExtremelyLongText,
    currentProgress: 'A progress description that also pushes boundaries.',
    completedObjectives: 5,
    totalObjectives: 10,
  ),
  ...kNormalGames,
];

final List<GameProgress> kBigGames = List.generate(
  500,
  (i) => GameProgress(
    title: 'Procedural Game $i',
    currentProgress: 'Level ${i % 20}',
    completedObjectives: i % 10,
    totalObjectives: 10,
  ),
);

class GameProgressApp extends StatelessWidget {
  const GameProgressApp({
    super.key,
    this.games = kNormalGames,
    this.themeMode = ThemeMode.system,
  });

  final List<GameProgress> games;
  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Tracker',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kTrackerPrimaryIndigo,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: kTrackerBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kTrackerPrimaryIndigo,
          brightness: Brightness.dark,
          primary: kTrackerPrimaryIndigo,
          surface: kTrackerSurface,
          onSurface: kTrackerTextPrimary,
          onSurfaceVariant: kTrackerTextSecondary,
          tertiary: kTrackerProgressFill,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: kTrackerPrimaryIndigo,
          linearTrackColor: kTrackerSurface,
          linearMinHeight: 8.0,
        ),
        cardTheme: const CardThemeData(
          color: kTrackerSurface,
          elevation: 0,
          margin: EdgeInsets.only(bottom: 12.0),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: kTrackerTextPrimary,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(
            color: kTrackerTextPrimary,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(color: kTrackerTextSecondary),
        ),
      ),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: PointerDeviceKind.values.toSet(),
      ),
      home: GameProgressScreen(games: games),
    );
  }
}

class GameProgressScreen extends StatefulWidget {
  const GameProgressScreen({super.key, required this.games});

  final List<GameProgress> games;

  @override
  State<GameProgressScreen> createState() => _GameProgressScreenState();
}

class _GameProgressScreenState extends State<GameProgressScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  List<GameProgress> get _visibleGames {
    if (_query.trim().isEmpty) return widget.games;
    final query = _query.toLowerCase().trim();
    return widget.games
        .where((game) => game.title.toLowerCase().contains(query))
        .toList();
  }

  int get _totalObjectives {
    return _visibleGames.fold(0, (total, game) => total + game.totalObjectives);
  }

  void _openGame(GameProgress game) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Selected ${game.title}')));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visibleGames;

    return Scaffold(
      appBar: AppBar(title: const Text('Game Progress')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 600;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ProgressHeader(),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _searchController,
                          onChanged: (value) => setState(() => _query = value),
                          decoration: InputDecoration(
                            hintText: 'Search games...',
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: _query.isEmpty
                                ? null
                                : IconButton(
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() => _query = '');
                                    },
                                    icon: const Icon(Icons.clear),
                                  ),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'My Games',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
                if (visible.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Center(
                        key: const Key('empty-state'),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.videogame_asset_off,
                              size: 64,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No games found.',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            if (_query.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              FilledButton.tonal(
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _query = '');
                                },
                                child: const Text('Reset Search'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  )
                else if (isTablet)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.8,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => GameCard(
                          game: visible[index],
                          onTap: () => _openGame(visible[index]),
                        ),
                        childCount: visible.length,
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => GameCard(
                          game: visible[index],
                          onTap: () => _openGame(visible[index]),
                        ),
                        childCount: visible.length,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ProgressSummary(
            gameCount: visible.length,
            objectiveCount: _totalObjectives,
          ),
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

        // =========================================================
        // ERROR 1: Row with unbounded long text (Right overflow)
        // =========================================================
        Row(
          children: [
            Text(
              'Keep track of where you left off. But wait, this sentence is intentionally way too long for a single screen and will definitely overflow horizontally.',
            ),
          ],
        ),
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
    final text = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: text.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  game.currentProgress,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(value: game.progress),
                const SizedBox(height: 6),
                Text(
                  '${game.completedObjectives} / ${game.totalObjectives} objectives',
                ),
              ],
            ),
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
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$gameCount games'),
              Text('$objectiveCount objectives'),
            ],
          ),
        ),
      ),
    );
  }
}

enum _Device {
  small('Small phone', Size(320, 568)),
  large('Large phone', Size(430, 932)),
  tablet('Tablet', Size(800, 1280));

  const _Device(this.label, this.size);

  final String label;
  final Size size;
}

enum _Data {
  normal('Normal'),
  longName('200-char name'),
  empty('Zero items'),
  big('500 items');

  final dynamic label;

  const _Data(this.label);

  List<GameProgress> get items => switch (this) {
    _Data.normal => kNormalGames,
    _Data.longName => kLongGames,
    _Data.empty => const <GameProgress>[],
    _Data.big => kBigGames,
  };
}

class LabHarness extends StatefulWidget {
  const LabHarness({super.key});

  @override
  State<LabHarness> createState() => _LabHarnessState();
}

class _LabHarnessState extends State<LabHarness> {
  _Device _device = _Device.small;
  _Data _data = _Data.normal;
  bool _landscape = false;
  bool _keyboard = false;
  bool _dark = false;
  bool _insets = false;

  Size get _screen => _landscape ? _device.size.flipped : _device.size;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homework-4 · device harness',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF455A64),
      ),
      home: Builder(
        builder: (context) => Scaffold(
          body: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(width: 280, child: _panel(context)),
                const VerticalDivider(width: 1),
                Expanded(child: _stage(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _panel(BuildContext context) {
    final text = Theme.of(context).textTheme;

    Widget group(String title, List<Widget> chips) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: text.labelLarge),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: chips),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Homework-4 · device harness', style: text.titleMedium),
        const SizedBox(height: 4),
        Text('Try every combination.', style: text.bodySmall),
        const SizedBox(height: 20),
        group('Screen', [
          for (final d in _Device.values)
            ChoiceChip(
              label: Text(d.label),
              selected: _device == d,
              onSelected: (_) => setState(() => _device = d),
            ),
        ]),
        group('Orientation', [
          ChoiceChip(
            label: const Text('Portrait'),
            selected: !_landscape,
            onSelected: (_) => setState(() => _landscape = false),
          ),
          ChoiceChip(
            label: const Text('Landscape'),
            selected: _landscape,
            onSelected: (_) => setState(() => _landscape = true),
          ),
        ]),
        group('Data', [
          for (final d in _Data.values)
            ChoiceChip(
              label: Text(d.label),
              selected: _data == d,
              onSelected: (_) => setState(() => _data = d),
            ),
        ]),
        group('Conditions', [
          FilterChip(
            label: const Text('Keyboard open'),
            selected: _keyboard,
            onSelected: (v) => setState(() => _keyboard = v),
          ),
          FilterChip(
            label: const Text('Dark mode'),
            selected: _dark,
            onSelected: (v) => setState(() => _dark = v),
          ),
          FilterChip(
            label: const Text('Notch + gesture bar'),
            selected: _insets,
            onSelected: (v) => setState(() => _insets = v),
          ),
        ]),
        Text(
          'Screen: ${_screen.width.toInt()} × ${_screen.height.toInt()} dp',
          style: text.bodySmall,
        ),
      ],
    );
  }

  Widget _stage(BuildContext context) {
    final size = _screen;
    final keyboard = _keyboard ? (_landscape ? 180.0 : 260.0) : 0.0;
    final padding = !_insets
        ? EdgeInsets.zero
        : _landscape
        ? const EdgeInsets.only(left: 32, bottom: 20)
        : const EdgeInsets.only(top: 32, bottom: 20);
    final safe = keyboard > 0 ? padding.copyWith(bottom: 0) : padding;
    final media = MediaQuery.of(context).copyWith(
      size: size,
      padding: safe,
      viewPadding: safe,
      viewInsets: EdgeInsets.only(bottom: keyboard),
    );

    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF1B1D1F),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox.fromSize(
                  size: size,
                  child: MediaQuery(
                    data: media,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: GameProgressApp(
                            key: ValueKey(_data),
                            games: _data.items,
                            themeMode: _dark ? ThemeMode.dark : ThemeMode.light,
                          ),
                        ),
                        if (padding.top > 0)
                          Positioned(
                            left: 0,
                            right: 0,
                            top: 0,
                            height: padding.top,
                            child: const IgnorePointer(child: _FakeStatusBar()),
                          ),
                        if (padding.left > 0)
                          Positioned(
                            left: 0,
                            top: 0,
                            bottom: 0,
                            width: padding.left,
                            child: const IgnorePointer(
                              child: ColoredBox(color: Color(0xFF000000)),
                            ),
                          ),
                        if (safe.bottom > 0)
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            height: safe.bottom,
                            child: const IgnorePointer(
                              child: _FakeGestureBar(),
                            ),
                          ),
                        if (keyboard > 0)
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            height: keyboard,
                            child: const IgnorePointer(child: _FakeKeyboard()),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FakeStatusBar extends StatelessWidget {
  const _FakeStatusBar();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '9:41',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        Center(
          child: Container(
            width: 84,
            height: 22,
            decoration: BoxDecoration(
              color: const Color(0xFF000000),
              borderRadius: BorderRadius.circular(11),
            ),
          ),
        ),
      ],
    );
  }
}

class _FakeGestureBar extends StatelessWidget {
  const _FakeGestureBar();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 120,
        height: 5,
        decoration: BoxDecoration(
          color: const Color(0x99000000),
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}

class _FakeKeyboard extends StatelessWidget {
  const _FakeKeyboard();
  static const List<String> _rows = ['qwertyuiop', 'asdfghjkl', 'zxcvbnm'];
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF2B2F33),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            for (final row in _rows)
              Expanded(
                child: Row(
                  children: [
                    for (final letter in row.split(''))
                      Expanded(child: _Key(letter)),
                  ],
                ),
              ),
            const Expanded(
              child: Row(
                children: [
                  Expanded(flex: 2, child: _Key('123')),
                  Expanded(flex: 6, child: _Key('spasi')),
                  Expanded(flex: 2, child: _Key('⏎')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Key extends StatelessWidget {
  const _Key(this.label);
  final String label;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF4A4F55),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Text(
                label,
                style: const TextStyle(color: Color(0xCCFFFFFF), fontSize: 14),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
