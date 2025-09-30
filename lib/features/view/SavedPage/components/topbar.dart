import 'package:flutter/material.dart';

class SavedTopBar extends StatelessWidget {
  const SavedTopBar({super.key});

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
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "SAVED",
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'IBMPlexSansCondensed',
                color: Colors.black.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 80,
            width: 70,
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: Colors.black, width: 1.5)),
            ),
            child: Icon(Icons.mode_edit_outline_rounded),
          ),
        ],
      ),
    );
  }
}
