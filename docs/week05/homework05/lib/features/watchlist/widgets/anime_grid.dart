import 'package:flutter/material.dart';
import 'package:homework02/core/theme/app_spacing.dart';
import '../models/anime.dart';
import 'anime_card.dart';

class AnimeGrid extends StatelessWidget {
  final List<Anime> animeList;
  final ValueChanged<Anime>? onCardTap;

  const AnimeGrid({super.key, required this.animeList, this.onCardTap});

  int _columnsFor(double width) {
    if (width < 600) return 2;
    if (width < 840) return 3;
    return 4;
  }

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final columns = _columnsFor (constraints.crossAxisExtent);

        return SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.md),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              mainAxisExtent: 360,
          ),
          delegate:  SliverChildBuilderDelegate(
            (context,index) {
              final anime = animeList[index];
              return AnimeCard(
                anime: anime,
                onTap: onCardTap == null ? null : () => onCardTap!(anime),
              );
            },
            childCount: animeList.length,
            ),
          ),
        );
      },
    );
  }
}