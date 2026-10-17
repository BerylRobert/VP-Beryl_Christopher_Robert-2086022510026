// Tes state: empty state (nol item, hasil search kosong) dan dark mode.
// Jalankan dari folder homework05:
//   flutter test test/states_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homework02/features/watchlist/models/anime.dart';
import 'package:homework02/features/watchlist/screens/home_screen.dart';
import 'package:homework02/features/watchlist/widgets/anime_card.dart';
import 'package:homework02/features/watchlist/widgets/empty_state_view.dart';
import 'helpers/responsive_helpers.dart';

void main() {
  group('State - empty state dan dark mode', () {
    testWidgets('6 · nol item: empty state punya ikon, pesan, dan aksi',
        (tester) async {
      await pumpApp(tester, small, items: const <Anime>[]);
      expectNoLayoutErrors(tester);

      final emptyState = find.byType(EmptyStateView);
      expect(emptyState, findsOneWidget);
      expect(
        find.descendant(of: emptyState, matching: find.byType(Icon)),
        findsWidgets,
        reason: 'Empty state perlu ikon.',
      );
      expect(
        find.descendant(of: emptyState, matching: find.byType(Text)),
        findsWidgets,
        reason: 'Empty state perlu pesan.',
      );
      expect(
        find.descendant(
          of: emptyState,
          matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
        ),
        findsOneWidget,
        reason: 'Empty state perlu tombol aksi.',
      );

      await tester.tap(find.text('Load samples'));
      await tester.pumpAndSettle();
      expect(find.byType(EmptyStateView), findsNothing);
      expect(find.byType(AnimeCard), findsWidgets);
    });

    testWidgets('6 · hasil search kosong: tombol Reset filters berfungsi',
        (tester) async {
      await pumpApp(tester, small);
      await tester.enterText(find.byType(TextField), 'zzz');
      await tester.pumpAndSettle();
      expectNoLayoutErrors(tester);

      expect(find.byType(EmptyStateView), findsOneWidget);
      expect(find.text('No anime found for "zzz".'), findsOneWidget);

      await tester.tap(find.text('Reset filters'));
      await tester.pumpAndSettle();
      expect(find.byType(EmptyStateView), findsNothing);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        isEmpty,
      );
    });

    for (final (name, size) in screens) {
      testWidgets('9 · dark mode: $name', (tester) async {
        await pumpApp(tester, size);
        expectNoLayoutErrors(tester);

        final context = tester.element(find.byType(HomeScreen));
        expect(Theme.of(context).brightness, Brightness.dark);
      });
    }

    testWidgets('9 · dark mode: pasangan warna teks cukup kontras',
        (tester) async {
      await pumpApp(tester, small);

      final colors = Theme.of(tester.element(find.byType(HomeScreen))).colorScheme;
      final pairs = <String, (Color, Color)>{
        'onSurface di surface': (colors.onSurface, colors.surface),
        'onSurfaceVariant di surface': (colors.onSurfaceVariant, colors.surface),
        'onSurfaceVariant di kartu': (
          colors.onSurfaceVariant,
          colors.surfaceContainerLow,
        ),
        'onSecondaryContainer di chip terpilih': (
          colors.onSecondaryContainer,
          colors.secondaryContainer,
        ),
      };

      for (final entry in pairs.entries) {
        final (text, background) = entry.value;
        expect(
          contrast(text, background),
          greaterThanOrEqualTo(4.5),
          reason: 'Kontras ${entry.key} terlalu rendah.',
        );
      }
    });
  });
}