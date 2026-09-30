import 'package:flutter/material.dart';
import '../models/anime.dart';

/// Renders one selectable chip per [WatchStatus], plus an "All" chip.
/// Owns no state itself — [selected] and [onChanged] are fully controlled
/// by the parent (state is hoisted to HomeScreen).
class StatusFilterTabs extends StatelessWidget {
  final WatchStatus? selected;
  final ValueChanged<WatchStatus?> onChanged;

  const StatusFilterTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: const Text('All'),
              selected: selected == null,
              onSelected: (_) => onChanged(null),
            ),
          ),
          for (final status in WatchStatus.values)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                label: Text(watchStatusLabel(status)),
                selected: selected == status,
                onSelected: (_) => onChanged(status),
              ),
            ),
        ],
      ),
    );
  }
}