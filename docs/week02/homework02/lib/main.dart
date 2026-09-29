import 'package:flutter/material.dart';
import 'features/watchlist/screens/home_screen.dart';

void main() {
  runApp(const AnimeWatchlistApp());
}

class AnimeWatchlistApp extends StatelessWidget {
  const AnimeWatchlistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anime Watchlist',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomeScreen(),
    );
  }
}