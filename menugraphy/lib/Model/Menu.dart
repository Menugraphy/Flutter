// menu_model.dart
class MenuItem {
  final String KoreanName;
  final String EnglishName;
  final String description;
  final int priceWon;
  final double exchangeRate = 1385.0; // USD/KRW 환율
  int quantity;
  String image;

  MenuItem({
    required this.KoreanName,
    required this.EnglishName,
    required this.description,
    required this.priceWon,
    required this.image,
    this.quantity = 0,
  });

  double get priceUSD => (priceWon / exchangeRate).toStringAsFixed(2).toDouble();
}

extension StringToDouble on String {
  double toDouble() => double.parse(this);
}