import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:menugraphy/Constant/CustomColors.dart';
import 'package:menugraphy/View/FoodSignificant.dart';
import 'package:menugraphy/Network/AuthService.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    await _authService.init();
  }

  Future<void> _handleGoogleLogin() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _authService.signInWithGoogle();
      print('Login success status: $success');
      
      if (success && mounted) {
        print('Navigating to FoodSignificant');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const FoodSignificant(),
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('로그인에 실패했습니다. 다시 시도해주세요.')),
        );
      }
    } catch (e) {
      print('Login error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류가 발생했습니다: $e')),
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
      body: ScreenUtilInit(
        designSize: const Size(390, 857),
        builder: (context, child) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16.0.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 180.h),
                  Image.asset(
                    'assets/images/logo.png',
                    width: 300.w,
                    height: 260.h,
                  ),
                  SizedBox(height: 180.h),
                  Container(
                    height: 60.h,
                    padding: EdgeInsets.symmetric(horizontal: 43.w),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleGoogleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                          side: BorderSide(
                            color: CustomColorsExtension.line_gray,
                            width: 1,
                          ),
                        ),
                        minimumSize: Size(double.infinity, 60.h),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              'Sign in with Google',
                              style: TextStyle(
                                fontFamily: 'AppleSDGothicNeoB00',
                                fontSize: 18.sp,
                                color: CustomColorsExtension.text_gray03,
                              ),
                            ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}