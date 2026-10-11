import 'package:flutter/material.dart';

// Aplikasi kecil khusus untuk H2 (constraint diagnosis).
// Dijalankan terpisah dari aplikasi utama:
//   flutter run -d chrome -t tool/constraint_demo.dart
void main() {
  runApp(const ConstraintDemoApp());
}

class ConstraintDemoApp extends StatelessWidget {
  const ConstraintDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Constraint Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF640A),
          brightness: Brightness.dark,
        ),
      ),
      home: const ConstraintDemoPage(),
    );
  }
}

class ConstraintDemoPage extends StatefulWidget {
  const ConstraintDemoPage({super.key});

  @override
  State<ConstraintDemoPage> createState() => _ConstraintDemoPageState();
}

class _ConstraintDemoPageState extends State<ConstraintDemoPage> {
  int _case = 0;
  bool _fixed = false;

  static const List<String> _titles = [
    'Error 1: Row terlalu lebar',
    'Error 2: Column terlalu tinggi',
    'Error 3: AspectRatio memaksa tinggi',
  ];

  Widget _demo() {
    switch (_case) {
      case 0:
        return _RowDemo(fixed: _fixed);
      case 1:
        return _ColumnDemo(fixed: _fixed);
      default:
        return _AspectDemo(fixed: _fixed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_case])),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('1')),
                ButtonSegment(value: 1, label: Text('2')),
                ButtonSegment(value: 2, label: Text('3')),
              ],
              selected: {_case},
              onSelectionChanged: (value) {
                setState(() => _case = value.first);
              },
            ),
            SwitchListTile(
              title: const Text('Terapkan perbaikan'),
              value: _fixed,
              onChanged: (value) => setState(() => _fixed = value),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: _demo(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Bingkai tipis supaya batas ruang yang tersedia kelihatan di screenshot.
class _Frame extends StatelessWidget {
  final Widget child;

  const _Frame({required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: child,
    );
  }
}

// Error 1: Row dengan teks yang lebih lebar dari ruangnya.
class _RowDemo extends StatelessWidget {
  final bool fixed;

  const _RowDemo({required this.fixed});

  static const String _text =
      'Frieren: Beyond Journey\'s End - Complete Collection Season 1';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: _Frame(
        child: fixed
            ? const Row(
                children: [
                  Icon(Icons.movie),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            : const Row(
                children: [
                  Icon(Icons.movie),
                  SizedBox(width: 8),
                  Text(_text),
                ],
              ),
      ),
    );
  }
}

// Error 2: Column berisi 4 baris (sekitar 224 dp) di ruang setinggi 120 dp.
class _ColumnDemo extends StatelessWidget {
  final bool fixed;

  const _ColumnDemo({required this.fixed});

  static const Column _tiles = Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ListTile(title: Text('Watching')),
      ListTile(title: Text('Completed')),
      ListTile(title: Text('Plan to Watch')),
      ListTile(title: Text('Dropped')),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 280, maxHeight: 120),
      child: _Frame(
        child: fixed ? const SingleChildScrollView(child: _tiles) : _tiles,
      ),
    );
  }
}

// Error 3: AspectRatio memaksa tinggi kartu dari lebarnya.
class _AspectDemo extends StatelessWidget {
  final bool fixed;

  const _AspectDemo({required this.fixed});

  Widget _card(BuildContext context, {required bool shrink}) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: shrink ? MainAxisSize.min : MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Jujutsu Kaisen', style: textTheme.titleLarge),
            Text('Shounen', style: textTheme.bodyMedium),
            Text('14 / 24 eps', style: textTheme.bodyMedium),
            Text('Rating 4.5', style: textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: fixed
          ? _card(context, shrink: true)
          : AspectRatio(
              aspectRatio: 2.5,
              child: _card(context, shrink: false),
            ),
    );
  }
}
