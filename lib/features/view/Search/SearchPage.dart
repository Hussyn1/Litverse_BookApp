import 'package:flutter/material.dart';
import 'package:litverse/features/view/Search/searchOptionsList.dart';
import 'package:litverse/features/view/Search/topSearchBar.dart';

class Searchpage extends StatefulWidget {
  const Searchpage({super.key});

  @override
  State<Searchpage> createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              topSearchBar(),
              SizedBox(height: 10),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: searchOptions.length,
                itemBuilder: (context, index) {
                  final option = searchOptions[index];
                  return Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black,
                          width: 1.5,
                        ), // only bottom
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.only(top: 10),
                      leading: Icon(option.icon, color: Colors.black),
                      title: Text(
                        option.title,
                        style: TextStyle(
                          fontFamily: 'IBMPlexSansCondensed',
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      onTap: () {},
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
