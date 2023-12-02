import 'package:dio/dio.dart';
import 'package:fa_fkclub/config/app_config.dart';

/// API Cliente exclusiva ao controle de usuários
class ApiClient {
  final Dio _dio = Dio();

  ///
  /// User register function
  ///
  Future<dynamic> registerUser(Map<String, dynamic>? data) async {
    try {
      Response response = await _dio.post(AppConfig.registerURL,
          data: data, queryParameters: {'apikey': AppConfig.apiKey});
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  ///
  /// User Login function
  ///
  Future<dynamic> login(String email, String password) async {
    try {
      Response response = await _dio.post(
        AppConfig.loginURL,
        data: {
          'name': email,
          'pass': password,
        },
        queryParameters: {'apikey': AppConfig.apiKey},
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> resetPassword(String email) async {
    try {
      Response response = await _dio.post(
        AppConfig.resetPasswordURL,
        data: {
          'name': email,
        },
        queryParameters: {'apikey': AppConfig.apiKey},
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }
  ///
  /// Get User Profile data
  Future<dynamic> getUserProfileData(
      String accessToken, int userId, String userUuid) async {
    String profileUrl = '${AppConfig.profileURL}/$userUuid';
    try {
      Response response = await _dio.get(
        profileUrl,
        queryParameters: {
          //'apikey': AppConfig.apiKey,
          'token': accessToken,
        },
        // options: Options(
        //   headers: {'Authorization': 'Bearer $accessToken'},
        // ),
      );

      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  ///
  /// User profile data
  ///
  Future<dynamic> updateUserProfile({
    required String accessToken,
    required Map<String, dynamic> data,
  }) async {
    try {
      Response response = await _dio.put(
        AppConfig.resetPasswordURL,
        data: data,
        queryParameters: {'apikey': AppConfig.apiKey},
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  ///
  /// User logout
  ///
  Future<dynamic> logout(String accessToken) async {
    try {
      Response response = await _dio.get(
        AppConfig.resetPasswordURL,
        queryParameters: {'apikey': AppConfig.apiKey},
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }
}
