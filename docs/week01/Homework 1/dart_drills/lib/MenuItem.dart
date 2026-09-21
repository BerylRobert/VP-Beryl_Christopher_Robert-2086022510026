class MenuItem {
  final String name;
  final double price;
  final double? discountPercent;

  MenuItem(
    this.name,
    this.price,
    {this.discountPercent}
  );

  double finalPrice() {
    final discount = discountPercent ?? 0;
    return price - (price * discount / 100);
  }

  @override
  String toString() =>
      '$name (Rp${price.toStringAsFixed(0)}, '
      'final: Rp${finalPrice().toStringAsFixed(0)})';
}

void main() {
  final List<MenuItem> menu = [
    MenuItem('Es Teh', 5000),
    MenuItem('Nasi Goreng', 20000, discountPercent: 10),
    MenuItem('Kerupuk', 3000),
    MenuItem('Ayam Bakar', 25000, discountPercent: 20),
    MenuItem('Es Jeruk',8000, discountPercent: 5),
  ];

  final List<String> allNames = menu.map((item) => item.name).toList();
  print('Names: $allNames');

  final List<MenuItem> cheapItems = menu.where((item) => item.finalPrice() < 15000).toList();
  print('Under Rp15.000: $cheapItems');
  
  final double total = menu.fold(0.0, (previousTotal, item) => previousTotal + item.finalPrice());
  print('Total: Rp${total.toStringAsFixed(0)}');
}