import 'package:flutter/material.dart';
import 'package:litverse/features/view/HomePage/HomePage.dart';
import 'package:litverse/features/view/SavedPage/SavedPage.dart';
import 'package:litverse/features/view/Search/SearchPage.dart';
import 'package:litverse/features/view/Account/SettingPage.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({super.key});

  @override
  State<Bottomnav> createState() => _BottomnavState();
}

class _BottomnavState extends State<Bottomnav> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Homepage(),
    Searchpage(),
    Savedpage(),
    SettingPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.black, width: 1), // ✅ Top border only
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xffF25C2B),
          unselectedItemColor: Colors.black,
          elevation: 0,
          backgroundColor: Color(0xffF4E6D3),
          items: const [
            BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
            BottomNavigationBarItem(label: "Search", icon: Icon(Icons.search)),
            BottomNavigationBarItem(
              label: "Saved",
              icon: Icon(Icons.bookmark_border_rounded),
            ),
            BottomNavigationBarItem(label: "Account", icon: Icon(Icons.person)),
          ],
        ),
      ),
    );
  }
}
