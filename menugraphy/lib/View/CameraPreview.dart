import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:menugraphy/Constant/CustomColors.dart';
import 'package:menugraphy/View/MenuScreen.dart';

class CameraPreviewView extends StatelessWidget {
  final XFile image;

  const CameraPreviewView({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                'assets/images/ocr_result.jpg',
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: CustomColorsExtension.navy,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Menugraphy',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.person_outline, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20.h,
              left: 16.w,
              right: 16.w,
              child: ElevatedButton(
                onPressed: () {
                  try {
                    print("Attempting navigation..."); // 디버깅용 출력
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MenuScreen(),
                      ),
                    )
                        .then((_) => print("Navigation completed")) // 성공 시 출력
                        .catchError((error) =>
                            print("Navigation error: $error")); // 에러 발생 시 출력
                  } catch (e) {
                    print("Error in onPressed: $e"); // try-catch에서 잡히는 에러 출력
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColorsExtension.mainColor02,
                  minimumSize: Size(double.infinity, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 1;

    final verticalSpacing = size.width / 3;
    for (var i = 1; i < 3; i++) {
      final x = verticalSpacing * i;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    final horizontalSpacing = size.height / 3;
    for (var i = 1; i < 3; i++) {
      final y = horizontalSpacing * i;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
