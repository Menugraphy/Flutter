import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:menugraphy/Constant/CustomColors.dart';
import 'package:menugraphy/View/MenuScreen.dart';

class CameraPreviewView extends StatefulWidget {
  final XFile image;
  final String? processedImageUrl;
  final int? imageId;

  const CameraPreviewView({
    Key? key,
    required this.image,
    this.processedImageUrl,
    this.imageId,
  }) : super(key: key);

  @override
  State<CameraPreviewView> createState() => _CameraPreviewViewState();
}

class _CameraPreviewViewState extends State<CameraPreviewView> {
  void _handleSubmit() {
    if (widget.imageId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미지 처리가 완료되지 않았습니다.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MenuScreen(imageId: widget.imageId!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Center(
                    child: Container(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: widget.processedImageUrl != null
                          ? Image.network(
                              widget.processedImageUrl!,
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                                  loadingProgress.expectedTotalBytes!
                                              : null,
                                        ),
                                        SizedBox(height: 16.h),
                                        Text(
                                          '잠시만 기다려주세요',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                print('Error loading processed image: $error');
                                print('Attempted URL: ${widget.processedImageUrl}');
                                return Center(
                                  child: Container(
                                    padding: EdgeInsets.all(16.w),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.error_outline, color: Colors.white, size: 48.sp),
                                        SizedBox(height: 16.h),
                                        Text(
                                          '이미지를 불러올 수 없습니다',
                                          style: TextStyle(color: Colors.white, fontSize: 16.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : Image.file(
                              File(widget.image.path),
                              fit: BoxFit.contain,
                            ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: CustomColorsExtension.navy,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Menugraphy',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.person_outline, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20.h,
              left: 16.w,
              right: 16.w,
              child: ElevatedButton(
                onPressed: widget.processedImageUrl == null ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColorsExtension.mainColor02,
                  minimumSize: Size(double.infinity, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}