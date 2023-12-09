class Profile {
  final int uid;
  final String firstName;
  final String lastName;
  final DateTime birthday;
  final String gender;
  final List<String> roles;
  final String picture;

  Profile({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.gender,
    required this.roles,
    required this.picture,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      uid: json['uid'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      birthday: DateTime.parse(json['birthday']),
      gender: json['gender'] ?? '',
      roles: List<String>.from(json['roles'] ?? []),
      picture: json['picture'] ?? '',
    );
  }
}
