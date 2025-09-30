// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:litverse/features/view/Admin_Pages/AdminBookPages/controller/book_Controller.dart';
import 'package:litverse/routes/routes.dart';
import 'package:litverse/features/view/Model/bookModel.dart';

class AdminBooksPage extends StatelessWidget {
  final BookController bookController = Get.put(BookController());

  AdminBooksPage({super.key});

  String _getFullImageUrl(String? coverImagePath) {
    if (coverImagePath == null || coverImagePath.isEmpty) {
      return '';
    }

    const String baseUrl =
        "http://192.168.100.8:3000"; 

    if (coverImagePath.startsWith('http')) {
      return coverImagePath;
    }

    if (coverImagePath.startsWith('/')) {
      return '$baseUrl$coverImagePath';
    }

    return '$baseUrl/$coverImagePath';
  }

  @override
  Widget build(BuildContext context) {
    bookController.fetchBooks();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Books"),
        backgroundColor: const Color(0xffF25C2B),
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (bookController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (bookController.books.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.book_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  "No books found",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                Text(
                  "Add some books to get started!",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: bookController.books.length,
          itemBuilder: (context, index) {
            final BookModel book = bookController.books[index];
            final String fullImageUrl = _getFullImageUrl(
              book.coverImage,
            ); 

            return Container(
              decoration: BoxDecoration(
                color: const Color(0xffF4E6D3),
                border: Border.all(color: Colors.black, width: 1.5),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child:
                              fullImageUrl.isNotEmpty
                                  ? Image.network(
                                    fullImageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    loadingBuilder: (
                                      context,
                                      child,
                                      loadingProgress,
                                    ) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value:
                                              loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                    
                                      return Container(
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.broken_image,
                                                size: 40,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                "Image not found",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                  : Container(
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Icon(
                                        Icons.book,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: PopupMenuButton<String>(
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.black,
                              size: 20,
                            ),
                            onSelected: (value) {
                              if (value == "edit") {
                                _showEditDialog(context, book);
                              } else if (value == "delete") {
                                _showDeleteConfirmation(context, book);
                              }
                            },
                            itemBuilder:
                                (context) => const [
                                  PopupMenuItem(
                                    value: "edit",
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, size: 18),
                                        SizedBox(width: 8),
                                        Text("Edit"),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: "delete",
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          size: 18,
                                          color: Colors.red,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      book.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IBMPlexSansCondensed',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffF25C2B).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        book.genre,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xffF25C2B),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'IBMPlexSansCondensed',
                        ),
                      ),
                    ),
                  ),

                  // Description
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      book.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                        fontFamily: 'IBMPlexSansCondensed',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const Spacer(),
                  // Date added
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.star, size: 16, color: Colors.orange),
                        Icon(Icons.star, size: 16, color: Colors.orange),
                        Icon(Icons.star, size: 16, color: Colors.orange),
                        Icon(Icons.star, size: 16, color: Colors.orange),
                        Icon(Icons.star_border, size: 16, color: Colors.orange),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffF25C2B),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          Get.toNamed(AppRoutes.AddBookPage);
        },
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return "Unknown";
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return "today";
      } else if (difference.inDays == 1) {
        return "yesterday";
      } else if (difference.inDays < 7) {
        return "${difference.inDays} days ago";
      } else {
        return "${date.day}/${date.month}/${date.year}";
      }
    } catch (e) {
      return "Unknown";
    }
  }

  void _showEditDialog(BuildContext context, BookModel book) {
    final titleController = TextEditingController(text: book.title);
    final descController = TextEditingController(text: book.description);
    String selectedGenre = book.genre;

    final List<String> genres = [
      "Love",
      "Action",
      "Adventure",
      "Horror",
      "Fantasy",
      "Other",
    ];

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Edit Book"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: "Title"),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descController,
                    decoration: const InputDecoration(labelText: "Description"),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedGenre,
                    items:
                        genres
                            .map(
                              (g) => DropdownMenuItem(value: g, child: Text(g)),
                            )
                            .toList(),
                    onChanged: (value) => selectedGenre = value!,
                    decoration: const InputDecoration(labelText: "Genre"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty &&
                      descController.text.isNotEmpty) {
                    bookController.updateBook(
                      id: book.id,
                      title: titleController.text.trim(),
                      description: descController.text.trim(),
                      genre: selectedGenre,
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffF25C2B),
                ),
                child: const Text(
                  "Update",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, BookModel book) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Delete Book"),
            content: Text(
              "Are you sure you want to delete '${book.title}'? This action cannot be undone.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  bookController.deleteBook(book.id);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }
}
