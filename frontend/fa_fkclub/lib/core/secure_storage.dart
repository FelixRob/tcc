import 'dart:convert';

import 'package:fa_fkclub/model/profile.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
 final _storage = const FlutterSecureStorage();

  Future<void> setUserId(String userId) async {
    await _storage.write(key: 'userId', value: userId);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: 'userId');
  }

  Future<void> setUuid(String uuid) async {
    await _storage.write(key: 'uuid', value: uuid);
  }

  Future<String?> getUuid() async {
    return await _storage.read(key: 'uuid');
  }

  Future<void> setCsrfToken(String csrfToken) async {
    await _storage.write(key: 'csrfToken', value: csrfToken);
  }

  Future<String?> getCsrfToken() async {
    return await _storage.read(key: 'csrfToken');
  }

  Future<void> set(String csrfToken) async {
    await _storage.write(key: 'csrfToken', value: csrfToken);
  }

  Future<void> saveProfile(Profile profile) async {
    String profileJson = json.encode({
      'uid': profile.uid,
      'firstName': profile.firstName,
      'lastName': profile.lastName,
      'birthday': profile.birthday.toIso8601String(),
      'gender': profile.gender,
      'roles': profile.roles,
      'picture': profile.picture,
    });
    await _storage.write(key: 'userProfile', value: profileJson);
  }

  Future<Profile?> getProfile() async {
    String? profileJson = await _storage.read(key: 'userProfile');
    if (profileJson != null) {
      Map<String, dynamic> jsonMap = json.decode(profileJson);
      return Profile.fromJson(jsonMap);
    }
    return null;
  }

  Future<String?> read({required String key}) async {
    return await _storage.read(key: key);
  }

}