import 'package:flutter/material.dart';
import 'features/watchlist/data/sample_anime.dart';
import 'features/watchlist/models/anime.dart';
import 'features/watchlist/screens/home_screen.dart';

void main() {
  runApp(const AnimeWatchlistApp());
}

class AnimeWatchlistApp extends StatelessWidget {
  // Data awal bisa diganti dari luar (dipakai oleh test).
  // Kalau tidak diisi, aplikasi memakai data contoh seperti biasa.
  final List<Anime> initialAnime;

  const AnimeWatchlistApp({super.key, this.initialAnime = sampleAnimeList});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anime Watchlist',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF640A),
          brightness: Brightness.dark,
        ),
      ),
      home: HomeScreen(initialAnime: initialAnime),
    );
  }
}