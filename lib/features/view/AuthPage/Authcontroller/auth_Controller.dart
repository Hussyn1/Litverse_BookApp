// ignore_for_file: unused_local_variable
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:litverse/features/view/Model/user_model.dart';
import 'package:litverse/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = "http://192.168.100.8:3000/api/auth";

class AuthController extends GetxController {
  // ✅ Added GetxController extension
  var isLoading = false.obs;

  /// ✅ Save token in SharedPreferences with consistent key
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token); // ✅ Changed from "jwt" to "token"
    print("🔑 Token saved: $token");
  }

  /// ✅ Get token (used in BookController, etc.)
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token"); // ✅ Changed from "jwt" to "token"
  }

  /// ✅ Remove token on logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token"); // ✅ Changed from "jwt" to "token"
    Get.offAllNamed(AppRoutes.login); // back to login page
  }

  Future<void> signUp(
    String name,
    String email,
    String password,
    String role,
  ) async {
    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse("$baseUrl/signup"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "role": role,
        }),
      );

      print("📡 Status Code: ${response.statusCode}");
      print("📡 Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data["user"] != null && data["token"] != null) {
          User user = User.fromJson(data["user"]);
          String token = data["token"];
          await _saveToken(token);
          print("✅ Signed up as: ${user.name}, role: ${user.role}");

          Get.offAllNamed(
            user.role == "admin"
                ? AppRoutes.adminDashBoard
                : AppRoutes.bottomnav,
          );
        } else {
          Get.snackbar("Error", "Unexpected response: ${response.body}");
        }
      } else {
        final errorMsg = jsonDecode(response.body)["msg"] ?? "Sign up failed";
        Get.snackbar("Error", errorMsg);
      }
    } catch (e, stacktrace) {
      print("❌ ERROR: $e");
      print("STACKTRACE: $stacktrace");
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> login(String email, String password) async {
    isLoading(true);
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      print("📡 Status Code: ${response.statusCode}");
      print("📡 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        User user = User.fromJson(data["user"]);
        String token = data["token"];

        await _saveToken(token);
        print("🔑 Token saved successfully for user: ${user.name}");

        if (user.role.toLowerCase() == "admin") {
          Get.offAllNamed(AppRoutes.adminDashBoard);
        } else {
          Get.offAllNamed(AppRoutes.bottomnav);
        }
      } else {
        final errorMsg = jsonDecode(response.body)["msg"] ?? "Login failed";
        Get.snackbar("Error", errorMsg);
      }
    } catch (e) {
      print("❌ Login Error: $e");
      Get.snackbar("Error", "Login failed: $e");
    } finally {
      isLoading(false);
    }
  }
}
