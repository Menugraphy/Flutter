import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:menugraphy/Data/MenuData.dart';
import 'package:menugraphy/Model/Menu.dart';
import 'package:menugraphy/Constant/CustomColors.dart';
import 'MenuDescription.dart';
import 'MenuCheck.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true, // 타이틀 중앙 정렬
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: CustomColorsExtension.mainColor01),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'MENU',
          style: TextStyle(
              color: CustomColorsExtension.mainColor01,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100], // 배경색 회색으로 변경
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(6.w),
              itemCount: MenuData.menuItems.length,
              itemBuilder: (context, index) {
                final item = MenuData.menuItems[index];
                return _buildMenuItem(item);
              },
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.w),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MenuCheckView(),
                  ),
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
                'Go to Order List',
                style: TextStyle(fontSize: 16.sp, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(MenuItem item) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MenuDescription()),
      );
    },
    child: Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          _buildMenuImage(item.image),
          SizedBox(width: 16.w),
          Expanded(
            child: _buildMenuDetails(item),
          ),
        ],
      ),
    ),
  );
}

Widget _buildMenuImage(String image) {
  return Container(
    width: 63.w,
    height: 63.w,
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(8.r),
    ),
    child: Center(
      child: Text(
        image,
        style: TextStyle(fontSize: 20.sp),
      ),
    ),
  );
}

Widget _buildMenuDetails(MenuItem item) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        item.EnglishName,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 4.h),
      Container(
        width: 200.w,
        child: Text(
          item.description,
          style: TextStyle(
            fontSize: 10.sp,
            color: CustomColorsExtension.text_gray01,
          ),
          overflow: TextOverflow.visible,
          maxLines: null,
        ),
      ),
      _buildPriceAndQuantity(item),
    ],
  );
}

Widget _buildPriceAndQuantity(MenuItem item) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        '${item.priceWon} won (${item.priceUSD} USD)',
        style: TextStyle(
          fontSize: 12.sp,
          color: CustomColorsExtension.mainColor01,
          fontWeight: FontWeight.bold,
        ),
      ),
      _buildQuantityControls(item),
    ],
  );
}

Widget _buildQuantityControls(MenuItem item) {
  return Container(
    width: 54.w,
    height: 21.h,
    decoration: BoxDecoration(
      color: CustomColorsExtension.button_gray01,
      borderRadius: BorderRadius.circular(20.r),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildQuantityButton(
          icon: Icons.remove,
          onTap: () {
            setState(() {
              if (item.quantity > 0) item.quantity--;
            });
          },
        ),
        Text(
          '${item.quantity}',
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        _buildQuantityButton(
          icon: Icons.add,
          onTap: () {
            setState(() {
              item.quantity++;
            });
          },
        ),
      ],
    ),
  );
}

Widget _buildQuantityButton({
  required IconData icon,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Icon(
      icon,
      size: 12.w,
      color: Colors.white,
      weight: 700,
    ),
  );
}
}