// Tes layout: tanpa overflow di berbagai ukuran layar, orientasi,
// judul panjang, daftar besar, dan keyboard.
// Jalankan dari folder homework05:
//   flutter test test/layout_test.dart
//
// Catatan: flutter test memakai font uji yang setiap hurufnya berbentuk
// kotak penuh, jadi teks terlihat jauh lebih lebar daripada di HP. Kalau
// sebuah tes gagal padahal tampilan di Chrome baik-baik saja, berarti ada
// teks tanpa strategi overflow (maxLines + ellipsis, atau ruang untuk wrap).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homework02/features/watchlist/widgets/anime_card.dart';
import 'package:homework02/features/watchlist/widgets/status_picker_sheet.dart';
import 'helpers/responsive_helpers.dart';

void main() {
  group('Layout - tanpa overflow di berbagai layar', () {
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
  });
}