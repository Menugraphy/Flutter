// food_significant.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:menugraphy/Data/FoodSignificantData.dart';
import 'package:menugraphy/Constant/CustomColors.dart';
import 'package:menugraphy/Model/SelectionItem.dart';
import 'package:menugraphy/View/FoodPreference.dart';
import 'package:menugraphy/View/Component/SelectionItemWidget.dart';

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
    items = FoodSignificantData.items;
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
                         Center(  // 제목을 Center 위젯으로 감싸기
                          child: Column(
                            children: [
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
                            ],
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
                        builder: (context) => FoodPreference(), 
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
                    SelectionItemWidget(
                      item: item,
                      onTap: () {
                        setState(() {
                          for (var i in items.where((i) => i.category == item.category)) {
                            i.isSelected = false;
                          }
                          item.isSelected = !item.isSelected;
                        });
                      },
                    ),
                    SizedBox(height: 10.h),
                  ],
                ))
            .toList(),
        SizedBox(height: 20.h),
      ]);
    }

    return sections;
  }
}