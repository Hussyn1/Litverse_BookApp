import 'package:flutter/material.dart';

class Savedsearchbar extends StatelessWidget {
  const Savedsearchbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      height: 100,
      width: double.infinity,
      color: Colors.amberAccent.withOpacity(0.85),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffF4E6D3),

                border: Border.all(color: Colors.black, width: 1.5),
              ),
              height: 70,
              width: double.infinity,
              child: Center(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search in Titles",
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
            ),
          ),
          SizedBox(width: 10),
          Container(
            height: 70,
            width: 65,
            decoration: BoxDecoration(
              color: Color(0xffF4E6D3),
              border: Border.all(color: Colors.black, width: 1.5),
            ),
            child: IconButton(
              icon: Icon(Icons.filter_list_outlined, color: Colors.black),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
