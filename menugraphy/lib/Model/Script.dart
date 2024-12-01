class ScriptData {
  final String koreanText;
  final String romanizedText;
  final String englishText;

  ScriptData({
    required this.koreanText,
    required this.romanizedText,
    required this.englishText,
  });

  factory ScriptData.fromJson(Map<String, dynamic> json) {
    return ScriptData(
      koreanText: json['korean'] ?? '',
      romanizedText: json['romanized'] ?? '',
      englishText: json['translatedText'] ?? '',
    );
  }
}