import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:menugraphy/Constant/CustomColors.dart';
import 'package:menugraphy/Model/Menu.dart';
import 'package:menugraphy/Model/Script.dart';
import 'package:menugraphy/Network/APIProvider.dart';
import 'ScriptComplete.dart';

class MenuCheckView extends StatefulWidget {
  final List<MenuItem> selectedItems;
  final int menuBoardId;

  const MenuCheckView({
    Key? key,
    required this.selectedItems,
    required this.menuBoardId,
  }) : super(key: key);

  @override
  _MenuCheckViewState createState() => _MenuCheckViewState();
}

class _MenuCheckViewState extends State<MenuCheckView> {
  final ApiProvider _apiProvider = ApiProvider();
  bool _isLoading = false;

  // 원화 총액 계산
  int get totalPrice => widget.selectedItems
      .map((item) => item.price * item.quantity)
      .fold(0, (prev, amount) => prev + amount);

  Future<void> _generateOrderScript() async {
    if (widget.selectedItems.isEmpty || 
        !widget.selectedItems.any((item) => item.quantity > 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one item')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final menuOrderList = widget.selectedItems
          .where((item) => item.quantity > 0)
          .map((item) => {
                'menuId': item.id,
                'menuCount': item.quantity,
              })
          .toList();

      final response = await _apiProvider.createOrderScript(
        widget.menuBoardId,
        menuOrderList,
      );

      if (response['status'] == 'success') {
        final scriptData = ScriptData.fromJson(response['data']);
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScriptCompleteView(
                scriptData: scriptData,
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: CustomColorsExtension.mainColor01),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'MENU',
          style: TextStyle(
            color: CustomColorsExtension.mainColor01,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(6.w),
              itemCount: widget.selectedItems.length,
              itemBuilder: (context, index) {
                final item = widget.selectedItems[index];
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
                          '${totalPrice}원',
                          style: TextStyle(
                            color: CustomColorsExtension.mainColor01,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.selectedItems.isNotEmpty 
                              ? widget.selectedItems.first.localizedPrice 
                              : "0.00 USD",
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
                  onPressed: _isLoading ? null : _generateOrderScript,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColorsExtension.mainColor02,
                    minimumSize: Size(double.infinity, 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20.h,
                          width: 20.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
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
        border: item.isAvoidanceFood 
            ? Border.all(color: Colors.red.withOpacity(0.5), width: 2)
            : null,
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

  Widget _buildMenuImage(String imageUrl) {
    return Container(
      width: 63.w,
      height: 63.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: Icon(Icons.restaurant_menu, color: Colors.grey),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuDetails(MenuItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.name,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (item.isAvoidanceFood)
          Text(
            '⚠️ Contains avoided ingredients',
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.red,
              fontWeight: FontWeight.w500,
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${item.price}원',
              style: TextStyle(
                fontSize: 12.sp,
                color: CustomColorsExtension.mainColor01,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              item.localizedPrice,
              style: TextStyle(
                fontSize: 10.sp,
                color: CustomColorsExtension.text_gray02,
              ),
            ),
          ],
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
      ),
    );
  }
}