import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class BookService {
  final String baseUrl = "http://192.168.100.8:3000/api/books";
  Future<List> getAllBooks() async {
    final response = await http.get(Uri.parse("$baseUrl/getAllBooks"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<Map<String, dynamic>> createBook({
    required String title,
    required String description,
    required String genre,
    File? coverImage,
    File? bookFile,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/createBook'),
    );
    request.fields["title"] = title;
    request.fields["description"] = description;
    request.fields["genre"] = genre;
    if (coverImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath('coverImage', coverImage.path),
      );
    }
    if (bookFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('bookFile', bookFile.path),
      );
    }
    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      return jsonDecode(responseBody);
    } else {
      throw Exception("Failed to upload book: $responseBody");
    }
  }
}
