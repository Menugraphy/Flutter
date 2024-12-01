// menu.dart
class MenuItem {
  final int id;
  final String image;
  final String name;
  final String description;
  final int price;
  final String localizedPrice;
  final bool isAvoidanceFood;
  int quantity;

  MenuItem({
    required this.id,
    required this.image,
    required this.name,
    required this.description,
    required this.price,
    required this.localizedPrice,
    required this.isAvoidanceFood,
    this.quantity = 0,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as int,
      image: json['image'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as int,
      localizedPrice: json['localizedPrice'] as String,
      isAvoidanceFood: json['isAvoidanceFood'] as bool,
    );
  }
}