// Data dan fungsi bantu untuk tes responsif.
// Bukan file tes (namanya tidak berakhiran _test.dart), jadi
// flutter test tidak menjalankannya langsung.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homework02/features/watchlist/data/sample_anime.dart';
import 'package:homework02/features/watchlist/models/anime.dart';
import 'package:homework02/features/watchlist/widgets/anime_card.dart';
import 'package:homework02/main.dart';

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