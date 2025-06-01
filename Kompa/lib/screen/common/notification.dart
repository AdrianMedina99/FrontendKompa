// ignore_for_file: file_names, camel_case_types


import 'package:flutter/material.dart';
import 'package:kompa/screen/common/SearchScreen.dart';
import 'package:provider/provider.dart';

import '../../config/AppConstants.dart';
import '../../config/dark_mode.dart';


class notification extends StatefulWidget {
  const notification({super.key});

  @override
  State<notification> createState() => _notificationState();
}

class _notificationState extends State<notification> {
  int selectedFilter = 0;
  int selectedFilter1 = 0;
  int selectedFilter2 = 0;
  ColorNotifire notifier = ColorNotifire();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: notifier.backGround,
      appBar: AppBar(
        backgroundColor: notifier.backGround,
        elevation: 0,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            "assets/arrow-left.png",
            scale: 3,
            color: notifier.textColor,
          ),
        ),
        title: Text(
          "Notification",
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'Ariom-Bold',
            color: notifier.textColor,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Search(),
                ),
              );
            },
            child: Image.asset(
              "assets/Search.png",
              scale: 3,
              color: notifier.textColor,
            ),
          ),
          SizedBox(width: 5),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: Container(
                height: height / 13,
                width: width / 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    "assets/Profile.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:  const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Text(
                          "Alex Drew",
                          style: TextStyle(
                            color: notifier.textColor,
                            fontFamily: 'Ariom-Bold',
                            fontSize: 15,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "10 minutes",
                          style: TextStyle(
                            color: notifier.textColor,
                            fontFamily: 'Ariom-Regular',
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Alex Drew wants to send you a friend\nrequest.",
                    style: TextStyle(
                      color: notifier.subtitleTextColor,
                      fontFamily: 'Averta-Regular',
                      fontSize: 14,
                    ),
                  ),
                  AppConstants.Height(height / 50),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedFilter = 0;
                          });
                        },
                        child: Container(
                          height: height / 15,
                          width: width / 3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: selectedFilter == 0
                                ? const Color(0xffD1E50C)
                                : notifier.isDark
                                    ? const Color(0xff131313)
                                    : const Color(0xffFFFFFF),
                            border: Border.all(
                              color: selectedFilter == 1
                                  ? notifier.isDark
                                      ? const Color(0xffFFFFFF)
                                      : const Color(0xff131313)
                                  : notifier.isDark
                                      ? Colors.transparent
                                      : const Color(0xff131313),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Confirm",
                              style: TextStyle(
                                color: notifier.isDark
                                    ? const Color(0xffFFFFFF)
                                    : const Color(0xff131313),
                                fontSize: 18,
                                fontFamily: "Ariom-Bold",
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          setState(
                            () {
                              selectedFilter = 1;
                            },
                          );
                        },
                        child: Container(
                          height: height / 15,
                          width: width / 3,
                          decoration: BoxDecoration(
                            color: selectedFilter == 1
                                ? const Color(0xffD1E50C)
                                : notifier.isDark
                                    ? const Color(0xff131313)
                                    : const Color(0xffFFFFFF),
                            border: Border.all(
                              color: selectedFilter == 1
                                  ? notifier.isDark
                                      ? Colors.transparent
                                      : const Color(0xff131313)
                                  : notifier.isDark
                                      ? const Color(0xffFFFFFF)
                                      : const Color(0xff131313),
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                color: notifier.isDark
                                    ? const Color(0xffFFFFFF)
                                    : const Color(0xff131313),
                                fontSize: 18,
                                fontFamily: "Ariom-Bold",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            AppConstants.Height(height / 60),
            ListTile(
              leading: Container(
                height: height / 13,
                width: width / 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.red,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    "assets/Profile.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:  const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Text(
                          "Toa Heftiba",
                          style: TextStyle(
                            color: notifier.textColor,
                            fontFamily: 'Ariom-Bold',
                            fontSize: 15,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "10 minutes",
                          style: TextStyle(
                            color: notifier.textColor,
                            fontFamily: 'Ariom-Regular',
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Toa Heftiba wants to send you a friend\nrequest.",
                    style: TextStyle(
                      color: notifier.subtitleTextColor,
                      fontFamily: 'Averta-Regular',
                      fontSize: 14,
                    ),
                  ),
                  AppConstants.Height(height / 50),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(
                            () {
                              selectedFilter1 = 0;
                            },
                          );
                        },
                        child: Container(
                          height: height / 15,
                          width: width / 3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: selectedFilter1 == 0
                                ? const Color(0xffD1E50C)
                                : notifier.isDark
                                    ? const Color(0xff131313)
                                    : const Color(0xffFFFFFF),
                            border: Border.all(
                              color: selectedFilter1 == 1
                                  ? notifier.isDark
                                      ? const Color(0xffFFFFFF)
                                      : const Color(0xff131313)
                                  : notifier.isDark
                                      ? Colors.transparent
                                      : const Color(0xff131313),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Confirm",
                              style: TextStyle(
                                color: notifier.isDark
                                    ? const Color(0xffFFFFFF)
                                    : const Color(0xff131313),
                                fontSize: 18,
                                fontFamily: "Ariom-Bold",
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedFilter1 = 1;
                          });
                        },
                        child: Container(
                          height: height / 15,
                          width: width / 3,
                          decoration: BoxDecoration(
                            color: selectedFilter1 == 1
                                ? const Color(0xffD1E50C)
                                : notifier.isDark
                                    ? const Color(0xff131313)
                                    : const Color(0xffFFFFFF),
                            border: Border.all(
                              color: selectedFilter1 == 1
                                  ? notifier.isDark
                                      ? Colors.transparent
                                      : const Color(0xff131313)
                                  : notifier.isDark
                                      ? const Color(0xffFFFFFF)
                                      : const Color(0xff131313),
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                color: notifier.isDark
                                    ? const Color(0xffFFFFFF)
                                    : const Color(0xff131313),
                                fontSize: 18,
                                fontFamily: "Ariom-Bold",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            AppConstants.Height(height / 60),
            ListTile(
              leading: Container(
                height: height / 13,
                width: width / 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.red,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    "assets/Profile.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Text(
                          "Rafaella Mendes",
                          style: TextStyle(
                            color: notifier.textColor,
                            fontFamily: 'Ariom-Bold',
                            fontSize: 15,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "10 minutes",
                          style: TextStyle(
                            color: notifier.textColor,
                            fontFamily: 'Ariom-Regular',
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Rafaella Mendes wants to send you a friend\nrequest.",
                    style: TextStyle(
                      color: notifier.subtitleTextColor,
                      fontFamily: 'Averta-Regular',
                      fontSize: 14,
                    ),
                  ),
                  AppConstants.Height(height / 50),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(
                            () {
                              selectedFilter2 = 0;
                            },
                          );
                        },
                        child: Container(
                          height: height / 15,
                          width: width / 3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: selectedFilter2 == 0
                                ? const Color(0xffD1E50C)
                                : notifier.isDark
                                    ? const Color(0xff131313)
                                    : const Color(0xffFFFFFF),
                            border: Border.all(
                              color: selectedFilter2 == 1
                                  ? notifier.isDark
                                      ? const Color(0xffFFFFFF)
                                      : const Color(0xff131313)
                                  : notifier.isDark
                                      ? Colors.transparent
                                      : const Color(0xff131313),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Confirm",
                              style: TextStyle(
                                color: notifier.isDark
                                    ? const Color(0xffFFFFFF)
                                    : const Color(0xff131313),
                                fontSize: 18,
                                fontFamily: "Ariom-Bold",
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          setState(
                            () {
                              selectedFilter2 = 1;
                            },
                          );
                        },
                        child: Container(
                          height: height / 15,
                          width: width / 3,
                          decoration: BoxDecoration(
                            color: selectedFilter2 == 1
                                ? const Color(0xffD1E50C)
                                : notifier.isDark
                                    ? const Color(0xff131313)
                                    : const Color(0xffFFFFFF),
                            border: Border.all(
                              color: selectedFilter2 == 1
                                  ? notifier.isDark
                                      ? Colors.transparent
                                      : const Color(0xff131313)
                                  : notifier.isDark
                                      ? const Color(0xffFFFFFF)
                                      : const Color(0xff131313),
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                color: notifier.isDark
                                    ? const Color(0xffFFFFFF)
                                    : const Color(0xff131313),
                                fontSize: 18,
                                fontFamily: "Ariom-Bold",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppConstants.Height(height / 60),
            ListTile(
              leading: Container(
                height: height / 13,
                width: width / 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.red,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    "assets/Profile.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Row(
                children: [
                  Text(
                    "Ivana Cajina",
                    style: TextStyle(
                      color: notifier.textColor,
                      fontFamily: 'Ariom-Bold',
                      fontSize: 15,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "1 day",
                    style: TextStyle(
                      color: notifier.textColor,
                      fontFamily: 'Ariom-Regular',
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                "Ivana Cajina and you became friends.",
                style: TextStyle(
                  color: notifier.subtitleTextColor,
                  fontFamily: 'Averta-Regular',
                  fontSize: 14,
                ),
              ),
            ),
            AppConstants.Height(height / 60),
            ListTile(
              leading: Container(
                height: height / 13,
                width: width / 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.red,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    "assets/Profile.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Row(
                children: [
                  Text(
                    "Ayo Quin",
                    style: TextStyle(
                      color: notifier.textColor,
                      fontFamily: 'Ariom-Bold',
                      fontSize: 15,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "1 day",
                    style: TextStyle(
                      color: notifier.textColor,
                      fontFamily: 'Ariom-Regular',
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                "Ayo Quin and you became friends.",
                style: TextStyle(
                  color: notifier.subtitleTextColor,
                  fontFamily: 'Averta-Regular',
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
