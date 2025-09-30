import 'package:flutter/material.dart';

class BookInfo extends StatelessWidget {
  const BookInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 160,
          width: 120,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(
              4.0,
            ), 
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: Image.network(
                "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1364777365i/17465049.jpg",
    
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "The Great Gatsby",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  " By: F. Scott Fitzgerald",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "A classic novel of the Jazz Age, The Great Gatsby tells the story of Jay Gatsby's love for Daisy Buchanan and his quest to win her back.",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
