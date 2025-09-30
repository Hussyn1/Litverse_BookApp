import 'package:flutter/material.dart';
import 'package:litverse/features/view/Model/bookModel.dart';

class BookCard extends StatelessWidget {
  final BookModel book;
  final VoidCallback? onTap;

  const BookCard({super.key, required this.book, this.onTap});

  // Helper method to construct full image URL
  String _getFullImageUrl(String? coverImagePath) {
    if (coverImagePath == null || coverImagePath.isEmpty) {
      return '';
    }

    const String baseUrl = "http://192.168.100.8:3000"; 

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
    final String fullImageUrl = _getFullImageUrl(book.coverImage);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Cover Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 220,
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
                child:
                    fullImageUrl.isNotEmpty
                        ? Image.network(
                          fullImageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                strokeWidth: 2,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                      
                            return Container(
                              color: const Color(0xffF4E6D3),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.book,
                                      size: 40,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Image\nNot Found",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontFamily: 'IBMPlexSansCondensed',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                        : Container(
                          color: const Color(0xffF4E6D3),
                          child: Center(
                            child: Icon(
                              Icons.book,
                              size: 50,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
              ),
            ),
            const SizedBox(height: 8),

            // Book Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                book.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'IBMPlexSansCondensed',
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),

            // Book Genre
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xffF25C2B).withOpacity(0.1),
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
            ),
            const SizedBox(height: 4),

            // Book Description (Optional)
            const SizedBox(height: 12),
            // Book Rating
            Row(
              children: [
                ...List.generate(5, (index) {
                  return Icon(
                    index <
                            book.averageRating
                                .round() 
                        ? Icons.star
                        : Icons.star_border,
                    size: 16,
                    color: Colors.amber,
                  );
                }),
                const SizedBox(width: 8),
                Text(
                  "${book.averageRating.toStringAsFixed(1)}/5",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  "(${book.ratingCount})", 
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
