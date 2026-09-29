enum WatchStatus { watching, completed, planToWatch, dropped }

extension WatchStatusLabel on WatchStatus {
  String get label {
    switch (this) {
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

const List<Anime> sampleAnimeList = [
  Anime(
    id: '1',
    title: 'Frieren: Beyond Journey\'s End',
    genre: 'Fantasy',
    imagePath: 'assets/images/frieren.jpg',
    totalEpisodes: 28,
    watchedEpisodes: 28,
    rating: 4.9,
    status: WatchStatus.completed,
  ),
  Anime(
    id: '2',
    title: 'Jujutsu Kaisen',
    genre: 'Shounen',
    imagePath: 'assets/images/jujutsu_kaisen.jpg',
    totalEpisodes: 24,
    watchedEpisodes: 14,
    rating: 4.5,
    status: WatchStatus.watching,
  ),
  Anime(
    id: '3',
    title: 'Solo Leveling',
    genre: 'Isekai',
    imagePath: 'assets/images/solo_leveling.jpg',
    totalEpisodes: 12,
    watchedEpisodes: 3,
    rating: 4.2,
    status: WatchStatus.watching,
  ),
  Anime(
    id: '4',
    title: 'Violet Evergarden',
    genre: 'Slice of Life',
    imagePath: 'assets/images/violet_evergarden.jpg',
    totalEpisodes: 13,
    watchedEpisodes: 0,
    rating: 0,
    status: WatchStatus.planToWatch,
  ),
  Anime(
    id: '5',
    title: 'Sword Art Online',
    genre: 'Isekai',
    imagePath: 'assets/images/sword_art_online.jpg',
    totalEpisodes: 25,
    watchedEpisodes: 6,
    rating: 2.5,
    status: WatchStatus.dropped,
  ),
];