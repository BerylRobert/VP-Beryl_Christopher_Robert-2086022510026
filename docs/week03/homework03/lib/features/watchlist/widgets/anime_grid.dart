import 'package:flutter/material.dart';
import '../models/anime.dart';
import 'anime_card.dart';

class AnimeGrid extends StatelessWidget {
  final List<Anime> animeList;
  final ValueChanged<Anime>? onCardTap;

  const AnimeGrid({super.key, required this.animeList, this.onCardTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.68,
      ),
      itemCount: animeList.length,
      itemBuilder: (context, index) {
        final anime = animeList[index];
        return AnimeCard(
          anime: anime,
          onTap: onCardTap == null ? null : () => onCardTap!(anime),
        );
      },
    );
  }
}