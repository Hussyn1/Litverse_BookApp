import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:litverse/features/view/Admin_Pages/AdminBookPages/controller/book_Controller.dart';

import 'package:litverse/features/view/HomePage/components/CstmBookCard.dart';
import 'package:litverse/features/view/HomePage/components/CstmBooksBtn.dart';
import 'package:litverse/features/view/HomePage/components/CstmTopBar.dart';
import 'package:litverse/features/view/MainBookPages/BookPage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final BookController bookController = Get.put(BookController());

  @override
  void initState() {
    super.initState();
    bookController.fetchBooks(); //fetch API books on start
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // re-fetch books when pulling down
            await bookController.fetchBooks();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 10),
                topBar(),
                const SizedBox(height: 10),
                const BooksButton(),
                const SizedBox(height: 10),
                const FreeTrialContainer(),
                const SizedBox(height: 15),

                // Popular Books
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Popular",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'IBMPlexSansCondensed',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "more",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                          fontFamily: 'IBMPlexSansCondensed',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Books from API
                SizedBox(
                  height: 320,
                  child: Obx(() {
                    if (bookController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (bookController.books.isEmpty) {
                      return const Center(child: Text("No books found"));
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: bookController.books.length,
                      itemBuilder: (context, index) {
                        final book = bookController.books[index];
                        return Obx(() {
                          return bookController.isLoading.value
                              ? const Center(child: CircularProgressIndicator())
                              : GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => Bookpage(book: book),
                                    ),
                                  );
                                },
                                child: BookCard(book: book),
                              );
                        });
                       
                      },
                    );
                  }),
                ),

                const SizedBox(height: 20),

                // Recommended Books
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Recommended for you",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'IBMPlexSansCondensed',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "more",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                          fontFamily: 'IBMPlexSansCondensed',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Reuse same books for now
                SizedBox(
                  height: 320,
                  child: Obx(() {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: bookController.books.length,
                      itemBuilder: (context, index) {
                        final book = bookController.books[index];
                        return BookCard(book: book);
                      },
                    );
                  }),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FreeTrialContainer extends StatelessWidget {
  const FreeTrialContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 180,
      width: double.infinity,
      color: Colors.amberAccent.withOpacity(0.85),
      child: Column(
        children: [
          Text(
            "Read Anywhere. Anytime.",
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'IBMPlexSansCondensed',
              color: Colors.black.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const Text("Discover, read, listen and play with ease."),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.5),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffF4E6D3),
                fixedSize: const Size(300, 50),
                shape: RoundedRectangleBorder(),
              ),
              onPressed: () {},
              child: const Text(
                "Read Free For 30 Days",
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'IBMPlexSansCondensed',
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Cancel anytime",
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontSize: 16,
              fontFamily: 'IBMPlexSansCondensed',
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
