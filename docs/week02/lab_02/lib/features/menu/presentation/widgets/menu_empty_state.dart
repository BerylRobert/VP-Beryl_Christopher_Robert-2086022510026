import 'package:flutter/material.dart';

class MenuEmptyState extends StatelessWidget {
  const MenuEmptyState({super.key, required this.query, required this.onClear});

  final String query;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off, size: 48, color: Colors.grey),
          const SizedBox(height: 8),
          Text(
            'Tidak ada menu yang cocok dengan "$query"',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: onClear, child: const Text('Hapus pencarian')),
        ],
      ),
    );
  }
}