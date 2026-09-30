import 'package:flutter/material.dart';
import '../models/anime.dart';

/// Bottom sheet listing every [WatchStatus] so the user can pick one.
/// Owns no state — reports the choice upward via [onSelected].
class StatusPickerSheet extends StatelessWidget {
  final String title;
  final WatchStatus current;
  final ValueChanged<WatchStatus> onSelected;

  const StatusPickerSheet({
    super.key,
    required this.title,
    required this.current,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
          for (final status in WatchStatus.values)
            ListTile(
              title: Text(watchStatusLabel(status)),
              trailing: status == current ? const Icon(Icons.check) : null,
              onTap: () => onSelected(status),
            ),
        ],
      ),
    );
  }
}