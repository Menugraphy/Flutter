import "package:menugraphy/Model/SelectionItem.dart";

class FoodData {
  static final List<SelectionItemModel> items = [
    // Vegan items
    SelectionItemModel(
      emoji: '🥗',
      text: 'Vegan',
      category: 'Vegan',
    ),
    
    // Religion items
    SelectionItemModel(
      emoji: '🕉️',
      text: 'Hinduism',
      category: 'Religion',
    ),
    SelectionItemModel(
      emoji: '🕌',
      text: 'Muslim',
      category: 'Religion',
    ),
    SelectionItemModel(
      emoji: '☪️',
      text: 'Islam',
      category: 'Religion',
    ),
    
    // Allergy items
    SelectionItemModel(
      emoji: '🥜',
      text: 'Nut',
      category: 'Allergy',
    ),
    SelectionItemModel(
      emoji: '🥛',
      text: 'Dairy',
      category: 'Allergy',
    ),
    SelectionItemModel(
      emoji: '🦐',
      text: 'Shellfish',
      category: 'Allergy',
    ),
     SelectionItemModel(
      emoji: '...',
      text: 'ETC',
      category: 'Allergy',
    ),
  ];
}