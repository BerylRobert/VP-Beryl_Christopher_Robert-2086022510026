// Test otomatis untuk sembilan tes responsif minggu 4.
// Jalankan dari folder homework04:
//   flutter test test/responsive_test.dart
//
// Setiap tes mengatur ukuran layar palsu (kadang juga keyboard atau data),
// menjalankan aplikasi, lalu gagal kalau Flutter melaporkan error layout
// apa pun ("A RenderFlex overflowed...", dan sejenisnya).
//
// Catatan: flutter test memakai font uji yang setiap hurufnya berbentuk
// kotak penuh, jadi teks terlihat jauh lebih lebar daripada di HP. Kalau
// sebuah tes gagal padahal tampilan di Chrome baik-baik saja, berarti ada
// teks tanpa strategi overflow (maxLines + ellipsis, atau ruang untuk wrap).
//
// Nama package diambil dari "name:" di pubspec.yaml.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homework02/features/watchlist/models/anime.dart';
import 'package:homework02/features/watchlist/screens/home_screen.dart';
import 'package:homework02/features/watchlist/widgets/anime_card.dart';
import 'package:homework02/features/watchlist/widgets/empty_state_view.dart';
import 'package:homework02/features/watchlist/widgets/status_picker_sheet.dart';
import 'package:homework02/main.dart';
import 'package:homework02/features/watchlist/data/sample_anime.dart';

const Size small = Size(320, 568);
const Size large = Size(430, 932);
const Size tablet = Size(800, 1280);

const List<(String, Size)> screens = [
  ('small phone', small),
  ('large phone', large),
  ('tablet', tablet),
];

// Jumlah kolom yang diharapkan di tiap lebar layar (lebar setelah diputar
// ikut dihitung): di bawah 600 dp = 2, 600-839 = 3, 840 ke atas = 4.
const List<(String, Size, int)> columnCases = [
  ('small phone', small, 2),
  ('large phone', large, 2),
  ('tablet', tablet, 3),
  ('small phone landscape', Size(568, 320), 2),
  ('large phone landscape', Size(932, 430), 4),
  ('tablet landscape', Size(1280, 800), 4),
];

final Anime longNameAnime = Anime(
  id: 'long',
  title: ('Judul anime yang sangat panjang sekali ' * 6).substring(0, 200),
  genre: 'Fantasy',
  imagePath: 'assets/images/frieren.jpg',
  totalEpisodes: 12,
  watchedEpisodes: 3,
  rating: 4.5,
  status: WatchStatus.watching,
);

final List<Anime> longNameList = [longNameAnime, ...sampleAnimeList];

final List<Anime> bigList = List.generate(
  500,
  (i) => Anime(
    id: 'gen-$i',
    title: 'Anime nomor ${i + 1}',
    genre: 'Genre',
    imagePath: 'assets/images/frieren.jpg',
    totalEpisodes: 12,
    watchedEpisodes: i % 13,
    rating: 4.0,
    status: WatchStatus.values[i % WatchStatus.values.length],
  ),
);

/// Mengatur layar palsu, menjalankan aplikasi, dan menunggu animasi selesai.
Future<void> pumpApp(
  WidgetTester tester,
  Size size, {
  List<Anime> items = sampleAnimeList,
  double keyboard = 0,
}) async {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = size;
  tester.view.viewInsets = FakeViewPadding(bottom: keyboard);
  addTearDown(tester.view.reset);

  await tester.pumpWidget(AnimeWatchlistApp(initialAnime: items));
  await tester.pumpAndSettle();
}

/// Gagal dengan pesan asli dari Flutter, supaya kelihatan widget dan piksel-nya.
/// Kalau ada beberapa error sekaligus, gulung ke atas di output untuk
/// membaca tiap error satu per satu.
void expectNoLayoutErrors(WidgetTester tester) {
  final Object? error = tester.takeException();
  expect(error, isNull, reason: 'Layout error:\n$error');
}

/// Daftar utama yang bisa di-scroll ke bawah (bukan chip, bukan kolom search).
Finder get mainScrollable => find
    .byWidgetPredicate(
      (widget) =>
          widget is Scrollable && widget.axisDirection == AxisDirection.down,
    )
    .first;

