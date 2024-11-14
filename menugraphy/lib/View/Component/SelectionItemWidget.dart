// selection_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:menugraphy/Model/SelectionItem.dart';
import 'package:menugraphy/Constant/CustomColors.dart';

class SelectionItemWidget extends StatelessWidget {
  final SelectionItemModel item;
  final VoidCallback onTap;

  const SelectionItemWidget({
    Key? key,
    required this.item,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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