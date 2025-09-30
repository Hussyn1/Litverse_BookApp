import 'package:flutter/material.dart';

class Settingtopbar extends StatelessWidget {
  const Settingtopbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: Row(
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
            child: Icon(Icons.arrow_back_ios_new_rounded ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "Settings",
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'IBMPlexSansCondensed',
                color: Colors.black.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
