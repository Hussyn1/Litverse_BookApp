import 'package:flutter/material.dart';

class CstmPlayBtn extends StatelessWidget {
  final VoidCallback? onPressed;
  const CstmPlayBtn({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(MediaQuery.of(context).size.width, 60),
        shape: RoundedRectangleBorder(),
      ),

      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.play_arrow_rounded,
            color: Colors.black.withOpacity(0.8),
            size: 25,
          ),
          Text(
            "Play Sample",
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'IBMPlexSansCondensed',
              color: Colors.black.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
