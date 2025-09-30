import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:litverse/features/view/AuthPage/components/CstmLoginBtn.dart';
import 'package:litverse/features/view/AuthPage/components/CstmSignUpBtns.dart';
import 'package:litverse/features/view/AuthPage/components/CstmTextField.dart';
import 'package:litverse/routes/routes.dart';

import 'Authcontroller/auth_Controller.dart';

class Signuppage extends StatefulWidget {
  const Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();
  String selectedRole = "user";

  bool ispasswordvisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Create an account",
                    style: TextStyle(
                      fontFamily: 'IBMPlexSansCondensed',
                      fontSize: 26,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "One subscription for Litverse,\n    Recognates, and Sparks",
                    style: TextStyle(
                      fontFamily: 'IBMPlexSansCondensed',
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 15),
                  Cstmsignupbtn(
                    img: Image.asset("assets/icons/googlelogo.png", height: 30),
                    ontap: () {},
                    text: "Continue With Google",
                  ),
                  SizedBox(height: 15),
                  Cstmsignupbtn(
                    img: Image.asset(
                      "assets/icons/facebooklogo.png",
                      height: 30,
                    ),
                    ontap: () {},
                    text: "Continue With Facebook",
                  ),
                  SizedBox(height: 15),
                  Cstmsignupbtn(
                    img: Image.asset("assets/icons/applelogo.png", height: 30),
                    ontap: () {},
                    text: "Continue With Apple",
                  ),
                  SizedBox(height: 15),
                  signUpDivider(),
                  CstmTextField(
                    controller: nameController,
                    text: "Name",
                    icon: null,
                  ),

                  CstmTextField(
                    controller: emailController,
                    text: "Email address",
                    icon: null,
                  ),
                  CstmTextField(
                    controller: passwordController,

                    obscureText: ispasswordvisible,

                    text: "Password",
                    icon: IconButton(
                      icon:
                          ispasswordvisible
                              ? Icon(Icons.visibility_off_outlined)
                              : Icon(Icons.remove_red_eye_outlined),
                      onPressed: () {
                        setState(() {
                          ispasswordvisible = !ispasswordvisible;
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChoiceChip(
                        label: Text("User"),
                        selected: selectedRole == "user",
                        onSelected: (_) {
                          setState(() {
                            selectedRole = "user";
                          });
                        },
                      ),
                      const SizedBox(width: 10),
                      ChoiceChip(
                        label: Text("Admin"),
                        selected: selectedRole == "admin",
                        onSelected: (_) {
                          setState(() {
                            selectedRole = "admin";
                          });
                        },
                      ),
                    ],
                  ),

                  Cstmloginbtn(
                    text: "Sign Up",
                    ontap: () {
                      final name = nameController.text.trim();
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();

                      if (name.isEmpty || email.isEmpty || password.isEmpty) {
                        Get.snackbar("Error", "All fields are required!");
                        return;
                      }

                      authController.signUp(
                        name,
                        email,
                        password,
                        selectedRole,
                      );
                    },
                  ),

                  Cstmloginbtn(
                    text: "Already Have an Account? Login",
                    ontap: () {
                      Get.toNamed(AppRoutes.login);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class signUpDivider extends StatelessWidget {
  const signUpDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Expanded(child: Divider(thickness: 1.5, color: Colors.black)),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'or sign Up with',
              style: TextStyle(
                fontFamily: 'IBMPlexSansCondensed',
                fontSize: 17,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Expanded(child: Divider(thickness: 1.5, color: Colors.black)),
        ],
      ),
    );
  }
}
