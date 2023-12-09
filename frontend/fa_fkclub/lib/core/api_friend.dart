import 'dart:convert';
import 'package:fa_fkclub/config/app_config.dart';
import 'package:fa_fkclub/core/secure_storage.dart';
import 'package:fa_fkclub/model/friend.dart';
import 'package:http/http.dart' as http;

class ApiFriend {

  // listar amizades
  Future<List<Friend>> fetchFriends() async {
  final secureStorage = SecureStorage();
  final csrfToken = await secureStorage.getCsrfToken() ?? '';
  final response = await http.get(
    Uri.parse(AppConfig.listFriendship),
      headers: {
        'Content-Type': 'application/json',
        'token': csrfToken, // Adicionando o token CSRF ao header
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> friendsJson = json.decode(response.body);
      return friendsJson.map((json) => Friend.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load friends');
    }
  }


  // Aceitar amizade
  Future<dynamic> acceptFriend(int friendshipId) async {
    final secureStorage = SecureStorage();
    final csrfToken = await secureStorage.getCsrfToken() ?? '';   
    final response = await http.post(
      Uri.parse(AppConfig.acceptFriendship),
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken,
      },
      body: json.encode({'friendship_id': friendshipId}),
    );  
          
    if (response.statusCode == 200) {
        // Deserializar a resposta e retornar um objeto Friend
        return Friend.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to accept friendship');
    }
  }

  // Rejeitar amizade
  Future<dynamic> rejectFriend(int friendshipId) async {
    final secureStorage = SecureStorage();
    final csrfToken = await secureStorage.getCsrfToken() ?? '';   
    final response = await http.post(
      Uri.parse(AppConfig.rejectFriendship),
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken,
      },
      body: json.encode({'friendship_id': friendshipId}),
    );  
          
    if (response.statusCode == 200) {
        // Deserializar a resposta e retornar um objeto Friend
        return Friend.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to accept friendship');
    }
  }  

}
