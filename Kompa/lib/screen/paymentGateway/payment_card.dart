// ignore_for_file: file_names, camel_case_types

import 'package:dotted_border/dotted_border.dart';
import 'package:kompa/config/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/dark_mode.dart';
import 'add_card.dart';
import 'add_card_manually.dart';
import 'card_detail.dart';

class Payment_card extends StatefulWidget {
  const Payment_card({super.key});

  @override
  State<Payment_card> createState() => _Payment_cardState();
}

class _Payment_cardState extends State<Payment_card> {
  ColorNotifire notifier = ColorNotifire();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: notifier.backGround,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: notifier.backGround,
        elevation: 0,
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
          "Payment Card",
          style: TextStyle(
            color: notifier.textColor,
            fontSize: 20,
            fontFamily: "Ariom-Bold",
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppConstants.Height(height / 40),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        isScrollControlled: true,
                        // constraints: const BoxConstraints(
                        //     maxHeight: 200, maxWidth: 200,minHeight: 200),
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return Container(
                                height: height / 3.5,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    topRight: Radius.circular(25),
                                  ),
                                  color: notifier.backGround,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 25,
                                    right: 25,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppConstants.Height(height / 40),
                                      Row(
                                        children: [
                                          Text(
                                            "Add New Card",
                                            style: TextStyle(
                                              color: notifier.textColor,
                                              fontFamily: "Ariom-Bold",
                                              fontSize: 22,
                                            ),
                                          ),
                                          const Spacer(),
                                          Icon(
                                            Icons.close,
                                            color: notifier.textColor,
                                            size: 30,
                                          ),
                                        ],
                                      ),
                                      AppConstants.Height(height / 40),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Card_Manually(),
                                                ),
                                              );
                                            },
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  child: Image.asset(
                                                    "assets/Manually.png",
                                                    scale: 3,
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: -5,
                                                  left: 0,
                                                  right: 0,
                                                  child: Container(
                                                    height: height / 20,
                                                    width: width / 2.6,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color:
                                                          notifier.backGround,
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Manually",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            "Ariom-Bold",
                                                        color:
                                                            notifier.textColor,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Add_Card(),
                                                ),
                                              );
                                            },
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  child: Image.asset(
                                                    "assets/Scan.png",
                                                    scale: 3,
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: -5,
                                                  left: 0,
                                                  right: 0,
                                                  child: Container(
                                                    height: height / 20,
                                                    width: width / 2.6,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color:
                                                          notifier.backGround,
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Scan",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            "Ariom-Bold",
                                                        color:
                                                            notifier.textColor,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                      /*Navigator.push(context, MaterialPageRoute(builder: (context) => Add_Card(),));*/
                    },
                    child: SizedBox(
                      height: height / 3.8,
                      width: width / 7,
                      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(25),
                        color: const Color(0xffD1E50C),
                        dashPattern: const [5, 5],
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: 10,
                        ),
                        strokeWidth: 2,
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: notifier.textColor,
                              ),
                              AppConstants.Width(width / 50),
                              Text(
                                "Add Card",
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontSize: 22,
                                  fontFamily: 'Ariom-Bold',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  AppConstants.Width(width / 30),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Card_detail(),
                        ),
                      );
                    },
                    child: Container(
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
                                  // crossAxisAlignment: CrossAxisAlignment.end,
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
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            AppConstants.Height(height / 20),
            Text(
              "Recently Used Card",
              style: TextStyle(
                fontSize: 22,
                color: notifier.textColor,
                fontFamily: "Ariom-Bold",
              ),
            ),
            AppConstants.Height(height / 30),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
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
                                // crossAxisAlignment: CrossAxisAlignment.end,
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
                          )
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
                                // crossAxisAlignment: CrossAxisAlignment.end,
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
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
