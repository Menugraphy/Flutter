// food_significant.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:menugraphy/Data/FoodData.dart';
import 'package:menugraphy/Constant/CustomColors.dart';
import 'package:menugraphy/Model/SelectionItem.dart';
import 'package:menugraphy/View/FoodSignificantComplete.dart';

class FoodSignificant extends StatefulWidget {
  const FoodSignificant({Key? key}) : super(key: key);

  @override
  State<FoodSignificant> createState() => _FoodSignificantState();
}

class _FoodSignificantState extends State<FoodSignificant> {
  late List<SelectionItemModel> items;

  @override
  void initState() {
    super.initState();
    items = FoodData.items;
  }

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
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Skip',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16.sp,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // 메인 콘텐츠
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 80.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/progress1.png',
                    width: MediaQuery.of(context).size.width,
                    height: 35,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30.h),
                        Text(
                          'Food Significant',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: CustomColorsExtension.mainColor01,
                          ),
                        ),
                        Text(
                          'Select your religion or vegan or allergy',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: CustomColorsExtension.line_gray,
                          ),
                        ),
                        SizedBox(height: 30.h),
                        ...buildSections(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 고정된 하단 버튼
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0),
                    Colors.white.withOpacity(0.8),
                    Colors.white,
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
              child: SafeArea(
                top: false,
                child: ElevatedButton(
                  onPressed: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodSignificantComplete(), 
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColorsExtension.mainColor01,
                    minimumSize: Size(double.infinity, 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Next Step',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildSections() {
    final categories = items.map((item) => item.category).toSet().toList();
    List<Widget> sections = [];

    for (String category in categories) {
      sections.addAll([
        Text(
          category,
          style: TextStyle(
            fontSize: 18.sp,
            color: CustomColorsExtension.mainColor01,
          ),
        ),
        SizedBox(height: 10.h),
        ...items
            .where((item) => item.category == category)
            .map((item) => Column(
                  children: [
                    _buildSelectionItem(item),
                    SizedBox(height: 10.h),
                  ],
                ))
            .toList(),
        SizedBox(height: 20.h),
      ]);
    }

    return sections;
  }

  Widget _buildSelectionItem(SelectionItemModel item) {
    return GestureDetector(
      onTap: () {
        setState(() {
          for (var i in items.where((i) => i.category == item.category)) {
            i.isSelected = false;
          }
          item.isSelected = !item.isSelected;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: item.isSelected
                ? CustomColorsExtension.mainColor01
                : CustomColorsExtension.line_gray,
            width: item.isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              item.emoji,
              style: TextStyle(fontSize: 24.sp),
            ),
            SizedBox(width: 12.w),
            Text(
              item.text,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
