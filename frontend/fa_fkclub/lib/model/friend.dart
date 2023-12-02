///  Modelo base para carregar as informações do amigo
class Friend {
  final int uid;
  final String firstName;
  final String lastName;
  final int friendLevel;

  Friend({required this.uid, required this.firstName, required this.lastName, required this.friendLevel});

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      uid: json['uid'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      friendLevel: json['level'] ?? '',
    );
  }
}