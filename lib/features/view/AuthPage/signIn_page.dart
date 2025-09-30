import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:litverse/features/view/AuthPage/Authcontroller/auth_Controller.dart';
import 'package:litverse/features/view/AuthPage/components/CstmLoginBtn.dart';
import 'package:litverse/features/view/AuthPage/components/CstmSignUpBtns.dart';
import 'package:litverse/features/view/AuthPage/components/CstmTextField.dart';
import 'package:litverse/routes/routes.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();
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
                    "Login With",
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
                  SizedBox(height: 20),
                  Cstmsignupbtn(
                    img: Image.asset("assets/icons/googlelogo.png", height: 30),
                    ontap: () {},
                    text: "Continue With Google",
                  ),
                  SizedBox(height: 20),
                  Cstmsignupbtn(
                    img: Image.asset(
                      "assets/icons/facebooklogo.png",
                      height: 30,
                    ),
                    ontap: () {},
                    text: "Continue With Facebook",
                  ),
                  SizedBox(height: 20),
                  Cstmsignupbtn(
                    img: Image.asset("assets/icons/applelogo.png", height: 30),
                    ontap: () {},
                    text: "Continue With Apple",
                  ),
                  SizedBox(height: 20),
                  signUpDivider(),

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
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          "Recovery Password",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                            fontFamily: 'IBMPlexSansCondensed',
                            color: Colors.black.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Cstmloginbtn(
                    text: "Login",
                    ontap: () {
                      authController.login(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );
                    },
                  ),
                  Cstmloginbtn(
                    text: "Don't Have an Account? SignUp",
                    ontap: () {
                      Get.toNamed(AppRoutes.signup);
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
              'or Login with',
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
