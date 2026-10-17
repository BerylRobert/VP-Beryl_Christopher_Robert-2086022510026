import 'package:flutter/material.dart';
import 'package:homework02/core/theme/app_theme.dart';
import 'features/watchlist/data/sample_anime.dart';
import 'features/watchlist/models/anime.dart';
import 'features/watchlist/screens/home_screen.dart';

void main() {
  runApp(const AnimeWatchlistApp());
}

class AnimeWatchlistApp extends StatelessWidget {
  final List<Anime> initialAnime;

  const AnimeWatchlistApp({super.key, this.initialAnime = sampleAnimeList});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anime Watchlist',
      theme: darkTheme,
      home: HomeScreen(initialAnime: initialAnime),
    );
  }
}