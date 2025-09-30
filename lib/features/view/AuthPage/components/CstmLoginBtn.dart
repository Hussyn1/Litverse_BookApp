import 'package:flutter/material.dart';

class Cstmloginbtn extends StatelessWidget {
  final VoidCallback ontap;
  final String text;
  const Cstmloginbtn({super.key, required this.ontap, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(MediaQuery.of(context).size.width, 60),
          shape: RoundedRectangleBorder(),
        ),

        onPressed: ontap,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'IBMPlexSansCondensed',
            color: Colors.black.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
