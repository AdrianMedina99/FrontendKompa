// ignore_for_file: file_names, camel_case_types

import 'package:kompa/config/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/dark_mode.dart';

class Payment_method extends StatefulWidget {
  const Payment_method({super.key});

  @override
  State<Payment_method> createState() => _Payment_methodState();
}

class _Payment_methodState extends State<Payment_method> {
  ColorNotifire notifier = ColorNotifire();
  int selectedFilter = 0;
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: notifier.backGround,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: notifier.backGround,
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
          "Payment Method",
          style: TextStyle(
            color: notifier.textColor,
            fontSize: 20,
            fontFamily: "Ariom-Bold",
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ExpansionTile(
              iconColor: notifier.textColor,
              leading: Transform.scale(
                scale: 1.4,
                child: Radio(
                  fillColor: MaterialStateColor.resolveWith(
                    (states) => notifier.textColor,
                  ),
                  // activeColor: const Color(0xff0056D2),
                  value: 0,
                  groupValue: selectedFilter,
                  onChanged: (index) {
                    setState(
                      () {
                        selectedFilter = 0;
                      },
                    );
                  },
                ),
              ),
              trailing: Icon(
                Icons.arrow_drop_down_outlined,
                color: notifier.textColor,
                size: 30,
              ),
              title: Row(
                children: [
                  Container(
                    height: height / 17,
                    width: width / 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xffB6B6C0),
                    ),
                    child: Image.asset(
                      "assets/Paypal.png",
                      scale: 3,
                    ),
                  ),
                  AppConstants.Width(width / 20),
                  Text(
                    "Paypal",
                    style: TextStyle(
                      fontSize: 19,
                      color: notifier.textColor,
                      fontFamily: "Ariom-Bold",
                    ),
                  ),
                ],
              ),
              children: <Widget>[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics:  const BouncingScrollPhysics(),
                  padding:  const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      Container(
                        height: height / 3.8,
                        width: width / 1.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomRight,
                            colors: [
                              notifier.backGround,
                              const Color(0xffC2D671),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppConstants.Height(height / 30),
                              Text(
                                "VISA",
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontFamily: "Ariom-Bold",
                                  fontSize: 22,
                                ),
                              ),
                              AppConstants.Height(height / 20),
                              Row(
                                children: [
                                  Text(
                                    "**** **** **** 1234",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: "Ariom-Bold",
                                      color: notifier.textColor,
                                    ),
                                  ),
                                  const Spacer(),
                                  Column(
                                    children: [
                                      Text(
                                        "VALID THRU",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: notifier.textColor,
                                        ),
                                      ),
                                      Text(
                                        "12/22",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: notifier.textColor,
                                          fontFamily: "Ariom-Bold",
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              AppConstants.Height(height / 30),
                              Text(
                                "MAROO LEPSMS",
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AppConstants.Width(width / 40),
                      Container(
                        height: height / 3.8,
                        width: width / 1.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomRight,
                            colors: [
                              notifier.backGround,
                              const Color(0xff71D6C4),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppConstants.Height(height / 30),
                              Text(
                                "VISA",
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontFamily: "Ariom-Bold",
                                  fontSize: 22,
                                ),
                              ),
                              AppConstants.Height(height / 20),
                              Row(
                                children: [
                                  Text(
                                    "**** **** **** 1234",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: "Ariom-Bold",
                                      color: notifier.textColor,
                                    ),
                                  ),
                                  const Spacer(),
                                  Column(
                                    children: [
                                      Text(
                                        "VALID THRU",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: notifier.textColor,
                                        ),
                                      ),
                                      Text(
                                        "12/22",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: notifier.textColor,
                                          fontFamily: "Ariom-Bold",
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              AppConstants.Height(height / 30),
                              Text(
                                "MAROO LEPSMS",
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppConstants.Height(height / 30),
            ExpansionTile(
              leading: Transform.scale(
                scale: 1.4,
                child: Radio(
                  fillColor: MaterialStateColor.resolveWith(
                    (states) => notifier.textColor,
                  ),
                  // activeColor: const Color(0xff0056D2),
                  value: 1,
                  groupValue: selectedFilter,
                  onChanged: (index) {
                    setState(
                      () {
                        selectedFilter = 1;
                      },
                    );
                  },
                ),
              ),
              trailing: Icon(
                Icons.arrow_drop_down_outlined,
                color: notifier.textColor,
                size: 30,
              ),
              title: Row(
                children: [
                  Container(
                    height: height / 17,
                    width: width / 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xffB6B6C0),
                    ),
                    child: Image.asset(
                      "assets/VISA.png",
                      scale: 3,
                    ),
                  ),
                  AppConstants.Width(width / 20),
                  Text(
                    "Credit Card",
                    style: TextStyle(
                      fontSize: 19,
                      color: notifier.textColor,
                      fontFamily: "Ariom-Bold",
                    ),
                  ),
                ],
              ),
              children: <Widget>[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      Container(
                        height: height / 3.8,
                        width: width / 1.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomRight,
                            colors: [
                              notifier.backGround,
                              const Color(0xffC2D671),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding:  const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppConstants.Height(height / 30),
                              Text(
                                "VISA",
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontFamily: "Ariom-Bold",
                                  fontSize: 22,
                                ),
                              ),
                              AppConstants.Height(height / 20),
                              Row(
                                children: [
                                  Text(
                                    "**** **** **** 1234",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: "Ariom-Bold",
                                      color: notifier.textColor,
                                    ),
                                  ),
                                  const Spacer(),
                                  Column(
                                    children: [
                                      Text(
                                        "VALID THRU",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: notifier.textColor,
                                        ),
                                      ),
                                      Text(
                                        "12/22",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: notifier.textColor,
                                          fontFamily: "Ariom-Bold",
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              AppConstants.Height(height / 30),
                              Text(
                                "MAROO LEPSMS",
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AppConstants.Width(width / 40),
                      Container(
                        height: height / 3.8,
                        width: width / 1.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomRight,
                            colors: [
                              notifier.backGround,
                              const Color(0xff71D6C4),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppConstants.Height(height / 30),
                              Text(
                                "VISA",
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontFamily: "Ariom-Bold",
                                  fontSize: 22,
                                ),
                              ),
                              AppConstants.Height(height / 20),
                              Row(
                                children: [
                                  Text(
                                    "**** **** **** 1234",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: "Ariom-Bold",
                                      color: notifier.textColor,
                                    ),
                                  ),
                                  const Spacer(),
                                  Column(
                                    children: [
                                      Text(
                                        "VALID THRU",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: notifier.textColor,
                                        ),
                                      ),
                                      Text(
                                        "12/22",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: notifier.textColor,
                                          fontFamily: "Ariom-Bold",
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              AppConstants.Height(height / 30),
                              Text(
                                "MAROO LEPSMS",
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppConstants.Height(height / 30),
            Text(
              "+ Add New Card",
              style: TextStyle(
                color: notifier.textColor,
                fontSize: 20,
                fontFamily: "Ariom-Bold",
              ),
            ),
            // Transform.scale(
            //   scale: 1.6,
            //   child: Radio(
            //     fillColor: MaterialStateColor.resolveWith(
            //         (states) =>  const Color(0xffD1E50C)),
            //      // activeColor:  Colors.red,
            //     value: 1,
            //     groupValue: selectedFilter,
            //     onChanged: (index) {
            //       setState(
            //         () {
            //           selectedFilter = 1;
            //         },
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          height: height / 11,
          decoration:  const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Color(0xffD1E50C),
          ),
          child:  const Center(
            child: Text(
              "Apply",
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Ariom-Bold",
                color: Color(0xff131313),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
