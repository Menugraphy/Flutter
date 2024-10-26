
class SelectionItemModel {
  final String emoji;
  final String text;
  final String category;
  bool isSelected;  

  SelectionItemModel({
    required this.emoji,
    required this.text,
    required this.category,
    this.isSelected = false,
  });
}