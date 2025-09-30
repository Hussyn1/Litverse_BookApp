import 'package:flutter/material.dart';

class topSearchBar extends StatelessWidget {
  const topSearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(12),
      height: 165,
      width: double.infinity,
      color: Colors.amberAccent.withOpacity(0.85),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Search",
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'IBMPlexSansCondensed',
              color: Colors.black.withOpacity(0.8),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Color(0xffF4E6D3),
    
              border: Border.all(color: Colors.black, width: 1.5),
            ),
            height: 60,
            width: double.infinity,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Title, author, host, or topic",
                hintStyle: TextStyle(
                  fontFamily: 'IBMPlexSansCondensed',
                  color: Colors.black,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.black),
                fillColor: Color(0xffF4E6D3),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
