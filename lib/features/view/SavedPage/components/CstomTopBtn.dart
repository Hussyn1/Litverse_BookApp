import 'package:flutter/material.dart';

class CstomTopBtn extends StatefulWidget {
  const CstomTopBtn({super.key});

  @override
  State<CstomTopBtn> createState() => _CstomTopBtnState();
}

class _CstomTopBtnState extends State<CstomTopBtn> {
  final List<String> BookItems = [
    'Everything',
    'Ebooks',
    'AudioBooks',
    'Magzines',
    'Salad',
    'Sushi',
  ];

  int selectedIndex = 0;
  // 👈 Track selected index
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
                }); // 👈
                print('${BookItems[index]} clicked');
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
