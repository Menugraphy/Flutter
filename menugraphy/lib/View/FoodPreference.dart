// food_Preference.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:menugraphy/Data/FoodPreferenceData.dart';
import 'package:menugraphy/Constant/CustomColors.dart';
import 'package:menugraphy/Model/SelectionItem.dart';
import 'package:menugraphy/View/FoodSignificantComplete.dart';
import 'package:menugraphy/View/Component/SelectionItemWidget.dart';

class FoodPreference extends StatefulWidget {
  const FoodPreference({Key? key}) : super(key: key);

  @override
  State<FoodPreference> createState() => _FoodPreferenceState();
}

class _FoodPreferenceState extends State<FoodPreference> {
  late List<SelectionItemModel> items;
  late String selectedCategory;
  Map<String, bool> categoryAllSelected = {};

  @override
  void initState() {
    super.initState();
    items = FoodPreferenceData.items;
    selectedCategory = items.first.category;
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
                    'assets/images/progress2.png',
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
                        Center(
                          // 제목을 Center 위젯으로 감싸기
                          child: Column(
                            children: [
                              Text(
                                'Food Preferences',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  color: CustomColorsExtension.mainColor01,
                                ),
                              ),
                              Text(
                                'Select Food you can’t eat',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: CustomColorsExtension.line_gray,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                        _buildCategoryFilter(),
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

  Widget _buildAllCheckbox(String category) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'All',
          style: TextStyle(
            fontSize: 14.sp,
            color: CustomColorsExtension.mainColor01,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: () {
            setState(() {
              // 전체 선택 상태 토글
              categoryAllSelected[category] =
                  !(categoryAllSelected[category] ?? false);

              // 해당 카테고리의 모든 아이템 선택/해제
              for (var item
                  in items.where((item) => item.category == category)) {
                item.isSelected = categoryAllSelected[category]!;
              }
            });
          },
          child: Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              border: Border.all(
                color: CustomColorsExtension.mainColor01,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(4),
              color: categoryAllSelected[category] == true
                  ? CustomColorsExtension.mainColor01
                  : Colors.white,
            ),
            child: categoryAllSelected[category] == true
                ? Icon(
                    Icons.check,
                    size: 16.w,
                    color: Colors.white,
                  )
                : null,
          ),
        ),
      ],
    );
  }

  List<Widget> buildSections() {
    // 선택된 카테고리만 보여주도록 수정
    final filteredItems =
        items.where((item) => item.category == selectedCategory);
    List<Widget> sections = [];

    sections.addAll([
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            selectedCategory,
            style: TextStyle(
              fontSize: 18.sp,
              color: CustomColorsExtension.mainColor01,
              fontWeight: FontWeight.w600,
            ),
          ),
          _buildAllCheckbox(selectedCategory),
        ],
      ),
      SizedBox(height: 16.h),
      ...filteredItems
          .map((item) => Column(
                children: [
                  SelectionItemWidget(
                    item: item,
                    onTap: () {
                      setState(() {
                        item.isSelected = !item.isSelected;

                        // 아이템 선택 상태가 변경될 때 전체 선택 상태 업데이트
                        bool allSelected = items
                            .where((i) => i.category == selectedCategory)
                            .every((i) => i.isSelected);
                        categoryAllSelected[selectedCategory] = allSelected;
                      });
                    },
                  ),
                  SizedBox(height: 10.h),
                ],
              ))
          .toList(),
      SizedBox(height: 20.h),
    ]);

    return sections;
  }

  Widget _buildCategoryFilter() {
    final categories = items.map((item) => item.category).toSet().toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (String category in categories)
            Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = category;
                  });
                },
                child: Container(
                  width: 81.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: selectedCategory == category
                          ? CustomColorsExtension.mainColor01
                          : CustomColorsExtension.line_gray,
                    ),
                    color: selectedCategory == category
                        ? CustomColorsExtension.mainColor01
                        : Colors.white,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: selectedCategory == category
                          ? Colors.white
                          : CustomColorsExtension.mainColor01,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
