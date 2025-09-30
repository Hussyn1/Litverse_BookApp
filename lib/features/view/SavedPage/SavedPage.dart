import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:litverse/features/view/SavedPage/components/CstomTopBtn.dart';
import 'package:litverse/features/view/SavedPage/components/SavedSearchBar.dart';
import 'package:litverse/features/view/SavedPage/components/topbar.dart';
import 'package:litverse/features/view/Model/bookModel.dart';
import 'package:litverse/features/view/MainBookPages/Bookpage.dart';

import 'SavedBookController.dart';

class Savedpage extends StatefulWidget {
  const Savedpage({super.key});

  @override
  State<Savedpage> createState() => _SavedpageState();
}

class _SavedpageState extends State<Savedpage> {
  final SavedBooksController savedController = Get.put(SavedBooksController());

  @override
  void initState() {
    super.initState();
    savedController.fetchSavedBooks();
  }

  // Helper method to construct full image URL
  String _getFullImageUrl(String? coverImagePath) {
    if (coverImagePath == null || coverImagePath.isEmpty) return '';
    const String baseUrl = "http://192.168.100.8:3000";
    if (coverImagePath.startsWith('http')) return coverImagePath;
    if (coverImagePath.startsWith('/')) return '$baseUrl$coverImagePath';
    return '$baseUrl/$coverImagePath';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EAD7),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const SavedTopBar(),
            Container(
              color: Colors.amberAccent.withOpacity(0.85),
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  const CstomTopBtn(),
                  const SizedBox(height: 15),
                  const Savedsearchbar(),
                  const SizedBox(height: 15),
                ],
              ),
            ),
            
            // Saved Books List
            Expanded(
              child: Obx(() {
                if (savedController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (savedController.savedBooks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bookmark_border,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No saved books yet",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontFamily: 'IBMPlexSansCondensed',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Books you save will appear here",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                            fontFamily: 'IBMPlexSansCondensed',
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => savedController.fetchSavedBooks(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: savedController.savedBooks.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final book = savedController.savedBooks[index];
                      return _buildBookItem(book);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookItem(BookModel book) {
    final String fullImageUrl = _getFullImageUrl(book.coverImage);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Bookpage(book: book),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffF4E6D3),
          border: Border.all(color: Colors.black, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Cover Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Container(
                width: 100,
                height: 150,
                color: Colors.grey[200],
                child: fullImageUrl.isNotEmpty
                    ? Image.network(
                        fullImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.book,
                              size: 40,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : const Icon(
                        Icons.book,
                        size: 40,
                        color: Colors.grey,
                      ),
              ),
            ),
            
            // Book Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IBMPlexSansCondensed',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffF25C2B).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        book.genre,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xffF25C2B),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'IBMPlexSansCondensed',
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      book.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        fontFamily: 'IBMPlexSansCondensed',
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    
                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.star_border, size: 20),
                          onPressed: () => _showRatingDialog(book),
                          tooltip: "Rate Book",
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20),
                          color: Colors.red,
                          onPressed: () => _showDeleteConfirmation(book),
                          tooltip: "Remove from Saved",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRatingDialog(BookModel book) {
    int selectedRating = 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Rate ${book.title}"),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Tap to select rating:"),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < selectedRating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 32,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedRating = index + 1;
                        });
                      },
                    );
                  }),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (selectedRating > 0) {
                await savedController.rateBook(book.id, selectedRating);
                Navigator.pop(context);
              } else {
                Get.snackbar("Error", "Please select a rating");
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffF25C2B),
              foregroundColor: Colors.white,
            ),
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BookModel book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Remove Book"),
        content: Text("Remove '${book.title}' from your saved books?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await savedController.unsaveBook(book.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Remove"),
          ),
        ],
      ),
    );
  }
}