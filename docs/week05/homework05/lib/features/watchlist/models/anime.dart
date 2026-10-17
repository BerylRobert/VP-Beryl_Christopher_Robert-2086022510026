enum WatchStatus { watching, completed, planToWatch, dropped }

String watchStatusLabel(WatchStatus status) {
  switch (status) {
    case WatchStatus.watching:
      return 'Watching';
    case WatchStatus.completed:
      return 'Completed';
    case WatchStatus.planToWatch:
      return 'Plan to Watch';
    case WatchStatus.dropped:
      return 'Dropped';
  }
}

class Anime {
  final String id;
  final String title;
  final String genre;
  final String imagePath;
  final int totalEpisodes;
  final int watchedEpisodes;
  final double rating;
  final WatchStatus status;

  const Anime({
    required this.id,
    required this.title,
    required this.genre,
    required this.imagePath,
    required this.totalEpisodes,
    required this.watchedEpisodes,
    required this.rating,
    required this.status,
  });

  double get progress =>
      totalEpisodes == 0 ? 0 : watchedEpisodes / totalEpisodes;

  Anime copyWith({WatchStatus? status}) {
    return Anime(
      id: id,
      title: title,
      genre: genre,
      imagePath: imagePath,
      totalEpisodes: totalEpisodes,
      watchedEpisodes: watchedEpisodes,
      rating: rating,
      status: status ?? this.status,
    );
  }
}