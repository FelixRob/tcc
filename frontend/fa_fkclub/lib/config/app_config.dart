class AppConfig {
  // Layout APP
  static const String appName = 'The Freedom Club';
  static const String mainTittle = 'The Freedom Club';
  static const String homeTittle = 'The Freedom Club';

  // API Calls
  static const String apiKey = 'some-key';
  static const String mainApiURL = 'https://beta1.soul.art.br';
  //static const String mainApiURL = 'http://beta.local.dev';

  static const String registerURL = '$mainApiURL/identity/v2/auth/register';
  static const String loginURL = '$mainApiURL/user/login?_format=json';
  static const String logoutURL = '$mainApiURL/user/logout?_format=json';
  static const String resetPasswordURL = '$mainApiURL/user/resetPassword?_format=json';
  static const String profileURL = '$mainApiURL/soulapi/user/user';
  static const String updateProfileURL = '$mainApiURL/soulapi/profile/update?_format=json';

  // Friendship
  static const String listFriendship = '$mainApiURL/friendship/list';
  static const String requestFriendship = '$mainApiURL/friendship/request';
  static const String acceptFriendship = '$mainApiURL/friendship/accept';
  static const String rejectFriendship = '$mainApiURL/friendship/reject';
  //static const String profileURL = '$mainApiURL/jsonapi/user/user?filter[uid]=';
}
