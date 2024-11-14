// script_complete_view.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:menugraphy/Data/ScriptData.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:menugraphy/Constant/CustomColors.dart';
import 'CustomCamera.dart';

class ScriptCompleteView extends StatefulWidget {
  final ScriptData scriptData;

  ScriptCompleteView({required this.scriptData});

  @override
  _ScriptCompleteViewState createState() => _ScriptCompleteViewState();
}

class _ScriptCompleteViewState extends State<ScriptCompleteView> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage('ko-KR'); // 한국어 설정
  }

  Future<void> _speakKorean() async {
    await flutterTts.setLanguage('ko-KR');
    await flutterTts.speak(widget.scriptData.koreanText);
  }

  Future<void> _speakEnglish() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.speak(widget.scriptData.englishText);
  }

  void _copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColorsExtension.mainColor02,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Order Script',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // 한글 부분 (상단 50%)
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20.w),
              color: CustomColorsExtension.mainColor02,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.scriptData.koreanText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    widget.scriptData.romanizedText,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 20.sp,
                    ),
                  ),
                  Spacer(), // 아이콘을 아래로 밀어내기 위해
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        iconSize: 30.w,
                        icon: Icon(Icons.volume_up, color: Colors.white),
                        onPressed: _speakKorean,
                      ),
                      IconButton(
                        iconSize: 30.w,
                        icon: Icon(Icons.copy, color: Colors.white),
                        onPressed: () =>
                            _copyText(widget.scriptData.koreanText),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // 영어 부분 (하단 50%)
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20.w),
              color: Colors.white,
              child: Column(
                children: [
                  Text(
                    widget.scriptData.englishText,
                    style: TextStyle(
                      color: CustomColorsExtension.text_gray01,
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(), // 아이콘을 아래로 밀어내기 위해
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        iconSize: 30.w,
                        icon: Icon(Icons.volume_up),
                        onPressed: _speakEnglish,
                      ),
                      IconButton(
                        iconSize: 30.w,
                        icon: Icon(Icons.copy),
                        onPressed: () =>
                            _copyText(widget.scriptData.englishText),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: () {
                      // 모든 이전 화면들을 제거하고 CustomCamera로 이동
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomCameraView(),
                        ),
                        (route) => false, // 모든 이전 라우트 제거
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColorsExtension.mainColor02,
                      minimumSize: Size(double.infinity, 50.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'Go back to Camera',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
