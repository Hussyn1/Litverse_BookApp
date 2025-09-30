import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:litverse/features/view/Model/bookModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookController extends GetxController {
  var isLoading = false.obs;
  var books = <BookModel>[].obs;
  var recentActivities = <Map<String, dynamic>>[].obs;

  final String baseUrl = "http://192.168.100.8:3000/api/books";

  ///  Helper to get token from SharedPreferences with consistent key
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  /// Fetch all books
  Future<void> fetchBooks() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse("$baseUrl/getAllBooks"));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        books.value = data.map((e) => BookModel.fromJson(e)).toList();

        //  Debug: Print all book cover paths
        print("📚 Fetched ${books.length} books:");
        for (var book in books) {
          print("📖 ${book.title} - Cover: ${book.coverImage}");
        }
      } else {
        Get.snackbar("Error", "Failed to load books");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<bool> addBook({
    required String title,
    required String description,
    required String genre,
    required File coverImage,
    required File bookFile,
  }) async {
    isLoading(true);
    try {
      final token = await _getToken();

      if (token == null) {
        Get.snackbar("Error", "No token found. Please login again.");
        return false;
      }

      var request = http.MultipartRequest(
        "POST",
        Uri.parse("$baseUrl/createBook"),
      );
      request.headers["Authorization"] = "Bearer $token";
      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['genre'] = genre;

      request.files.add(
        await http.MultipartFile.fromPath("coverImage", coverImage.path),
      );
      request.files.add(
        await http.MultipartFile.fromPath("bookFile", bookFile.path),
      );

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Book uploaded successfully");

        // Add recent activity
        _addRecentActivity(
          type: "book_added",
          icon: "menu_book_rounded",
          title: "Book: $title",
          subtitle: "Added just now",
          bookTitle: title,
          genre: genre,
        );

        await fetchBooks();
        return true;
      } else {
        Get.snackbar("Error", "Failed: ${response.statusCode}\n$responseBody");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Upload failed: $e");
      return false;
    } finally {
      isLoading(false);
    }
  }

  /// Delete book
  Future<void> deleteBook(String id) async {
    try {
      isLoading(true);

      final token = await _getToken();
      if (token == null) {
        Get.snackbar("Error", "No token found. Please login again.");
        return;
      }
      // Find the book title before deletion for activity log
      final bookToDelete = books.firstWhere(
        (book) => book.id == id,
        orElse:
            () => BookModel(
              id: id,
              title: "Unknown Book",
              description: "",
              genre: "",
              coverImage: "",
              bookFile: "",
            ),
      );

      final response = await http.delete(
        Uri.parse("$baseUrl/$id/deleteBook"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        // Remove from local list immediately for better UX
        books.removeWhere((book) => book.id == id);

        // Add recent activity
        _addRecentActivity(
          type: "book_deleted",
          icon: "delete_rounded",
          title: "Book: ${bookToDelete.title}",
          subtitle: "Deleted just now",
          bookTitle: bookToDelete.title,
          genre: bookToDelete.genre,
        );

        Get.snackbar(
          "Success",
          "Book deleted successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Refresh the list to ensure consistency with server
        await fetchBooks();
      } else {
        Get.snackbar("Error", "Failed to delete book: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Delete failed: $e");
    } finally {
      isLoading(false);
    }
  }

  /// Update book
  Future<void> updateBook({
    required String id,
    required String title,
    required String description,
    required String genre,
  }) async {
    try {
      isLoading(true);
      final token = await _getToken();
      if (token == null) {
        Get.snackbar("Error", "No token found. Please login again.");
        return;
      }

      final response = await http.put(
        Uri.parse("$baseUrl/$id/updateBook"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "title": title,
          "description": description,
          "genre": genre,
        }),
      );

      if (response.statusCode == 200) {
        // Add recent activity
        _addRecentActivity(
          type: "book_updated",
          icon: "edit_rounded",
          title: "Book: $title",
          subtitle: "Updated just now",
          bookTitle: title,
          genre: genre,
        );

        Get.snackbar(
          "Success",
          "Book updated successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Refresh the books list to show updated data
        await fetchBooks();
      } else {
        Get.snackbar("Error", "Failed to update book: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "Update failed: $e");
    } finally {
      isLoading(false);
    }
  }

  /// Helper method to add recent activity
  void _addRecentActivity({
    required String type,
    required String icon,
    required String title,
    required String subtitle,
    required String bookTitle,
    required String genre,
  }) {
    final activity = {
      'type': type,
      'iconData': _getIconFromString(icon),
      'title': title,
      'subtitle': subtitle,
      'bookTitle': bookTitle,
      'genre': genre,
      'timestamp': DateTime.now().toIso8601String(),
    };

    // Add to beginning of list (most recent first)
    recentActivities.insert(0, activity);

    // Keep only last 10 activities
    if (recentActivities.length > 10) {
      recentActivities.removeRange(10, recentActivities.length);
    }
  }

  ///  Helper to convert string to IconData
  IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'menu_book_rounded':
        return Icons.menu_book_rounded;
      case 'edit_rounded':
        return Icons.edit_rounded;
      case 'delete_rounded':
        return Icons.delete_rounded;
      default:
        return Icons.info_outline;
    }
  }

  /// Get recent activities (for dashboard)
  List<Map<String, dynamic>> getRecentActivities() {
    return recentActivities.take(5).toList();
  }

  ///  Format time for recent activities
  // ignore: unused_element
  String _formatTimeAgo(String timestamp) {
    try {
      final date = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inMinutes < 1) {
        return "Just now";
      } else if (difference.inMinutes < 60) {
        return "${difference.inMinutes} minutes ago";
      } else if (difference.inHours < 24) {
        return "${difference.inHours} hours ago";
      } else if (difference.inDays == 1) {
        return "Yesterday";
      } else if (difference.inDays < 7) {
        return "${difference.inDays} days ago";
      } else {
        return "${date.day}/${date.month}/${date.year}";
      }
    } catch (e) {
      return "Recently";
    }
  }
}
