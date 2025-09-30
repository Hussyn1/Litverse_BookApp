import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:litverse/features/view/AuthPage/Authcontroller/auth_Controller.dart';

class AdminOrdersPage extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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
                      "ORDERS",
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
                    child: IconButton(
                      icon: Icon(Icons.logout_outlined),
                      onPressed: () {
                        authController.logout();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 5,
                padding: const EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    color: const Color(0xffF4E6D3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.black, width: 1.5),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Book Image
                          Container(
                            width: 60,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.black,
                                width: 1.2,
                              ),
                              image: const DecorationImage(
                                image: AssetImage(
                                  "assets/book.png",
                                ), // Replace with network image if needed
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Order details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Order #${index + 1}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Book: Flutter Basics",
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "User: John Doe",
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Status Dropdown
                          DropdownButton<String>(
                            value: "Pending",
                            underline: const SizedBox(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            items:
                                ["Pending", "Shipped", "Completed"]
                                    .map(
                                      (status) => DropdownMenuItem(
                                        value: status,
                                        child: Text(status),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {},
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
