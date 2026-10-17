import 'package:flutter/material.dart';
import 'package:homework02/core/theme/app_spacing.dart';
import '../models/anime.dart';

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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium),
            ),
            for (final status in WatchStatus.values)
              ListTile(
                title: Text(watchStatusLabel(status)),
                trailing: status == current ? const Icon(Icons.check) : null,
                onTap: () => onSelected(status),
              ),
          ],
        ),
      ),
    );
  }
}