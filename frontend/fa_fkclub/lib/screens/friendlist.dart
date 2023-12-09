import 'package:fa_fkclub/core/secure_storage.dart';
import 'package:fa_fkclub/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:fa_fkclub/config/colors.dart';
import 'package:fa_fkclub/core/api_friend.dart';
import 'package:fa_fkclub/model/friend.dart';
import 'package:logger/logger.dart';


class FriendsListScreen extends StatefulWidget {
  const FriendsListScreen({super.key});

  @override
  _FriendsListScreenState createState() => _FriendsListScreenState();
}

class _FriendsListScreenState extends State<FriendsListScreen> {
  List<Friend> friendsList = [];
  final ApiFriend _apiFriend = ApiFriend();
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    _checkUserActive();
    //_loadFriends();
  }

  void _loadFriends() async {
    try {
      friendsList = await _apiFriend.fetchFriends();
      setState(() {}); // Atualiza a tela
    } catch (e) {
      logger.e('Erro carregando lista de amigos');
    }
  }

  void _checkUserActive() async {
    final secureStorage = SecureStorage();
    String? csrfToken = await secureStorage.getCsrfToken();
    if (mounted) {
      if (csrfToken == null || csrfToken.isEmpty) {
        // Não há usuário ativo, redirecionar para a tela de login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        _loadFriends();
      }
    }
  }

  void _acceptFriendship(int friendshipId) async {
    try {
      bool success = await _apiFriend.acceptFriend(friendshipId);
      if (success) {
        _loadFriends(); // Recarrega a lista de amigos após aceitar uma amizade
      }
    } catch (e) {
      logger.e('Erro ao aceitar amizade');
    }
  }

  void _rejectFriendship(int friendshipId) async {
    try {
      bool success = await _apiFriend.rejectFriend(friendshipId);
      if (success) {
        _loadFriends(); // Recarrega a lista de amigos após aceitar uma amizade
      }
    } catch (e) {
      logger.e('Erro ao rejeitar amizade');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBg,
      appBar: AppBar(
        title: const Text('Friends List'),
      ),
      body: FutureBuilder<List<Friend>>(
        future: _apiFriend.fetchFriends(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No friends found.'));  
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return _buildFriendItem(snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }

  // Função para construir cada item da lista
  Widget _buildFriendItem(Friend friend) {
    // Lógica para exibir botões/ícones com base no campo 'level'
    switch (friend.friendLevel) {
      case 0:
        return ListTile(
          title: Text('${friend.firstName} ${friend.lastName}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => _acceptFriendship(friend.uid),
                child: const Text('Accept'),
              ), 
              ElevatedButton(
                onPressed: () => _rejectFriendship(friend.uid),
                child: const Text('Reject'),
              ), 
            ],
          ),
        );
      case 1:
        return ListTile(
          title: Text('${friend.firstName} ${friend.lastName}'),
          trailing: const Icon(Icons.person),
        );
      case -1:
      default:
        return Container(); // Não mostrar nada para level -1
    }
  }
}


