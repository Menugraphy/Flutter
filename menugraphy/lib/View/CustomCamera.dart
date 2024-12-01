import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:menugraphy/Constant/CustomColors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:menugraphy/Network/APIProvider.dart';
import 'package:menugraphy/Network/AuthService.dart';
import 'CameraPreview.dart';
import 'MyPage.dart';

class CustomCameraView extends StatefulWidget {
  const CustomCameraView({Key? key}) : super(key: key);

  @override
  State<CustomCameraView> createState() => _CustomCameraViewState();
}

class _CustomCameraViewState extends State<CustomCameraView> {
  CameraController? _controller;
  List<CameraDescription> cameras = [];
  bool _isInitialized = false;
  bool _isProcessing = false;
  final ImagePicker _picker = ImagePicker();
  final ApiProvider _apiProvider = ApiProvider();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _setApiToken();
  }

  void _setApiToken() {
    final token = _authService.accessToken;
    print('Current access token: $token'); // 토큰 확인
    if (token != null) {
      _apiProvider.setToken(token);
    } else {
      print('Warning: Access token is null');
    }
  }

  Future<void> _initializeCamera() async {
    try {
      print('Initializing camera...');
      cameras = await availableCameras();
      _controller = CameraController(
        cameras[0],
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        print('Camera initialized successfully');
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _processImage(XFile image) async {
    print('Starting image processing...');
    print('Image path: ${image.path}');

    if (_authService.accessToken == null) {
      print('Error: No access token available');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다.')),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      print('Sending image to server...');
      final response = await _apiProvider.recognizeMenuImage(File(image.path));
      print('Server response: $response');
      
      if (mounted && response['status'] == 'success') {
        final processedImageUrl = response['data']['processedImage'];
        final imageId = response['data']['imageId'];
        print('Successfully processed image. URL: $processedImageUrl, ID: $imageId');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CameraPreviewView(
              image: image,
              processedImageUrl: processedImageUrl,
              imageId: imageId,
            ),
          ),
        );
      } else {
        print('Error: Server returned unsuccessful status');
        throw Exception('이미지 처리에 실패했습니다. Server response: $response');
      }
    } catch (e) {
      print('Error during image processing: $e');
      if (mounted) {
        String errorMessage = '이미지 처리 중 오류가 발생했습니다.';
        if (e is HttpException) {
          print('HTTP Exception details: ${e.message}');
          if (e.message.contains('40007')) {
            errorMessage = '인증 토큰이 올바르지 않습니다.';
          } else if (e.message.contains('40102')) {
            errorMessage = '로그인 후 진행해주세요.';
          } else if (e.message.contains('40401')) {
            errorMessage = '존재하지 않는 회원입니다.';
          }
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$errorMessage\nError details: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
      print('Image processing completed');
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized || _isProcessing) {
      print('Cannot take picture: controller not ready or processing');
      return;
    }

    try {
      print('Taking picture...');
      final XFile image = await _controller!.takePicture();
      print('Picture taken successfully: ${image.path}');
      await _processImage(image);
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  Future<void> _pickImage() async {
    if (_isProcessing) {
      print('Cannot pick image: currently processing');
      return;
    }
    
    try {
      print('Opening gallery...');
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        print('Image selected from gallery: ${image.path}');
        await _processImage(image);
      } else {
        print('No image selected from gallery');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _controller == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        await _controller?.dispose();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: CameraPreview(_controller!),
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
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
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
                        icon: Icon(Icons.person_outline, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (_isProcessing)
                const Positioned.fill(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Color(0xFF424242),
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: _isProcessing ? null : _pickImage,
                        child: Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: _isProcessing ? Colors.grey : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.photo_library, color: Colors.black),
                        ),
                      ),
                      GestureDetector(
                        onTap: _takePicture,
                        child: Container(
                          width: 70.w,
                          height: 70.w,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _isProcessing ? Colors.grey : Colors.white,
                              width: 3,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.w),
                            child: Container(
                              decoration: BoxDecoration(
                                color: _isProcessing ? Colors.grey : Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 40.w),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}