/// Jumlah kartu pada baris pertama grid = jumlah kolom.
int firstRowColumns(WidgetTester tester) {
  final cards = find.byType(AnimeCard);
  final count = cards.evaluate().length;
  final tops = [for (var i = 0; i < count; i++) tester.getRect(cards.at(i)).top];
  final firstTop = tops.reduce((a, b) => a < b ? a : b);
  return tops.where((top) => (top - firstTop).abs() < 1).length;
}

/// Menggulung kartu pertama ke layar lalu mengetuknya (membuka bottom sheet).
Future<void> openFirstCard(WidgetTester tester) async {
  final card = find.byType(AnimeCard).first;
  await tester.ensureVisible(card);
  await tester.pumpAndSettle();
  await tester.tap(card);
  await tester.pumpAndSettle();
}

/// Rasio kontras warna menurut WCAG (minimal 4.5 untuk teks biasa).
double contrast(Color a, Color b) {
  final l1 = a.computeLuminance();
  final l2 = b.computeLuminance();
  final lighter = l1 > l2 ? l1 : l2;
  final darker = l1 > l2 ? l2 : l1;
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  group('Minggu 4 - layar watchlist yang tidak overflow', () {
    for (final (name, size, columns) in columnCases) {
      testWidgets('1-4 · $name: tanpa overflow, $columns kolom', (tester) async {
        await pumpApp(tester, size);
        expectNoLayoutErrors(tester);
        expect(
          firstRowColumns(tester),
          columns,
          reason: 'Jumlah kolom di lebar ${size.width} dp seharusnya $columns.',
        );
      });
    }

    for (final (name, size) in screens) {
      testWidgets('4 · landscape: bottom sheet - $name', (tester) async {
        await pumpApp(tester, size.flipped);
        await openFirstCard(tester);
        expect(find.byType(StatusPickerSheet), findsOneWidget);
        expectNoLayoutErrors(tester);
      });
    }

    for (final (name, size) in screens) {
      for (final landscape in const [false, true]) {
        final label = landscape ? '$name, landscape' : name;
        testWidgets('5 · judul 200 karakter: $label', (tester) async {
          await pumpApp(
            tester,
            landscape ? size.flipped : size,
            items: longNameList,
          );
          expectNoLayoutErrors(tester);

          await openFirstCard(tester);
          expect(find.byType(StatusPickerSheet), findsOneWidget);
          expectNoLayoutErrors(tester);
        });
      }
    }

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

    testWidgets('7 · 500 item: dibangun malas, di-scroll jauh', (tester) async {
      await pumpApp(tester, small, items: bigList);
      expectNoLayoutErrors(tester);
      expect(
        find.byType(AnimeCard).evaluate().length,
        lessThan(100),
        reason: 'Hanya kartu yang terlihat yang boleh dibangun. '
            'Apakah ada shrinkWrap di daftar panjang?',
      );

      for (var i = 0; i < 5; i++) {
        await tester.fling(mainScrollable, const Offset(0, -2000), 3000);
        await tester.pumpAndSettle();
      }
      expectNoLayoutErrors(tester);
    });

    testWidgets('8 · keyboard terbuka di layar pendek: field tetap terlihat',
        (tester) async {
      await pumpApp(tester, small, keyboard: 260);
      expectNoLayoutErrors(tester);

      final field = tester.getRect(find.byType(TextField));
      expect(
        field.bottom,
        lessThanOrEqualTo(small.height - 260),
        reason: 'Kolom search tertutup keyboard.',
      );
      expect(
        tester.getRect(mainScrollable).bottom,
        lessThanOrEqualTo(small.height - 260),
        reason: 'Area scroll harus berakhir di atas keyboard.',
      );
    });

    testWidgets('8 · keyboard terbuka di landscape', (tester) async {
      await pumpApp(tester, small.flipped, keyboard: 180);
      expectNoLayoutErrors(tester);

      final field = tester.getRect(find.byType(TextField));
      expect(
        field.bottom,
        lessThanOrEqualTo(small.flipped.height - 180),
        reason: 'Kolom search tertutup keyboard di landscape.',
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