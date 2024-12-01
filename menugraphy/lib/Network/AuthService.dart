import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId: '599087168655-fs4hnvg8rctvihdhce60grofkeqtvvch.apps.googleusercontent.com', 
  );
  
  late final SharedPreferences _prefs;
  
  static const String baseUrl = 'http://43.200.81.133:8080';
  static const String loginEndpoint = '/api/v1/member/auth/login';

  String? _accessToken;
  String? get accessToken => _accessToken;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _accessToken = _prefs.getString('access_token');
  }

  Future<void> _saveToken(String token) async {
    await _prefs.setString('access_token', token);
    _accessToken = token;
  }

  Future<bool> signInWithGoogle() async {
    try {
      print('1. Starting Google Sign In process');
      
      await _googleSignIn.signOut();
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('2. Google Sign In cancelled by user');
        return false;
      }
      print('2. Google Sign In successful: ${googleUser.email}');

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      print('3. Full ID Token: ${googleAuth.idToken}');
      print('3. Access Token available: ${googleAuth.accessToken != null}');
      
      final String? idToken = googleAuth.idToken;
      if (idToken == null) {
        print('3. Failed to get ID Token');
        return false;
      }

      print('4. Sending login request to server');
      final response = await http.post(
        Uri.parse('$baseUrl$loginEndpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'socialType': 'GOOGLE',
          'idToken': idToken,
        }),
      );

      print('5. Server response status code: ${response.statusCode}');
      print('5. Server response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final accessToken = data['data']['accessToken'];
        await _saveToken(accessToken);
        print('6. Login successful, token saved');
        return true;
      }

      if (response.statusCode == 400) {
        final error = jsonDecode(response.body);
        throw Exception(error['message']);
      }

      return false;
    } catch (e) {
      print('Error during login process: $e');
      rethrow;
    }
  }
}