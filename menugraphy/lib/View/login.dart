import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:menugraphy/Constant/CustomColors.dart';

class LoginView extends StatelessWidget {
 const LoginView({Key? key}) : super(key: key);

@override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(390, 857),
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData.light(),
          home: Scaffold(
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(16.0.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
               SizedBox(height: 100.h),
               Text(
                 'Menugraphy',
                 style: TextStyle(
                   fontFamily: 'AppleSDGothicNeoH00',
                   fontSize: 38.sp,
                   color: CustomColorsExtension.mainColor01,
                 ),
               ),
               Text(
                 'For more convenient ordering',
                 style: TextStyle(
                   fontFamily: 'AppleSDGothicNeoM00',
                   fontSize: 18.sp,
                   color: CustomColorsExtension.text_gray02,
                 ),
               ),
               SizedBox(height: 80.h),  // 'For more convenient ordering'과 이미지 사이 간격
               Image.asset(
                 'assets/images/icon_main.png',
                 width: 130.w,
                 height: 250.h,
               ),
               SizedBox(height: 104.h),  // 이미지와 'Sign in with Apple' 버튼 사이 간격
               Container(
                 height: 60.h,
                 padding: EdgeInsets.symmetric(horizontal: 43.w),
                 child: ElevatedButton(
                   onPressed: () {},
                   style: ElevatedButton.styleFrom(
                     backgroundColor: CustomColorsExtension.navy,
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(6),
                     ),
                     minimumSize: Size(double.infinity, 60.h),
                   ),
                   child: Text(
                     'Sign in with Apple',
                     style: TextStyle(
                       fontFamily: 'AppleSDGothicNeoB00',
                       fontSize: 18.sp,
                       color: Colors.white,
                     ),
                   ),
                 ),
               ),
               SizedBox(height: 12.h),
               Container(
                 height: 60.h,
                 padding: EdgeInsets.symmetric(horizontal: 43.w),
                 child: ElevatedButton(
                   onPressed: () {},
                   style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.white,
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(6),
                       side: BorderSide(
                         color: CustomColorsExtension.line_gray,
                         width: 1,
                       ),
                     ),
                     minimumSize: Size(double.infinity, 60.h),
                   ),
                   child: Text(
                     'Sign in with Google',
                     style: TextStyle(
                       fontFamily: 'AppleSDGothicNeoB00',
                       fontSize: 18.sp,
                       color: CustomColorsExtension.text_gray03,
                     ),
                   ),
                 ),
               ),
               TextButton(  // child: 제거하고 직접 Column의 children에 추가
                style: TextButton.styleFrom(
                  textStyle: TextStyle(fontSize: 16.sp),  
                  foregroundColor: CustomColorsExtension.text_gray01
                ),
                onPressed: () {},
                child: const Text('Continue as guest'),
              ),
              const Spacer(),
             ],
           ),
         ),
       ),
     ),
   );
      });
  }
 }
