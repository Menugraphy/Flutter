// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:menugraphy/Constant/CustomColors.dart';
// import 'package:menugraphy/Data/MenuData.dart';
// import 'package:menugraphy/Model/Menu.dart';

// class OrderListView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios,
//               color: CustomColorsExtension.mainColor01),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           'Show Menu',
//           style: TextStyle(
//               color: CustomColorsExtension.mainColor01,
//               fontSize: 20.sp,
//               fontWeight: FontWeight.bold),
//         ),
//         elevation: 0,
//       ),
//       backgroundColor: Colors.grey[100],
//       body: ListView.builder(
//         padding: EdgeInsets.all(6.w),
//         itemCount: MenuData.menuItems.where((item) => item.quantity > 0).length,
//         itemBuilder: (context, index) {
//           final item = MenuData.menuItems
//               .where((item) => item.quantity > 0)
//               .toList()[index];
//           return _buildMenuItem(item);
//         },
//       ),
//     );
//   }

//   Widget _buildMenuItem(MenuItem item) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 16.h),
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8.r),
//       ),
//       child: Row(
//         children: [
//           _buildMenuImage(item.image),
//           SizedBox(width: 16.w),
//           Expanded(
//             child: _buildMenuDetails(item),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMenuImage(String image) {
//     return Container(
//       width: 63.w,
//       height: 63.w,
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(8.r),
//       ),
//       child: Center(
//         child: Text(
//           image,
//           style: TextStyle(fontSize: 20.sp),
//         ),
//       ),
//     );
//   }

//   Widget _buildMenuDetails(MenuItem item) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           item.EnglishName,
//           style: TextStyle(
//             fontSize: 14.sp,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: 4.h),
//         Container(
//           width: 200.w,
//           child: Text(
//             item.description,
//             style: TextStyle(
//               fontSize: 10.sp,
//               color: CustomColorsExtension.text_gray01,
//             ),
//             overflow: TextOverflow.visible,
//             maxLines: null,
//           ),
//         ),
//         SizedBox(height: 8.h),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               '${item.priceWon} won (${item.priceUSD} USD)',
//               style: TextStyle(
//                 fontSize: 12.sp,
//                 color: CustomColorsExtension.mainColor01,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }