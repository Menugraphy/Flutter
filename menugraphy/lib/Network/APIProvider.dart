import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:menugraphy/Network/AuthService.dart';

class ApiProvider {
  static const String baseUrl = 'http://43.200.81.133:8080';
  static const String apiVersion = '/api/v1';

  // API Endpoints
  static const String loginEndpoint = '$apiVersion/member/auth/login';
  static const String foodTypesEndpoint = '$apiVersion/food/types';
  static const String avoidedTypesEndpoint = '$apiVersion/member/avoided-types';
  static const String menuImageEndpoint = '$apiVersion/menu/image';
  static const String menuImageByIdEndpoint = '$apiVersion/menu/image'; // /{imageId}
  static const String menuByIdEndpoint = '$apiVersion/menu'; // /{menuId}
  static const String memberLikesByFoodEndpoint = '$apiVersion/member/likes'; // /{foodId}
  static const String menuOrderEndpoint = '$apiVersion/menu/order';
  static const String orderHistoriesEndpoint = '$apiVersion/menu/order-histories';
  static const String memberLikesEndpoint = '$apiVersion/member/likes';
  static const String menuBoardByIdEndpoint = '$apiVersion/menu/menu-board'; // /{menuBoardId}

  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
  };

  // 토큰 설정
   void setToken(String token) {
    _headers['Authorization'] = 'Bearer $token';
    print('Token set in ApiProvider: ${_headers['Authorization']}');
  }

    final AuthService _authService = AuthService();


  // 로그인
  String? _accessToken;
  
  String? get accessToken => _accessToken;

  // 카테고리별 음식 종류 조회
  Future<Map<String, dynamic>> getFoodTypes() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$foodTypesEndpoint'),
        headers: _headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // 기피 음식 설정
  Future<Map<String, dynamic>> setAvoidedTypes(List<String> avoidedTypes) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$avoidedTypesEndpoint'),
        headers: _headers,
        body: jsonEncode({'avoidedTypes': avoidedTypes}),
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // 사진 내 글씨 인식
  Future<Map<String, dynamic>> recognizeMenuImage(File image) async {
    try {
      print('Creating MultipartRequest...');
      print('URL: $baseUrl$menuImageEndpoint');
      print('Headers: $_headers');
      
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl$menuImageEndpoint'))
        ..headers.addAll({
          'Authorization': _headers['Authorization'] ?? '',
        });
      
      print('Adding image file...');
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      
      print('Sending request...');
      var streamedResponse = await request.send();
      print('Response status code: ${streamedResponse.statusCode}');
      
      var response = await http.Response.fromStream(streamedResponse);
      print('Response body: ${response.body}');
      
      if (response.statusCode == 500) {
        final errorBody = jsonDecode(response.body);
        if (errorBody['status'] == '50003') {
          throw HttpException('이미지 처리 중 오류가 발생했습니다. 다시 시도해주세요.');
        }
        throw HttpException('서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
      }
      
      return _handleResponse(response);
    } catch (e) {
      print('Error in recognizeMenuImage: $e');
      throw _handleError(e);
    }
  }


  // 메뉴판 재구성
 Future<Map<String, dynamic>> getMenuItems(int imageId) async {
  try {
    print('Fetching menu items for imageId: $imageId');
    
    // AuthService의 accessToken을 직접 사용
    final token = _authService.accessToken;
    if (token == null) {
      throw HttpException('로그인이 필요합니다.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl$menuImageEndpoint/$imageId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',  // AuthService의 토큰 사용
      },
    );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 401) {
        throw HttpException('로그인이 필요합니다.');
      } else if (response.statusCode == 404) {
        final errorBody = jsonDecode(response.body);
        if (errorBody['status'] == '40402') {
          throw HttpException('존재하지 않는 메뉴판입니다.');
        } else if (errorBody['status'] == '40403') {
          throw HttpException('존재하지 않는 음식명입니다.');
        } else {
          throw HttpException('존재하지 않는 회원입니다.');
        }
      } else if (response.statusCode == 500) {
        throw HttpException('서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
      }
      
      return _handleResponse(response);
    } catch (e) {
      print('Error in getMenuItems: $e');
      throw _handleError(e);
    }
  }


  // 메뉴 상세정보 조회
Future<Map<String, dynamic>> getFoodDetail(int menuId) async {
  try {
    print('Fetching food detail for menuId: $menuId');
    
    final token = _authService.accessToken;
    if (token == null) {
      throw HttpException('로그인이 필요합니다.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl$menuByIdEndpoint/$menuId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 400) {
      final errorBody = jsonDecode(response.body);
      if (errorBody['status'] == '40008') {
        throw HttpException('인증 토큰이 올바르지 않습니다.');
      } else if (errorBody['status'] == '40010') {
        throw HttpException('로그인이 필요합니다.');
      }
    } else if (response.statusCode == 401) {
      throw HttpException('로그인이 필요합니다.');
    } else if (response.statusCode == 404) {
      final errorBody = jsonDecode(response.body);
      if (errorBody['status'] == '40404') {
        throw HttpException('존재하지 않는 음식 ID입니다.');
      } else {
        throw HttpException('존재하지 않는 회원입니다.');
      }
    }

    return _handleResponse(response);
  } catch (e) {
    print('Error in getFoodDetail: $e');
    throw _handleError(e);
  }
}

 // 좋아요 추가
Future<Map<String, dynamic>> addLike(int foodId) async {
  try {
    final token = _authService.accessToken;
    if (token == null) {
      throw HttpException('로그인이 필요합니다.');
    }

    print('Adding like for foodId: $foodId');
    final response = await http.post(
      Uri.parse('$baseUrl$memberLikesByFoodEndpoint/$foodId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 400) {
      final errorBody = jsonDecode(response.body);
      if (errorBody['status'] == '40008') {
        throw HttpException('요청한 토큰이 Bearer 토큰이 아닙니다.');
      } else if (errorBody['status'] == '40010') {
        throw HttpException('Principal 객체가 없습니다. (null)');
      } else if (errorBody['status'] == '40013') {
        throw HttpException('이미 좋아요를 누른 음식입니다.');
      }
    } else if (response.statusCode == 401) {
      throw HttpException('로그인 후 진행해주세요.');
    } else if (response.statusCode == 404) {
      final errorBody = jsonDecode(response.body);
      if (errorBody['status'] == '40401') {
        throw HttpException('존재하지 않는 회원입니다.');
      } else if (errorBody['status'] == '40404') {
        throw HttpException('존재하지 않는 음식 ID입니다.');
      }
    }

    return _handleResponse(response);
  } catch (e) {
    print('Error in addLike: $e');
    throw _handleError(e);
  }
}

// 좋아요 삭제
Future<Map<String, dynamic>> deleteLike(int foodId) async {
  try {
    final token = _authService.accessToken;
    if (token == null) {
      throw HttpException('로그인이 필요합니다.');
    }

    print('Deleting like for foodId: $foodId');
    final response = await http.delete(
      Uri.parse('$baseUrl$memberLikesByFoodEndpoint/$foodId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 400) {
      final errorBody = jsonDecode(response.body);
      if (errorBody['status'] == '40008') {
        throw HttpException('요청한 토큰이 Bearer 토큰이 아닙니다.');
      } else if (errorBody['status'] == '40010') {
        throw HttpException('Principal 객체가 없습니다. (null)');
      }
    } else if (response.statusCode == 401) {
      throw HttpException('로그인 후 진행해주세요.');
    } else if (response.statusCode == 404) {
      final errorBody = jsonDecode(response.body);
      if (errorBody['status'] == '40401') {
        throw HttpException('존재하지 않는 회원입니다.');
      } else if (errorBody['status'] == '40404') {
        throw HttpException('존재하지 않는 음식 ID입니다.');
      }
    }

    return _handleResponse(response);
  } catch (e) {
    print('Error in deleteLike: $e');
    throw _handleError(e);
  }
}

  // 주문 스크립트 생성
Future<Map<String, dynamic>> createOrderScript(int menuBoardId, List<Map<String, dynamic>> menuOrderList) async {
    try {
      print('Creating order script with menuBoardId: $menuBoardId');
      
      final token = _authService.accessToken;
      if (token == null) {
        throw HttpException('로그인이 필요합니다.');
      }

      final response = await http.post(
        Uri.parse('$baseUrl$menuOrderEndpoint'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',  // UTF-8 인코딩 명시
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'menuBoardId': menuBoardId,
          'menuOrderList': menuOrderList,
        }),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      // UTF-8로 디코딩
      final decodedBody = utf8.decode(response.bodyBytes);
      return jsonDecode(decodedBody);
    } catch (e) {
      print('Error in createOrderScript: $e');
      throw _handleError(e);
    }
  }

  // 주문 히스토리 조회
Future<Map<String, dynamic>> getOrderHistories() async {
  try {
    final token = _authService.accessToken;
    if (token == null) {
      throw HttpException('로그인이 필요합니다.');
    }

    final response = await http.get(
      Uri.parse('$baseUrl$orderHistoriesEndpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',  // 토큰 추가
      },
    );
    return _handleResponse(response);
  } catch (e) {
    throw _handleError(e);
  }
}

  // 좋아요한 음식 목록 조회
  Future<Map<String, dynamic>> getLikedFoods() async {
  try {
    final token = _authService.accessToken;
    if (token == null) {
      throw HttpException('로그인이 필요합니다.');
    }

    print('Getting liked foods list');
    final response = await http.get(
      Uri.parse('$baseUrl$memberLikesEndpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 400) {
      final errorBody = jsonDecode(response.body);
      if (errorBody['status'] == '40008') {
        throw HttpException('요청한 토큰이 Bearer 토큰이 아닙니다.');
      } else if (errorBody['status'] == '40010') {
        throw HttpException('Principal 객체가 없습니다. (null)');
      }
    } else if (response.statusCode == 401) {
      throw HttpException('로그인 후 진행해주세요.');
    } else if (response.statusCode == 404) {
      final errorBody = jsonDecode(response.body);
      if (errorBody['status'] == '40401' || errorBody['status'] == '40404') {
        throw HttpException('존재하지 않는 회원입니다.');
      } else if (errorBody['status'] == '40406') {
        throw HttpException('존재하지 않는 타입입니다.');
      }
    }

    return _handleResponse(response);
  } catch (e) {
    print('Error in getLikedFoods: $e');
    throw _handleError(e);
  }
}

  // 메뉴판 조회
  Future<Map<String, dynamic>> getMenuBoard(String menuBoardId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$menuBoardByIdEndpoint/$menuBoardId'),
        headers: _headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Response 처리
 Map<String, dynamic> _handleResponse(http.Response response) {
    print('Handling response with status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // UTF-8로 디코딩
      final decodedBody = utf8.decode(response.bodyBytes);
      return jsonDecode(decodedBody);
    } else {
      throw HttpException(
        'Request failed with status: ${response.statusCode}.\nResponse: ${response.body}',
      );
    }
  }

  Exception _handleError(dynamic error) {
    print('Handling error: $error');
    if (error is SocketException) {
      return Exception('네트워크 연결을 확인해주세요.');
    } else if (error is HttpException) {
      return error;
    } else if (error is FormatException) {
      return Exception('잘못된 데이터 형식입니다.');
    }
    return Exception('알 수 없는 오류가 발생했습니다: $error');
  }
}