import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fa_fkclub/config/app_config.dart';
import 'package:fa_fkclub/model/profile.dart';
import 'secure_storage.dart';

class ProfileManager {
  final SecureStorage secureStorage = SecureStorage();
  final Dio _dio = Dio(); // Certifique-se de configurar o Dio adequadamente

  Future<Profile?> fetchAndSaveUserProfile(String accessToken, int userId, String userUuid) async {
    String profileUrl = '${AppConfig.profileURL}/$userUuid';
    try {
      Response response = await _dio.get(
        profileUrl,
        queryParameters: {'token': accessToken},
      );

      if (response.statusCode == 200) {
        Profile userProfile = Profile.fromJson(response.data);
        await secureStorage.saveProfile(userProfile);
        return userProfile;
      }
      return null;
    } on DioError {
      // Trate o erro conforme necessário
      return null;
    }
  }

  Future<Profile?> getProfile() async {
    String? profileJson = await secureStorage.read(key: 'userProfile');
    if (profileJson != null) {
      return Profile.fromJson(json.decode(profileJson));
    }
    return null;
  }
}
