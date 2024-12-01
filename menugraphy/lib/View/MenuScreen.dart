import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:menugraphy/Constant/CustomColors.dart';
import 'package:menugraphy/Model/Menu.dart';
import 'package:menugraphy/Network/APIProvider.dart';
import 'MenuDescription.dart';
import 'MenuCheck.dart';

class MenuScreen extends StatefulWidget {
  final int imageId;

  const MenuScreen({
    Key? key,
    required this.imageId,
  }) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<MenuItem> _menuItems = [];
  bool _isLoading = true;
  final ApiProvider _apiProvider = ApiProvider();

  @override
  void initState() {
    super.initState();
    _fetchMenuItems();
  }

  Future<void> _fetchMenuItems() async {
    try {
      final response = await _apiProvider.getMenuItems(widget.imageId);
      if (response['status'] == 'success' && mounted) {
        final menuList = response['data']['menuList'] as List;
        setState(() {
          _menuItems = menuList.map((item) => MenuItem.fromJson(item)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('메뉴를 불러오는데 실패했습니다.')),
        );
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
          icon: Icon(Icons.arrow_back_ios,
              color: CustomColorsExtension.mainColor01),
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(6.w),
                    itemCount: _menuItems.length,
                    itemBuilder: (context, index) {
                      return _buildMenuItem(_menuItems[index]);
                    },
                  ),
                ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(16.w),
                  child: ElevatedButton(
                    onPressed: () {
                      final selectedItems = _menuItems
                          .where((item) => item.quantity > 0)
                          .toList();
                      if (selectedItems.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('메뉴를 선택해주세요.')),
                        );
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MenuCheckView(
                            selectedItems: selectedItems,
                            menuBoardId: widget.imageId,
                          ),
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
          MaterialPageRoute(
              builder: (context) => MenuDescription(menuId: item.id)),
        );
      },
      child: Container(
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
        weight: 700,
      ),
    );
  }
}
