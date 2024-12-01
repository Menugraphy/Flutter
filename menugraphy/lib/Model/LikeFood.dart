class LikedFood {
  final int id;
  final String foodImage;
  final String name;
  final List<FoodType> foodTypeList;

  LikedFood({
    required this.id,
    required this.foodImage,
    required this.name,
    required this.foodTypeList,
  });

  factory LikedFood.fromJson(Map<String, dynamic> json) {
    return LikedFood(
      id: json['id'],
      foodImage: json['foodImage'],
      name: json['name'],
      foodTypeList: (json['foodTypeList'] as List)
          .map((type) => FoodType.fromJson(type))
          .toList(),
    );
  }
}

class FoodType {
  final String name;

  FoodType({required this.name});

  factory FoodType.fromJson(Map<String, dynamic> json) {
    return FoodType(name: json['name']);
  }
}