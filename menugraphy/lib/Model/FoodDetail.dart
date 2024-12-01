class FoodDetail {
  final int id;           // foodId로 받아서 id로 저장
  final String image;
  final String name;
  final String description;
  final List<FoodType> foodTypeList;
  final List<SimilarFood> similarFoodList;
  final bool isLiked;    // API에는 없지만 일단 유지

  FoodDetail({
    required this.id,
    required this.image,
    required this.name,
    required this.description,
    required this.foodTypeList,
    required this.similarFoodList,
    this.isLiked = false,  // 기본값 false로 설정
  });


  factory FoodDetail.fromJson(Map<String, dynamic> json) {
    return FoodDetail(
      id: json['foodId'] as int,  // foodId를 id로 매핑
      image: json['image'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      foodTypeList: (json['foodTypeList'] as List)
          .map((type) => FoodType.fromJson(type as Map<String, dynamic>))
          .toList(),
      similarFoodList: (json['similarFoodList'] as List)
          .map((food) => SimilarFood.fromJson(food as Map<String, dynamic>))
          .toList(),
    );
  }
  
  FoodDetail copyWith({
    int? id,
    String? image,
    List<FoodType>? foodTypeList,
    String? name,
    String? description,
    List<SimilarFood>? similarFoodList,
    bool? isLiked,
  }) {
    return FoodDetail(
      id: id ?? this.id,
      image: image ?? this.image,
      foodTypeList: foodTypeList ?? this.foodTypeList,
      name: name ?? this.name,
      description: description ?? this.description,
      similarFoodList: similarFoodList ?? this.similarFoodList,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}


class FoodType {
  final String typeName;

  FoodType({required this.typeName});

  factory FoodType.fromJson(Map<String, dynamic> json) {
    return FoodType(
      typeName: json['typeName'] as String,
    );
  }
}

class SimilarFood {
  final String name;
  final String image;

  SimilarFood({
    required this.name,
    required this.image,
  });

  factory SimilarFood.fromJson(Map<String, dynamic> json) {
    return SimilarFood(
      name: json['name'] as String,
      image: json['image'] as String,
    );
  }
}