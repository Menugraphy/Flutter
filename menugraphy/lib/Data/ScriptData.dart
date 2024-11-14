import 'package:menugraphy/Model/Menu.dart';

class ScriptData {
  final String koreanText;
  final String romanizedText;
  final String englishText;

  ScriptData({
    required this.koreanText,
    required this.romanizedText,
    required this.englishText,
  });
}

// script_data.dart
class ScriptDataProvider {
  static ScriptData generateScript(List<MenuItem> orderedItems) {
    // 한글용과 영어용 아이템 맵 따로 생성
    Map<String, int> koreanCounts = {};
    Map<String, int> englishCounts = {};
    
    for (var item in orderedItems) {
      if (item.quantity > 0) {
        koreanCounts[item.KoreanName] = (koreanCounts[item.KoreanName] ?? 0) + item.quantity;
        englishCounts[item.EnglishName] = (englishCounts[item.EnglishName] ?? 0) + item.quantity;
      }
    }

    // 한글 스크립트 생성
    List<String> koreanItems = [];
    koreanCounts.forEach((name, count) {
      koreanItems.add('$name ${count}개');
    });

    // 영어 스크립트 생성
    List<String> englishItems = [];
    englishCounts.forEach((name, count) {
      englishItems.add('$count $name');  // 영어는 숫자가 앞에 오고 '개' 없음
    });

    return ScriptData(
      koreanText: '${koreanItems.join(', ')} 주문할게요.',
      romanizedText: '${englishItems.join(', ')} jumunhalgeyo.',  // 영어 이름 사용
      englishText: "I'd like to order ${englishItems.join(' and ')}, please.",  // 영어 이름 사용
    );
  }
}