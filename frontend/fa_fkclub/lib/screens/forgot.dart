import 'package:fa_fkclub/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:fa_fkclub/core/api_client.dart';
import 'package:fa_fkclub/core/validator.dart';
import 'package:fa_fkclub/config/colors.dart';

class ForgotScreen extends StatefulWidget {
  static String id = "forgot_screen";
  const ForgotScreen({Key? key}) : super(key: key);

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiClient _apiClient = ApiClient();

  Future<void> resetPassword() async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Processing Data'),
      backgroundColor: Colors.green.shade300,
    ));

    dynamic res = await _apiClient.resetPassword(
      emailController.text
    );

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (res['response_token'] != null) {
      String okMessage = 'One temporary link was sent to your e-mail';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(okMessage),
        backgroundColor: AppColors.messageOK,
      ));

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const LoginScreen()));
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
                    color: AppColors.forgotScreen,
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
                              "Forgot Password",
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
                            validator: (value) {
                             return Validator.validateEmail(value ?? "");
                            },
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
                          // forgot button
                          SizedBox(height: size.height * 0.04),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: resetPassword,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.mainButtons,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15)),
                                  child: const Text(
                                    "Resset Password",
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
                          // Login link in case user decides to return
                          SizedBox(
                            width: double.infinity,
                            child: TextButton(
                                onPressed: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen())),
                                child: const Text(
                                  'Login',
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
