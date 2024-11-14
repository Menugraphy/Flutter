import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:menugraphy/Constant/CustomColors.dart';
import 'package:menugraphy/Data/MenuData.dart';
import 'package:menugraphy/Model/Menu.dart';
import 'ScriptComplete.dart';
import 'package:menugraphy/Data/ScriptData.dart';

class MenuCheckView extends StatefulWidget {
  @override
  _MenuCheckViewState createState() => _MenuCheckViewState();
}

class _MenuCheckViewState extends State<MenuCheckView> {
  int get totalWon => MenuData.menuItems
      .map((item) => item.priceWon * item.quantity)
      .fold(0, (prev, amount) => prev + amount);

  double get totalUSD => (totalWon / 1385.0).toStringAsFixed(2).toDouble();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
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
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(6.w),
              itemCount:
                  MenuData.menuItems.where((item) => item.quantity > 0).length,
              itemBuilder: (context, index) {
                final item = MenuData.menuItems
                    .where((item) => item.quantity > 0)
                    .toList()[index];
                return _buildMenuItem(item);
              },
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        color: CustomColorsExtension.mainColor01,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$totalWon won',
                          style: TextStyle(
                            color: CustomColorsExtension.mainColor01,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$totalUSD USD',
                          style: TextStyle(
                            color: CustomColorsExtension.text_gray01,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () {
                    // 주문된 아이템만 필터링
                    final orderedItems = MenuData.menuItems
                        .where((item) => item.quantity > 0)
                        .toList();

                    if (orderedItems.isNotEmpty) {
                      final scriptData =
                          ScriptDataProvider.generateScript(orderedItems);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScriptCompleteView(
                            scriptData: scriptData,
                          ),
                        ),
                      );
                    } else {
                      // 주문된 아이템이 없는 경우 알림
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please select at least one item'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColorsExtension.mainColor02,
                    minimumSize: Size(double.infinity, 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Generate Order Script',
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(MenuItem item) {
    return Container(
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
    );
  }

  // MenuScreen의 나머지 위젯 메서드들도 동일하게 사용
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
