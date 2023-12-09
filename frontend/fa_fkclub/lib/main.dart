import 'package:flutter/material.dart';
import 'config/app_config.dart';
import 'package:fa_fkclub/screens/login.dart';
import 'package:fa_fkclub/core/secure_storage.dart';
import 'package:fa_fkclub/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final secureStorage = SecureStorage();
    
    return MaterialApp(
      title: AppConfig.mainTittle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: Future.wait([
          secureStorage.getUserId(),
          secureStorage.getUuid(),
          secureStorage.getCsrfToken(),
        ]),
          builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // O token CSRF está carregado, agora você pode passá-lo para seus widgets
            final int userId = (snapshot.data?[0] ?? '') as int;
            final String uuid = snapshot.data?[1] ?? '';
            final String csrfToken = snapshot.data?[2] ?? '';
            if (csrfToken.isNotEmpty) {
              return HomeScreen(accesstoken: csrfToken, userId: userId, userUuid: uuid);
            } else {
              // Mostra um indicador de carregamento enquanto o token não é carregado
              return const LoginScreen();
            }
          }
          // Enquanto o token não é carregado, exibir carregamento
          return const CircularProgressIndicator();
        },
      )
    );
  }
}
