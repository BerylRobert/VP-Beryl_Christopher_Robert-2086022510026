# Responsive Matrix — Homework 4

Aplikasi: Anime Watchlist (tema gelap).
Layar yang diuji: `HomeScreen` (termasuk empty state) dan bottom sheet
ubah status (`StatusPickerSheet`), karena sheet ini muncul dari `HomeScreen`.

Cara uji: ukuran layar dan landscape diuji di Chrome DevTools (mode Responsive). Test Keyboard diuji di emulator  Android (Android Studio), karena Chrome tidak memunculkan keyboard virtual.

## Hasil uji

| No | Test | HomeScreen | Bottom sheet | Catatan |
|----|------|------------|--------------|---------|
| 1 | Small phone (320 dp) | Pass | Pass | 2 kolom. Sempat gagal di lebar 264 dp (lihat Bug 1). |
| 2 | Large phone (430 dp) | Pass | Pass | 2 kolom. |
| 3 | Tablet (800 dp) | Pass | Pass | Layout berubah menjadi 3 kolom. 4 kolom mulai lebar 840 dp. |
| 4 | Landscape (semua ukuran di atas) | Pass | Pass | Setelah diputar, lebar efektif bertambah, jadi jumlah kolom ikut berubah. Sempat gagal di sheet (Bug 2) dan keyboard (Bug 3). |
| 5 | Long text (judul 200 karakter) | Pass | Pass | Judul terpotong dengan titik tiga (`maxLines: 2`). Genre, episode, dan rating juga punya `maxLines: 1`. |
| 6 | Empty state (nol hasil) | Pass | - | Ada ikon, pesan, dan tombol "Reset filters". |
| 7 | Long list (500 item) | Pass | - | `SliverChildBuilderDelegate`, tanpa `shrinkWrap`. Scroll lancar dan filter tetap jalan. |
| 8 | Keyboard | Pass | - | Diuji di emulator, portrait dan landscape. Sempat gagal di landscape (Bug 3). |
| 9 | Dark mode | Pass | Pass | Aplikasi memakai tema gelap. Semua teks terbaca, termasuk teks redup (`onSurfaceVariant`). |

## Jumlah kolom per lebar layar

| Lebar efektif | Kolom |
|---------------|-------|
| di bawah 600 dp | 2 |
| 600 sampai 839 dp | 3 |
| 840 dp ke atas | 4 |

Implementasi: `SliverLayoutBuilder` di `AnimeGrid` dengan fungsi
`_columnsFor(width)`. Angka batas 600 dan 840 mengikuti kelas ukuran
layar Material 3.

## Bug yang ditemukan dan perbaikannya

### Bug 1: kartu overflow di lebar 264 dp

- **Gejala:** tulisan `BOTTOM OVERFLOWED BY 0.353 PIXELS` di dasar kartu.
- **Penyebab:** `childAspectRatio: 0.68` mengikat tinggi kartu ke
  lebarnya. Saat layar menyempit, kartu ikut pendek, padahal tinggi
  teks di dalamnya tetap.
- **Perbaikan:** `childAspectRatio` diganti `mainAxisExtent: 360`, jadi
  tinggi kartu tetap dan tidak tergantung lebar.

### Bug 2: bottom sheet overflow di landscape

- **Gejala:** `BOTTOM OVERFLOWED BY 92 PIXELS` saat kartu diketuk di
  layar landscape.
- **Penyebab:** bottom sheet dibatasi tingginya sekitar 9/16 tinggi
  layar. Di landscape (tinggi 320 dp) batas itu lebih kecil daripada
  isi sheet, dan `Column` di dalamnya tidak bisa di-scroll.
- **Perbaikan:** `Column` dibungkus `SingleChildScrollView`. Judul juga
  diberi `maxLines: 2` dan `overflow: TextOverflow.ellipsis`.

### Bug 3: keyboard menyebabkan overflow di landscape

- **Gejala:** `BOTTOM OVERFLOWED BY 58 PIXELS` saat kolom search diketuk
  di landscape.
- **Penyebab:** kolom search dan chip filter berada di `Column` dengan
  tinggi tetap. Saat keyboard muncul, tinggi body lebih kecil daripada
  tinggi header itu.
- **Perbaikan:** `Column` diganti `CustomScrollView`. Search, chip, dan
  grid berada di satu area yang bisa di-scroll. `AnimeGrid` diubah
  menjadi sliver (`SliverGrid`). Empty state memakai
  `SliverFillRemaining`.

## Hasil akhir

Kesembilan test lolos tanpa garis kuning-hitam dan tanpa konten
terpotong, di semua ukuran yang diuji.