import 'package:flutter/material.dart';

class CstmTextField extends StatelessWidget {
  final String text;
  final Widget?
  icon; // changed from Icon? to Widget? so you can pass IconButton
  final bool obscureText;
  final TextEditingController controller ;

   CstmTextField({
    super.key,
    required this.text,
    this.icon,
    this.obscureText = false, required this.controller, // default false
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller:controller ,
        cursorColor: Colors.black,
        obscureText: obscureText,
        decoration: InputDecoration(
          suffixIcon: icon,
          hintText: text,
          hintStyle: TextStyle(
            fontFamily: 'IBMPlexSansCondensed',
            color: Colors.black.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
          contentPadding: const EdgeInsets.all(20),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black.withOpacity(0.8),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black.withOpacity(0.8),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(0),
          ),
        ),
      ),
    );
  }
}
