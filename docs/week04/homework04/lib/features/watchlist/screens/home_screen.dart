import 'package:flutter/material.dart';
import '../models/anime.dart';
import '../widgets/anime_grid.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/search_field.dart';
import '../widgets/status_filter_tabs.dart';
import '../widgets/status_picker_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Anime> _animeList = List.of(sampleAnimeList);
  final TextEditingController _searchController = TextEditingController();
  WatchStatus? _selectedStatus;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _isSearching => _query.trim().isNotEmpty;
  bool get _hasActiveFilter => _selectedStatus != null || _isSearching;

  List<Anime> get _filteredList {
    final query = _query.trim().toLowerCase();
    return _animeList.where((anime) {
      final matchStatus =
          _selectedStatus == null || anime.status == _selectedStatus;
      final matchQuery =
          query.isEmpty || anime.title.toLowerCase().contains(query);
      return matchStatus && matchQuery;
    }).toList();
  }

  void _onFilterChanged(WatchStatus? status) {
    setState(() => _selectedStatus = status);
  }

  void _onQueryChanged(String query) {
    setState(() => _query = query);
  }

  void _resetFilters() {
    _searchController.clear();
    setState(() {
      _query = '';
      _selectedStatus = null;
    });
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
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SearchField(
              controller: _searchController,
              onChanged: _onQueryChanged,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: StatusFilterTabs(
                selected: _selectedStatus,
                onChanged: _onFilterChanged,
              ),
            ),
          ),
          if (filtered.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyStateView(
                message: _isSearching
                    ? 'No anime found for "${_query.trim()}".'
                    : 'No anime in this list yet.',
                icon: _isSearching
                    ? Icons.search_off
                    : Icons.movie_creation_outlined,
                actionLabel: _hasActiveFilter ? 'Reset filters' : null,
                onAction: _hasActiveFilter ? _resetFilters : null,
              ),
            )
          else
            AnimeGrid(
              animeList: filtered,
              onCardTap: _showStatusPicker,
            ),
        ],
      ),
    );
  }
}