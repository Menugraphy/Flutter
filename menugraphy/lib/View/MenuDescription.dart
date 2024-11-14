import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:menugraphy/Constant/CustomColors.dart';

class MenuDescription extends StatefulWidget {
  @override
  _MenuDescriptionState createState() => _MenuDescriptionState();
}

class _MenuDescriptionState extends State<MenuDescription> {
  bool isLiked = false;

  void _showToast(BuildContext context) {
 final overlay = OverlayEntry(
   builder: (context) => Positioned(
     bottom: 40.h,
     left: 20.w,
     right: 20.w,
     child: Container(
       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
       decoration: BoxDecoration(
         color: CustomColorsExtension.button_gray01,
         borderRadius: BorderRadius.circular(8.r),
       ),
       child: Row(
         children: [
           Container(
             width: 24.w,
             height: 24.w,
             decoration: BoxDecoration(
               shape: BoxShape.circle,
               color: Color(0xFF8B62FF),
             ),
             child: Center(
               child: Icon(
                 Icons.check,
                 color: Colors.white,
                 size: 16.w,
               ),
             ),
           ),
           Expanded(
             child: Text(
               'Like check completed',
               textAlign: TextAlign.center,
               style: TextStyle(
                 color: Colors.white,
                 fontSize: 14.sp,
               ),
             ),
           ),
           SizedBox(width: 24.w),
         ],
       ),
     ),
   ),
 );

 Overlay.of(context).insert(overlay);
 Future.delayed(Duration(seconds: 1), () {
   overlay.remove();
 });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.pop(context),
                    color: CustomColorsExtension.mainColor01,
                  ),
                ),
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/images/bulgogi.png',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        right: 20.w,
                        top: (MediaQuery.of(context).size.height * 0.3) + 30.h,
                        child: IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            size: 32.w,
                            color: CustomColorsExtension.mainColor01,
                          ),
                          onPressed: () {
                            setState(() {
                              isLiked = !isLiked;
                            });
                            if (isLiked) {
                              _showToast(context);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
