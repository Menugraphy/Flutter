import 'package:flutter/material.dart';

// CustomColors 클래스 정의
class CustomColors extends ThemeExtension<CustomColors> {
 final Color main01;
 final Color main02;
 final Color point01;
 final Color point02;
 final Color blackColor;
 final Color cameraBlack;
 final Color iconBackground;
 final Color background2;
 final Color lineGray;
 final Color lineGray02;
 final Color textGray01;
 final Color buttonGray01;
 final Color textGray02;
 final Color textGray03;
 final Color alertGray;
 final Color navyColor;

 CustomColors({
   required this.main01,
   required this.main02,
   required this.point01,
   required this.point02,
   required this.blackColor,
   required this.cameraBlack,
   required this.iconBackground,
   required this.background2,
   required this.lineGray,
   required this.lineGray02,
   required this.textGray01,
   required this.buttonGray01,
   required this.textGray02,
   required this.textGray03,
   required this.alertGray,
   required this.navyColor,
 });

 @override
 CustomColors copyWith({
   Color? main01,
   Color? main02,
   Color? point01,
   Color? point02,
   Color? blackColor,
   Color? cameraBlack,
   Color? iconBackground,
   Color? background2,
   Color? lineGray,
   Color? lineGray02,
   Color? textGray01,
   Color? buttonGray01,
   Color? textGray02,
   Color? textGray03,
   Color? alertGray,
   Color? navyColor,
 }) {
   return CustomColors(
     main01: main01 ?? this.main01,
     main02: main02 ?? this.main02,
     point01: point01 ?? this.point01,
     point02: point02 ?? this.point02,
     blackColor: blackColor ?? this.blackColor,
     cameraBlack: cameraBlack ?? this.cameraBlack,
     iconBackground: iconBackground ?? this.iconBackground,
     background2: background2 ?? this.background2,
     lineGray: lineGray ?? this.lineGray,
     lineGray02: lineGray02 ?? this.lineGray02,
     textGray01: textGray01 ?? this.textGray01,
     buttonGray01: buttonGray01 ?? this.buttonGray01,
     textGray02: textGray02 ?? this.textGray02,
     textGray03: textGray03 ?? this.textGray03,
     alertGray: alertGray ?? this.alertGray,
     navyColor: navyColor ?? this.navyColor,
   );
 }

 @override
 ThemeExtension<CustomColors> lerp(ThemeExtension<CustomColors>? other, double t) {
   if (other is! CustomColors) {
     return this;
   }
   return CustomColors(
     main01: Color.lerp(main01, other.main01, t)!,
     main02: Color.lerp(main02, other.main02, t)!,
     point01: Color.lerp(point01, other.point01, t)!,
     point02: Color.lerp(point02, other.point02, t)!,
     blackColor: Color.lerp(blackColor, other.blackColor, t)!,
     cameraBlack: Color.lerp(cameraBlack, other.cameraBlack, t)!,
     iconBackground: Color.lerp(iconBackground, other.iconBackground, t)!,
     background2: Color.lerp(background2, other.background2, t)!,
     lineGray: Color.lerp(lineGray, other.lineGray, t)!,
     lineGray02: Color.lerp(lineGray02, other.lineGray02, t)!,
     textGray01: Color.lerp(textGray01, other.textGray01, t)!,
     buttonGray01: Color.lerp(buttonGray01, other.buttonGray01, t)!,
     textGray02: Color.lerp(textGray02, other.textGray02, t)!,
     textGray03: Color.lerp(textGray03, other.textGray03, t)!,
     alertGray: Color.lerp(alertGray, other.alertGray, t)!,
     navyColor: Color.lerp(navyColor, other.navyColor, t)!,
   );
 }
}

// 색상 상수를 위한 extension
extension CustomColorsExtension on ColorScheme {
 // Main Colors
 static const Color mainColor01 = Color(0xFF8287FE);  
 static const Color mainColor02 = Color(0xFFA881FD); 
 
 // Point Colors
 static const Color pointColor01 = Color(0xFF8287FE);
 static const Color pointColor02 = Color(0x178287FE); // 9% opacity
 
 // Black & Gray Colors
 static const Color black = Color(0xFF343433);
 static const Color camera_black = Color(0xFF000000);
 static const Color icon_background = Color(0xFFF7F6F4);
 static const Color background02 = Color(0xFFF7F6F4);  // icon_background와 동일
 
 // Line Colors
 static const Color line_gray = Color(0xFFCDCDCD);
 static const Color line_gray02 = Color(0x38757473); // 22% opacity
 
 // Text Colors
 static const Color text_gray01 = Color(0xCC757473); // 80% opacity
 static const Color button_gray01 = Color(0xFF757473);
 static const Color text_gray02 = Color(0xFF979797);
 static const Color text_gray03 = Color(0xFF6F6F6E);
 
 // Alert & Special Colors
 static const Color alert_gray = Color(0x7A343433); // 48% opacity
 static const Color navy = Color(0xFF3F4857);
}

// Theme 확장을 위한 메서드
extension ThemeCustomColors on ThemeData {
 CustomColors get customColors => extension<CustomColors>()!;
}

// 테마 데이터 설정
ThemeData appTheme = ThemeData(
 extensions: [
   CustomColors(
     main01: CustomColorsExtension.mainColor01,
     main02: CustomColorsExtension.mainColor02,
     point01: CustomColorsExtension.pointColor01,
     point02: CustomColorsExtension.pointColor02,
     blackColor: CustomColorsExtension.black,
     cameraBlack: CustomColorsExtension.camera_black,
     iconBackground: CustomColorsExtension.icon_background,
     background2: CustomColorsExtension.background02,
     lineGray: CustomColorsExtension.line_gray,
     lineGray02: CustomColorsExtension.line_gray02,
     textGray01: CustomColorsExtension.text_gray01,
     buttonGray01: CustomColorsExtension.button_gray01,
     textGray02: CustomColorsExtension.text_gray02,
     textGray03: CustomColorsExtension.text_gray03,
     alertGray: CustomColorsExtension.alert_gray,
     navyColor: CustomColorsExtension.navy,
   ),
 ],
);