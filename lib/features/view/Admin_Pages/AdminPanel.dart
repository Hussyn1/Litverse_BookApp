import 'package:flutter/material.dart';
import 'package:litverse/features/view/Admin_Pages/AdminBookPages/Admin_Book_Page.dart';
import 'package:litverse/features/view/Admin_Pages/AdminDashBoardPages/Admin_DashBoard.dart';
import 'package:litverse/features/view/Admin_Pages/Admin_order_Page.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    AdminDashboardPage(),
    AdminBooksPage(),
    AdminOrdersPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black, width: 1)),
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
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: "Dashboard",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: "Books"),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: "Orders",
            ),
          ],
        ),
      ),
    );
  }
}
