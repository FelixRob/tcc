import 'package:flutter/material.dart';
import 'package:fa_fkclub/config/colors.dart';
import 'package:fa_fkclub/core/api_friend.dart';
import 'package:fa_fkclub/model/friend.dart';

class FriendsListScreen extends StatelessWidget {
  final String accesstoken;
  FriendsListScreen(
      {Key? key,
      required this.accesstoken})
      : super(key: key);


  final ApiFriend _apiFriend = ApiFriend();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBg,
      appBar: AppBar(
        title: const Text('Friends List'),
      ),
      body: FutureBuilder<List<Friend>>(
        future: _apiFriend.fetchFriends(accesstoken),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${snapshot.data![index].firstName} ${snapshot.data![index].lastName}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
