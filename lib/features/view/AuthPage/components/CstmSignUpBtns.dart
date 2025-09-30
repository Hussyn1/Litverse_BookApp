import 'package:flutter/material.dart';

class Cstmsignupbtn extends StatelessWidget {
  final String text;
  final VoidCallback ontap;
  final Image img;
  const Cstmsignupbtn({
    super.key,
    required this.text,
    required this.ontap,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: EdgeInsets.only(left: 10, right: 10),
        height: 65,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black.withOpacity(0.8), width: 1.5),
        ),
        child: Row(
          children: [
            img,
            SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'IBMPlexSansCondensed',
                color: Colors.black.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
