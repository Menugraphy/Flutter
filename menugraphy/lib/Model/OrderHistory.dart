class OrderHistory {
  final String title;
  final String orderedAt;
  final int totalPrice;
  final String localizedTotalPrice;
  final List<MenuOrder> menuOrderList;

  OrderHistory({
    required this.title,
    required this.orderedAt,
    required this.totalPrice,
    required this.localizedTotalPrice,
    required this.menuOrderList,
  });

  factory OrderHistory.fromJson(Map<String, dynamic> json) {
    return OrderHistory(
      title: json['title'],
      orderedAt: json['orderedAt'],
      totalPrice: json['totalPrice'],
      localizedTotalPrice: json['localizedTotalPrice'],
      menuOrderList: (json['menuOrderList'] as List)
          .map((item) => MenuOrder.fromJson(item))
          .toList(),
    );
  }
}

class MenuOrder {
  final String foodImage;
  final String menuName;
  final int menuCount;

  MenuOrder({
    required this.foodImage,
    required this.menuName,
    required this.menuCount,
  });

  factory MenuOrder.fromJson(Map<String, dynamic> json) {
    return MenuOrder(
      foodImage: json['foodImage'],
      menuName: json['menuName'],
      menuCount: json['menuCount'],
    );
  }
}