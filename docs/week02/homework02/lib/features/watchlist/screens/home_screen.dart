import 'package:flutter/material.dart';
import '../models/anime.dart';
import '../widgets/anime_grid.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/status_filter_tabs.dart';
import '../widgets/status_picker_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Anime> _animeList = List.of(sampleAnimeList);
  WatchStatus? _selectedStatus;

  List<Anime> get _filteredList {
    if (_selectedStatus == null) return _animeList;
    return _animeList
        .where((anime) => anime.status == _selectedStatus)
        .toList();
  }

  void _onFilterChanged(WatchStatus? status) {
    setState(() => _selectedStatus = status);
  }

  void _updateAnimeStatus(String id, WatchStatus newStatus) {
    setState(() {
      final index = _animeList.indexWhere((anime) => anime.id == id);
      if (index == -1) return;
      _animeList[index] = _animeList[index].copyWith(status: newStatus);
    });
  }

  void _showStatusPicker(Anime anime) {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => StatusPickerSheet(
        title: anime.title,
        current: anime.status,
        onSelected: (newStatus) {
          _updateAnimeStatus(anime.id, newStatus);
          Navigator.pop(sheetContext);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredList;

    return Scaffold(
      appBar: AppBar(title: const Text('My Anime Watchlist')),
      body: Column(
        children: [
          const SizedBox(height: 8),
          StatusFilterTabs(
            selected: _selectedStatus,
            onChanged: _onFilterChanged,
          ),
          const SizedBox(height: 4),
          Expanded(
            child: filtered.isEmpty
                ? const EmptyStateView(
                    message: 'No anime in this list yet.',
                    icon: Icons.movie_creation_outlined,
                  )
                : AnimeGrid(
                    animeList: filtered,
                    onCardTap: _showStatusPicker,
                  ),
          ),
        ],
      ),
    );
  }
}