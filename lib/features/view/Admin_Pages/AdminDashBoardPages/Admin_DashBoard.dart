import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:litverse/features/view/Admin_Pages/AdminDashBoardPages/Sales_Chart.dart';
import 'package:litverse/features/view/Admin_Pages/AdminBookPages/controller/book_Controller.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final BookController bookController = Get.put(BookController());

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 70,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "DASHBOARD",
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'IBMPlexSansCondensed',
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 80,
                  width: 70,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.black, width: 1.5),
                    ),
                  ),
                  child: Icon(Icons.chat_bubble_rounded),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StatCard(title: "Users", value: "120"),
                      Obx(
                        () => StatCard(
                          title: "Books",
                          value: "${bookController.books.length}",
                        ),
                      ),
                      StatCard(title: "Orders", value: "230"),
                    ],
                  ),
                  SizedBox(height: 20),

                  SalesChart(),
                  SizedBox(height: 20),

                  // Recent Activity Section
                  Text(
                    "Recent Activity",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),

                  // Dynamic Recent Activities
                  Obx(() {
                    final activities =
                        bookController.recentActivities.take(3).toList();

                    if (activities.isEmpty) {
                      return Column(
                        children: [
                          ActivityCard(
                            icon: Icons.info_outline,
                            title: "Welcome to Admin Dashboard",
                            subtitle: "Start by adding some books",
                          ),
                          SizedBox(height: 10),
                          ActivityCard(
                            icon: Icons.shopping_cart_rounded,
                            title: "Order: 3 copies of Dart Book",
                            subtitle: "Placed 1 day ago",
                          ),
                        ],
                      );
                    }

                    // Show actual recent activities
                    return Column(
                      children: [
                        ...activities.map((activity) {
                          IconData activityIcon;

                          // Map activity types to icons
                          switch (activity['type']) {
                            case 'book_added':
                              activityIcon = Icons.menu_book_rounded;
                              break;
                            case 'book_updated':
                              activityIcon = Icons.edit_rounded;
                              break;
                            case 'book_deleted':
                              activityIcon = Icons.delete_rounded;
                              break;
                            default:
                              activityIcon = Icons.info_outline;
                          }

                          return Column(
                            children: [
                              ActivityCard(
                                icon: activityIcon,
                                title: activity['title'] ?? 'Unknown Activity',
                                subtitle: _getFormattedTime(
                                  activity['timestamp'],
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          );
                        }).toList(),

                        // Add a default order activity if we have book activities
                        if (activities.isNotEmpty)
                          ActivityCard(
                            icon: Icons.shopping_cart_rounded,
                            title: "Order: 3 copies of Dart Book",
                            subtitle: "Placed 1 day ago",
                          ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const ActivityCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: const Color(0xffF4E6D3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.black, width: 1.5),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xffF25C2B)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  const StatCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Color(0xffF4E6D3),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 1.5),
        ),
        padding: const EdgeInsets.all(16),
        width: 100,
        child: Column(
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xffF25C2B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _getFormattedTime(String? timestamp) {
  if (timestamp == null) return "Recently";

  try {
    final date = DateTime.parse(timestamp);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minutes ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hours ago";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} days ago";
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
  } catch (e) {
    return "Recently";
  }
}
