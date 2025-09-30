
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:litverse/features/view/Model/bookModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class SavedBooksController extends GetxController {
  var isLoading = false.obs;
  var savedBooks = <BookModel>[].obs;
  var savedBookIds = <String>{}.obs; // Track which books are saved

  final String baseUrl = "http://192.168.100.8:3000/api/savedbooks";

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  /// Fetch all saved books
  Future<List<BookModel>?> fetchSavedBooks() async {
    try {
      isLoading(true);
      final token = await _getToken();

      if (token == null) {
        Get.snackbar("Error", "Please login to view saved books");
        return [];
      }

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        savedBooks.value =
            data.map((item) {
              final bookJson = item['book'] as Map<String, dynamic>;
              return BookModel.fromJson(bookJson);
            }).toList();

        // Update saved book IDs
        // ignore: invalid_use_of_protected_member
        savedBookIds.value =
            data.map<String>((item) => item['book']['_id'] as String).toSet();
        return savedBooks.toList();

      } else {
        Get.snackbar("Error", "Failed to load saved books");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load: $e");
    } finally {
      isLoading(false);
    }
    return null;
  }

  Future<BookModel?> fetchBookById(String bookId) async {
    try {
      final token = await _getToken();

      if (token == null) {
        Get.snackbar("Error", "Please login to continue");
        return null;
      }

      final response = await http.get(
        Uri.parse("http://192.168.100.8:3000/api/books/$bookId"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return BookModel.fromJson(data);
      } else {
        Get.snackbar("Error", "Failed to load book details");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load book: $e");
      
    }
    return null;
  }

  /// Save a book
  Future<bool> saveBook(String bookId) async {
    try {
      final token = await _getToken();

      if (token == null) {
        Get.snackbar("Error", "Please login to save books");
        return false;
      }

      final response = await http.post(
        Uri.parse("$baseUrl/$bookId/save"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"bookId": bookId}),
      );

      if (response.statusCode == 201) {
        savedBookIds.add(bookId);
        Get.snackbar(
          "Success",
          "Book saved successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await fetchSavedBooks();
        return true;
      } else {
        final error = jsonDecode(response.body)['msg'];
        Get.snackbar("Error", error);
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to save: $e");
      return false;
    }
  }

  /// Unsave a book
  Future<bool> unsaveBook(String bookId) async {
    try {
      final token = await _getToken();

      if (token == null) {
        Get.snackbar("Error", "Please login");
        return false;
      }

      final response = await http.delete(
        Uri.parse("$baseUrl/$bookId/unsave"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        savedBookIds.remove(bookId);
        savedBooks.removeWhere((book) => book.id == bookId);
        Get.snackbar(
          "Success",
          "Book removed from saved list",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar("Error", "Failed to remove book");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to remove: $e");
      return false;
    }
  }

  Future<bool> rateBook(String bookId, int rating) async {
    try {
      final token = await _getToken();

      if (token == null) {
        Get.snackbar("Error", "Please login to rate books");
        return false;
      }

      final response = await http.put(
        Uri.parse(
          "$baseUrl/$bookId/rate",
        ), 
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"rating": rating}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Get.snackbar(
          "Success",
          "Book rated successfully (${data['avgRating'].toStringAsFixed(1)}/5)",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await fetchSavedBooks(); // refresh saved list
        return true;
      } else {
        final error = jsonDecode(response.body)['msg'] ?? "Unknown error";
        Get.snackbar("Error", error);
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to rate: $e");
      return false;
    }
  }

  /// Check if a book is saved
  bool isBookSaved(String bookId) {
    return savedBookIds.contains(bookId);
  }
}
