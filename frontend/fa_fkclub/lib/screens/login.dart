import 'package:fa_fkclub/core/secure_storage.dart';
import 'package:fa_fkclub/screens/forgot.dart';
import 'package:flutter/material.dart';
import 'package:fa_fkclub/core/api_client.dart';
import 'package:fa_fkclub/screens/home.dart';
import 'package:fa_fkclub/core/validator.dart';
import 'package:fa_fkclub/config/colors.dart';
import 'package:fa_fkclub/screens/register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiClient _apiClient = ApiClient();
  final secureStorage = SecureStorage();
  
  bool _showPassword = false;

  Future<void> login() async {
    //if (_formKey.currentState!.validate()) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Processing Data'),
      backgroundColor: Colors.green.shade300,
    ));

    dynamic res = await _apiClient.login(
      emailController.text,
      passwordController.text,
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (res['csrf_token'] != null) {
      String accessToken = res['csrf_token'];
      int userId = int.parse(res['current_user']['uid']);
      String userFirstName = res['first_name'];
      List<dynamic> userRoles = res["roles"];
      String userUUID = res['uuid'];

      String okMessage = 'Welcome $userFirstName'; // message for login successful

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(okMessage),
        backgroundColor: AppColors.messageOK,
      ));

      // Salvar dados no SecureStorage
      await secureStorage.setUserId(userId as String);
      await secureStorage.setUuid(userUUID);
      await secureStorage.setCsrfToken(accessToken);

      // navegar para home
      if (mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                    accesstoken: accessToken,
                    userId: userId,
                    userUuid: userUUID)));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${res['message']}'),
        backgroundColor: Colors.red.shade300,
      ));
    }
    //}
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: AppColors.mainBg,
        body: Form(
          key: _formKey,
          child: Stack(children: [
            SizedBox(
              width: size.width,
              height: size.height,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: size.width * 0.85,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: BoxDecoration(
                    color: AppColors.loginScreen,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.35),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 5), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // SizedBox(height: size.height * 0.08),
                          const Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: AppColors.txtTitle,
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.06),
                          TextFormField(
                            controller: emailController,
                            //validator: (value) {
                            //  return Validator.validateEmail(value ?? "");
                            //},
                            decoration: InputDecoration(
                              hintText: "Email",
                              isDense: true,
                              filled: true,
                              fillColor: AppColors.fieldBg,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.03),
                          TextFormField(
                            obscureText: _showPassword,
                            controller: passwordController,
                            validator: (value) {
                              return Validator.validatePassword(value ?? "");
                            },
                            decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(
                                      () => _showPassword = !_showPassword);
                                },
                                child: Icon(
                                  _showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                              ),
                              hintText: "Password",
                              isDense: true,
                              filled: true,
                              fillColor: AppColors.fieldBg,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.04),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: login,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.mainButtons,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15)),
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: AppColors.txtMainButton,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Register link
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                                onPressed: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RegisterScreen())),
                                child: const Text(
                                  'Register',
                                  style: TextStyle(color: AppColors.txtLink),
                                )),
                          ),
                          // Forgot Password
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                                onPressed: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgotScreen())),
                                child: const Text(
                                  'Forgot Password',
                                  style: TextStyle(color: AppColors.txtLink),
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ));
  }
}
