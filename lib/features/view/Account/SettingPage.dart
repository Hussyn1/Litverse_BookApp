import 'package:flutter/material.dart';
import 'package:litverse/features/view/Account/components/SettingOptionList.dart';
import 'package:litverse/features/view/Account/components/SettingTopBar.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Settingtopbar(),
              SizedBox(height: 10),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: settingOptions.length,
                itemBuilder: (context, index) {
                  final option = settingOptions[index];
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
                      title: Text(
                        option.title,
                        style: TextStyle(
                          fontFamily: 'IBMPlexSansCondensed',
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      onTap: () {
                        print("Working on ${option.title}");
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(),
                    backgroundColor: Colors.deepOrange,
                    minimumSize: const Size(double.infinity, 55),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Contact Support',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'IBMPlexSansCondensed',
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Version 264.2.0.5566",
                style: TextStyle(
                  fontFamily: 'IBMPlexSansCondensed',
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
