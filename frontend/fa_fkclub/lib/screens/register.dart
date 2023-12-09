import 'package:flutter/material.dart';
import 'package:fa_fkclub/core/api_client.dart';
import 'package:fa_fkclub/screens/login.dart';
import 'package:fa_fkclub/core/validator.dart';
import 'package:fa_fkclub/config/colors.dart';

class RegisterScreen extends StatefulWidget {
  static String id = "register_screen";
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiClient _apiClient = ApiClient();
  bool _showPassword = false;

  Future<void> registerUsers() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Processing Data'),
        backgroundColor: AppColors.messageOK,
      ));

      Map<String, dynamic> userData = {
        "Email": [
          {
            "Type": "Primary",
            "Value": emailController.text,
          }
        ],
        "Password": passwordController.text,
        "FirstName": firstNameController.text,
        // Serao configuraveis
        // A definir "LastName": "Test",
        // A definir "BirthDate": "10-12-1985",
        // A definir "Gender": "M",
      };

      dynamic res = await _apiClient.registerUser(userData);

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (res['ErrorCode'] == null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${res['Message']}'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.mainBg,
      body: Form(
        key: _formKey,
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: size.width * 0.85,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: BoxDecoration(
                color: AppColors.loginScreen,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 5), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //   SizedBox(height: size.height * 0.08),
                    // Screen title
                    const Center(
                      child: Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: AppColors.txtTitle,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),

                    // first name input
                    TextFormField(
                      validator: (value) =>
                          Validator.validateName(value ?? ""),
                      controller: firstNameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.fieldBg,
                        hintText: "First Name",
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    //
                    // email input
                    TextFormField(
                      validator: (value) =>
                          Validator.validateEmail(value ?? ""),
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.fieldBg,
                        hintText: "Email",
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    //
                    // password input
                    TextFormField(
                      obscureText: _showPassword,
                      validator: (value) =>
                          Validator.validatePassword(value ?? ""),
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.fieldBg,
                        hintText: "Password",
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                          child: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.06),
                    //
                    // Register button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: registerUsers,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainButtons,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15)),
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            color: AppColors.txtMainButton,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    //
                    // Login link
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                          onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen())),
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
    );
  }
}
