import 'package:flutter/material.dart';

class BooksButton extends StatefulWidget {
  const BooksButton({super.key});

  @override
  State<BooksButton> createState() => _BooksButtonState();
}

class _BooksButtonState extends State<BooksButton> {
  final List<String> BookItems = [
    'Everything',
    'Ebooks',
    'AudioBooks',
    'Magzines',
    'Salad',
    'Sushi',
  ];

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: BookItems.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(0, 30),
                side: BorderSide(color: Colors.black, width: 1),
                backgroundColor:
                    isSelected ? const Color(0xffF25C2B) : Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              child: Text(
                BookItems[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
