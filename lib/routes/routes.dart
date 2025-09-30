import 'package:get/get.dart';
import 'package:litverse/features/view/Admin_Pages/AdminBookPages/Add_Book_Page.dart';
import 'package:litverse/features/view/Admin_Pages/AdminPanel.dart';
import 'package:litverse/features/view/AuthPage/signIn_page.dart';
import 'package:litverse/features/view/AuthPage/signUpPage.dart';

import '../features/view/HomePage/bottomNav.dart';

class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String bottomnav = '/home';
  static const String adminDashBoard = '/adminDashBoard';
  static const String AddBookPage = '/addBookPage';

}

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.login, page: () => SignInPage()),
    GetPage(name: AppRoutes.signup, page: () => Signuppage()),
    GetPage(name: AppRoutes.bottomnav, page: () => Bottomnav()),
    GetPage(name: AppRoutes.adminDashBoard, page: () => AdminPanel()),
    GetPage(name: AppRoutes.AddBookPage, page: () => AddBookPage()),
  ];
}
