import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:menugraphy/Constant/CustomColors.dart';
import 'package:menugraphy/Model/FoodDetail.dart';
import 'package:menugraphy/Network/APIProvider.dart';

class MenuDescription extends StatefulWidget {
  final int menuId;

  const MenuDescription({
    Key? key,
    required this.menuId,
  }) : super(key: key);

  @override
  _MenuDescriptionState createState() => _MenuDescriptionState();
}

class _MenuDescriptionState extends State<MenuDescription> {
  final ApiProvider _apiProvider = ApiProvider();
  bool _isLoading = true;
  FoodDetail? _foodDetail;

  @override
  void initState() {
    super.initState();
    _fetchFoodDetail();
  }

  Future<void> _fetchFoodDetail() async {
    try {
      final response = await _apiProvider.getFoodDetail(widget.menuId);
      if (response['status'] == 'success' && mounted) {
        setState(() {
          _foodDetail = FoodDetail.fromJson(response['data']);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('메뉴 정보를 불러오는데 실패했습니다.')),
        );
      }
    }
  }

Future<void> _toggleLike() async {
  if (_foodDetail == null) return;

  try {
    if (_foodDetail!.isLiked) {
      // 이미 좋아요가 되어있으면 삭제
      final response = await _apiProvider.deleteLike(_foodDetail!.id);
      if (response['status'] == 'success' && mounted) {
        setState(() {
          _foodDetail = _foodDetail!.copyWith(isLiked: false);
        });
      }
    } else {
      // 좋아요가 안되어있으면 추가
      final response = await _apiProvider.addLike(_foodDetail!.id);
      if (response['status'] == 'success' && mounted) {
        setState(() {
          _foodDetail = _foodDetail!.copyWith(isLiked: true);
        });
      }
    }
  } catch (e) {
    if (mounted) {
      // 에러 메시지가 "이미 좋아요를 누른 음식입니다."인 경우 좋아요 상태를 true로 업데이트
      if (e.toString().contains('이미 좋아요를 누른 음식입니다.')) {
        setState(() {
          _foodDetail = _foodDetail!.copyWith(isLiked: true);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
          ),
        );
      }
    }
  }
}

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_foodDetail == null) {
      return Scaffold(
        body: Center(child: Text('메뉴 정보를 불러올 수 없습니다.')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top),
                IconButton(
                  icon: Icon(Icons.arrow_back_ios,
                      color: CustomColorsExtension.mainColor02),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(height: 20.h),
                Container(
                  height: 240.h,
                  width: double.infinity,
                  child: Image.network(
                    _foodDetail!.image,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(Icons.error_outline, size: 48.sp),
                      );
                    },
                  ),
                ),
                SizedBox(height: 30.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 0,
                          runSpacing: 8.h,
                          children: _foodDetail!.foodTypeList.map((type) {
                            return Container(
                              margin: EdgeInsets.only(right: 8.w),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: CustomColorsExtension.mainColor02,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                type.typeName,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _foodDetail!.isLiked
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: CustomColorsExtension.mainColor01,
                          size: 30.sp,
                        ),
                        onPressed: _toggleLike,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      Text(
                        _foodDetail!.name,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Introduction',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: CustomColorsExtension.mainColor01,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        _foodDetail!.description,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                      if (_foodDetail!.similarFoodList.isNotEmpty) ...[
                        SizedBox(height: 24.h),
                        Text(
                          'Similar Food',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: CustomColorsExtension.mainColor01,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        SizedBox(
                          height: 160.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _foodDetail!.similarFoodList.length,
                            itemBuilder: (context, index) {
                              final similarFood =
                                  _foodDetail!.similarFoodList[index];
                              return Container(
                                width: 120.w,
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      child: Image.network(
                                        similarFood.image,
                                        height: 100.h,
                                        width: 100.w,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            height: 100.h,
                                            width: 100.w,
                                            color: Colors.grey[300],
                                            child: Icon(Icons.restaurant_menu),
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Expanded(
                                      child: Text(
                                        similarFood.name,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
