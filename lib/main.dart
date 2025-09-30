import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:litverse/features/view/AuthPage/Authcontroller/auth_Controller.dart';
import 'routes/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AuthBinding(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        indicatorColor: Colors.black,
        appBarTheme: AppBarTheme(backgroundColor: Color(0xffF4E6D3)),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color(0xffF4E6D3),
        ),
        scaffoldBackgroundColor: Color(0xffF4E6D3),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xffF25C2B)),
        ),
      ),
      initialRoute: AppRoutes.login,
      getPages: AppPages.pages,
    );
  }
}

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
  }
}
