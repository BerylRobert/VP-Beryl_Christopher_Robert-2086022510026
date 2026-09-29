import 'package:flutter/material.dart';
import '../models/anime.dart';

class AnimeCard extends StatelessWidget {
  final Anime anime;
  final VoidCallback? onTap;

  const AnimeCard({super.key, required this.anime, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    anime.imagePath,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      color: colorScheme.primaryContainer,
                      child: Icon(
                        Icons.movie_filter_outlined,
                        color: colorScheme.onPrimaryContainer,
                        size: 32,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                anime.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                anime.genre,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              LinearProgressIndicator(value: anime.progress),
              const SizedBox(height: 4),
              Text(
                '${anime.watchedEpisodes} / ${anime.totalEpisodes} eps',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.star, size: 14, color: colorScheme.tertiary),
                  const SizedBox(width: 4),
                  Text(
                    anime.rating.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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