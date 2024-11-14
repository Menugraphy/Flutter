import 'package:menugraphy/Model/Menu.dart';

// menu_data.dart
class MenuData {
  static List<MenuItem> menuItems = [
     MenuItem(
      KoreanName: '불고기',
      EnglishName: 'Bulgogi',
      description: 'sliced pork of beef, matured intoa sauce, and then grilled',
      priceWon: 9000,
      image: '🍖',
    ),
    MenuItem(
      KoreanName: '육개장',
      EnglishName: 'Yukgaejang',
      description: 'A soup made of beef brisket, radishchive, taro stems, and fiddleheads',
      priceWon: 8000,
      image: '🥣',
    ),
    MenuItem(
      KoreanName: '돼지불백',
      EnglishName: 'Bulbaek',
      description: 'Korean set menu with pork bulgogi',
      priceWon: 8000,
      image: '🍖',
    ),
      MenuItem(
      KoreanName: '육회비빔밥',
      EnglishName: 'yukhoe bibimbap',
      description: 'beef tartare bibimbap',
      priceWon: 9000,
      image: '🍚',
    ),
      MenuItem(
      KoreanName: '차돌된장찌개',
      EnglishName: 'chadol doenjang jjigae',
      description: 'soybean paste stew with brisket point',
      priceWon: 8000,
      image: '🥣',
    ),
      MenuItem(
      KoreanName: '김치찌개',
      EnglishName: 'kimchi jjigae',
      description: 'kimchi stew',
      priceWon: 8000,
      image: '🥘',
    ),
  ];
}