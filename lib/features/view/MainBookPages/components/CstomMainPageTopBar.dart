import 'package:flutter/material.dart';

class BookPagetopBar extends StatelessWidget {
  const BookPagetopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.center,
            height: 80,
            width: 70,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.black, width: 1.5),
              ),
            ),
            child: Icon(Icons.arrow_back_ios_new_rounded),
          ),
          Text(
            "LITVERSE",
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'IBMPlexSansCondensed',
              color: Colors.black.withOpacity(0.8),
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 80,
            width: 70,
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: Colors.black, width: 1.5)),
            ),
            child: Icon(Icons.share_sharp),
          ),
        ],
      ),
    );
  }
}
