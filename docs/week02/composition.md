# Justfication - H3

## Widget yang Diekstrak

### 1. AnimeCard

- **Trigger:** Reuse. Widget ini dipakai berulang kali di dalam grid, satu instance untuk setiap anime yang ditampilkan. Misalnya jika ada 5 anime yang tampil, `AnimeCard` akan dipanggil 5 kali dengan data yang berbeda-beda.
- **Owns:** Tidak memiliki state. Yang menjadi tanggung jawabnya hanya cara menampilkan satu anime: gambar, judul, genre, progress bar, dan rating. Data `anime` dan fungsi `onTap` diterima dari parent (`AnimeGrid`), bukan dibuat sendiri.
- **Reports upward:** Saat kartu diketuk, widget ini memanggil fungsi `onTap` yang diberikan oleh parent. `AnimeCard` sendiri tidak tahu apa yang akan terjadi setelah fungsi itu dipanggil — ia hanya melaporkan bahwa kartu telah diketuk.

### 2. AnimeGrid

- **Trigger:** Readability. Widget ini memisahkan logic penyusunan banyak `AnimeCard` menjadi grid (jumlah kolom, jarak antar kartu) dari kode `HomeScreen`, supaya `build()` milik `HomeScreen` tidak terlalu panjang.
- **Owns:** Konfigurasi layout grid saja (jumlah kolom, spacing, rasio ukuran kartu). Tidak menyimpan data anime sendiri; daftar `animeList` diterima dari parent.
- **Reports upward:** Ketika salah satu kartu diketuk, widget ini meneruskan sinyal tersebut ke parent melalui `onCardTap`, sambil menyertakan data anime mana yang diketuk.

### 3. StatusFilterTabs

- **Trigger:** Readability. Baris chip untuk memilih status (Watching, Completed, dst.) dipisahkan dari `HomeScreen` agar kode filter tidak bercampur dengan kode utama layar.
- **Owns:** Tidak memiliki state. Status yang sedang aktif (`selected`) ditentukan sepenuhnya oleh `HomeScreen` dan hanya ditampilkan oleh widget ini.
- **Reports upward:** Saat pengguna memilih chip lain, widget ini memanggil `onChanged(status)` dengan status baru yang dipilih. `HomeScreen` yang kemudian memutuskan untuk memfilter ulang daftar anime.

### 4. EmptyStateView

- **Trigger:** Reuse. Tampilan ini digunakan setiap kali hasil filter kosong, misalnya hasil pencarian yang tidak ditemukan.
- **Owns:** Tidak memiliki state. Hanya menampilkan teks pesan dan ikon yang diberikan oleh parent.
- **Reports upward:** Tidak ada. Widget ini tidak memiliki elemen yang dapat ditekan, sehingga tidak ada kejadian yang perlu dilaporkan.

### 5. StatusPickerSheet

- **Trigger:** Readability. Isi bottom sheet untuk mengubah status anime dipisahkan dari method di `HomeScreen`, supaya logic "kapan menampilkan sheet" dan "apa isi sheet" tidak tercampur dalam satu fungsi yang panjang.
- **Owns:** Tidak memiliki state. Hanya menampilkan judul anime dan daftar seluruh status yang tersedia untuk dipilih.
- **Reports upward:** Saat pengguna memilih status baru, widget ini memanggil `onSelected(status)`. `HomeScreen` kemudian benar-benar mengubah data anime (melalui `Anime.copyWith`) dan menutup sheet.

## Kenapa State Hanya Ada di HomeScreen

`_animeList` dan `_selectedStatus` disebut state karena keduanya dapat berubah seiring waktu dan perubahannya memengaruhi tampilan di layar. Dengan menyimpan keduanya hanya di `_HomeScreenState`, aplikasi memiliki satu sumber data yang pasti benar. Kelima widget di atas menjadi murni fungsi dari data yang diterimanya — hal ini membuat setiap widget lebih mudah dipahami, diuji, dan digunakan kembali secara terpisah dari bagian aplikasi lainnya.