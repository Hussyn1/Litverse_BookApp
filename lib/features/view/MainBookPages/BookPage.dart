// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:litverse/features/view/Admin_Pages/AdminBookPages/controller/book_Controller.dart';
import 'package:litverse/features/view/MainBookPages/UserPdf.dart';
import 'package:litverse/features/view/Model/bookModel.dart';

import 'package:litverse/features/view/MainBookPages/components/CstomMainPageTopBar.dart';
import 'package:litverse/features/view/MainBookPages/components/CstomPlayBtn.dart';

import '../SavedPage/SavedBookController.dart';

class Bookpage extends StatefulWidget {
  final BookModel book;

  const Bookpage({super.key, required this.book});

  @override
  State<Bookpage> createState() => _BookpageState();
}

class _BookpageState extends State<Bookpage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final updatedBook = await savedController.fetchBookById(widget.book.id);

      if (updatedBook != null) {
        setState(() {
          widget.book.averageRating = updatedBook.averageRating;
          widget.book.ratingCount = updatedBook.ratingCount;
        });

        // Update in SavedBooksController
        final savedController = Get.find<SavedBooksController>();
        int savedIndex = savedController.savedBooks.indexWhere(
          (b) => b.id == widget.book.id,
        );
        if (savedIndex != -1) {
          savedController.savedBooks[savedIndex].averageRating =
              updatedBook.averageRating;
          savedController.savedBooks[savedIndex].ratingCount =
              updatedBook.ratingCount;
          savedController.savedBooks.refresh();
        }

        //Update in BookController (Homepage)
        final bookController = Get.find<BookController>();
        int homeIndex = bookController.books.indexWhere(
          (b) => b.id == widget.book.id,
        );
        if (homeIndex != -1) {
          bookController.books[homeIndex].averageRating =
              updatedBook.averageRating;
          bookController.books[homeIndex].ratingCount = updatedBook.ratingCount;
          bookController.books.refresh(); 
        }
      }
    });
  }

  final savedController = Get.put(SavedBooksController());

  String _getFullImageUrl(String? coverImagePath) {
    if (coverImagePath == null || coverImagePath.isEmpty) return '';
    const String baseUrl = "http://192.168.100.8:3000";

    if (coverImagePath.startsWith('http')) return coverImagePath;
    if (coverImagePath.startsWith('/')) return '$baseUrl$coverImagePath';
    return '$baseUrl/$coverImagePath';
  }

  String _getFullPdfUrl(String? bookFilePath) {
    if (bookFilePath == null || bookFilePath.isEmpty) return '';
    const String baseUrl = "http://192.168.100.8:3000";

    if (bookFilePath.startsWith('http')) return bookFilePath;
    if (bookFilePath.startsWith('/')) return '$baseUrl$bookFilePath';
    return '$baseUrl/$bookFilePath';
  }

  @override
  Widget build(BuildContext context) {
    final String fullImageUrl = _getFullImageUrl(widget.book.coverImage);
    final String fullPdfUrl = _getFullPdfUrl(widget.book.bookFile);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              const BookPagetopBar(),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    _buildBookInfoSection(fullImageUrl),
                    const SizedBox(height: 20),

                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.5),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffF4E6D3),
                          fixedSize: Size(
                            MediaQuery.of(context).size.width,
                            50,
                          ),
                          shape: const RoundedRectangleBorder(),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Read Free For 30 Days",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'IBMPlexSansCondensed',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CstmPlayBtn(
                      onPressed: () {
                        if (fullPdfUrl.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => UserPdfReaderPage(
                                    bookTitle: widget.book.title,
                                    pdfUrl: fullPdfUrl,
                                    coverImageUrl: fullImageUrl,
                                    genre: widget.book.genre,
                                  ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Book file not available"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 10),

                    // Action Buttons (Download, Save, Add to List)
                    Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.5),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildActionButton(Icons.download_rounded, "Download"),
                          verticalDivider(),
                          Obx(() {
                            bool isSaved = savedController.isBookSaved(
                              widget.book.id,
                            );
                            return buildActionButton(
                              isSaved ? Icons.bookmark : Icons.bookmark_border,
                              isSaved ? "Saved" : "Save",
                              onTap: () async {
                                if (isSaved) {
                                  await savedController.unsaveBook(
                                    widget.book.id,
                                  );
                                } else {
                                  await savedController.saveBook(
                                    widget.book.id,
                                  );
                                }
                              },
                            );
                          }),
                          verticalDivider(),
                          buildActionButton(Icons.list, "Add to List"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Book Details
                    Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.black, width: 1.5),
                        ),
                      ),
                      child: Column(
                        children: [
                          detailRow("Title", Text(widget.book.title)),
                          const SizedBox(height: 8),
                          detailRow("Genre", Text(widget.book.genre)),
                          const SizedBox(height: 8),
                          detailRow("Format", const Text("Digital Book (PDF)")),
                          const SizedBox(height: 8),
                          detailRow("Status", const Text("Available to Read")),
                          const SizedBox(height: 8),
                          detailRow("Type", const Text("E-book")),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Description
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Description",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'IBMPlexSansCondensed',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.book.description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Book Info + Rating
  Widget _buildBookInfoSection(String fullImageUrl) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffF4E6D3),
        border: Border.all(color: Colors.black, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Book Cover
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 100,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black, width: 1),
              ),
              child:
                  fullImageUrl.isNotEmpty
                      ? Image.network(
                        fullImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.book,
                              size: 40,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                      : Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.book,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
            ),
          ),
          const SizedBox(width: 16),

          // Book Info + Rating
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.book.title,
                  style: const TextStyle(
                    fontSize: 20,
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
                    widget.book.genre,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xffF25C2B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                //Only show rating (no rate button / dialog)
                Row(
                  children: [
                    ...List.generate(5, (index) {
                      final rating = widget.book.averageRating;
                      return Icon(
                        index < rating.round() ? Icons.star : Icons.star_border,
                        size: 16,
                        color: Colors.amber,
                      );
                    }),
                    const SizedBox(width: 8),
                    Text(
                      "${widget.book.averageRating.toStringAsFixed(1)}/5",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget detailRow(String label, Widget value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 80,
        child: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(child: value),
    ],
  );
}

Widget buildActionButton(IconData icon, String label, {VoidCallback? onTap}) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28, color: Colors.black),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    ),
  );
}

Widget verticalDivider() {
  return Container(width: 1.2, height: 100, color: Colors.black);
}
