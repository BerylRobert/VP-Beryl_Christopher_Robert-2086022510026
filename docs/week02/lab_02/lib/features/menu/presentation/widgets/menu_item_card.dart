import 'package:flutter/material.dart';
import '../../../../lab02_start.dart';
import 'price_chip.dart';

/// Satu kartu untuk satu item menu: nama, badge promo, harga, dan
/// tombol +/- buat atur jumlah.
///
/// TRIGGER: REUSE.
/// Widget ini dipanggil ULANG-ULANG oleh ListView.builder, satu kali
/// per item yang keliatan (bisa 8x, bisa 3x kalau lagi difilter search).
/// Ini kandidat paling jelas buat diekstrak -- dia literally dipakai
/// berkali-kali di satu waktu, bukan cuma "dipisah biar rapi".
///
/// Perhatikan: dia TIDAK punya state sendiri (bukan StatefulWidget).
/// Angka quantity-nya (`qty`) datang dari parameter, dan kalau user
/// pencet tombol, dia cuma "lapor" lewat callback. Yang nyimpen angka
/// aslinya tetap _MenuScreenState -- itu maksud dari "hoist state
/// correctly, no child owns data another child needs".
class MenuItemCard extends StatelessWidget {
  const MenuItemCard({
    super.key,
    required this.item,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final MenuItem item;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (item.promo) const SizedBox(width: 6),
                      if (item.promo)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .tertiaryContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'PROMO',
                            style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onTertiaryContainer,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  PriceChip(price: item.price),
                ],
              ),
            ),
            IconButton(
              onPressed: quantity == 0 ? null : onDecrement,
              icon: const Icon(Icons.remove_circle_outline),
            ),
            SizedBox(
              width: 28,
              child: Text(
                '$quantity',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
            IconButton(
              onPressed: quantity >= 99 ? null : onIncrement,
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ),
    );
  }
}