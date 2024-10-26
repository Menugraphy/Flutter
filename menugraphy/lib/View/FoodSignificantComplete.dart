// food_significant_complete.dart
import 'package:flutter/material.dart';
import 'package:menugraphy/Constant/CustomColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoodSignificantComplete extends StatefulWidget {
  const FoodSignificantComplete({Key? key}) : super(key: key);

  @override
  State<FoodSignificantComplete> createState() => _FoodSignificantState();
}

class _FoodSignificantState extends State<FoodSignificantComplete> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: CustomColorsExtension.mainColor01),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress 이미지
          Image.asset(
            'assets/images/progress3.png',
            width: MediaQuery.of(context).size.width/1.8,
            height: 35,
            fit: BoxFit.fitHeight
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
                Text(
                  'Complete',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: CustomColorsExtension.mainColor01,
                  ),
                ),
                Text(
                  "It's done!",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          // 완료 아이콘 이미지
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 19.w),
                child: Image.asset(
                  'assets/images/icon_complete.png',
                  width: double.infinity,
                  height: 352.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}