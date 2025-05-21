// ignore_for_file: file_names, camel_case_types

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

import '../../Config/common.dart';
import '../Home/bottom.dart';
import '../Home/map.dart';
import '../../dark_mode.dart';

class Ticket_Detail extends StatefulWidget {
  const Ticket_Detail({super.key});

  @override
  State<Ticket_Detail> createState() => _Ticket_DetailState();
}

class _Ticket_DetailState extends State<Ticket_Detail> {
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
          ),
        ),
        title: Text(
          "Ticket Detail",
          style: TextStyle(
            fontSize: 22,
            fontFamily: "Ariom-Bold",
            color: notifier.textColor,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: notifier.backGround,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  actionsPadding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 10,
                  ),
                  titlePadding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                  ),
                  contentPadding: const EdgeInsets.all(20),
                  title: Text(
                    "Do you want to remove the ticket?",
                    style: TextStyle(
                      fontSize: 20,
                      color: notifier.textColor,
                      fontFamily: "Ariom-Bold",
                    ),
                  ),
                  content: Text(
                    "When you delete your ticket, you will lose your ticket and no refund will be given. Do you still want to delete it?",
                    style: TextStyle(
                      color: notifier.subtitleTextColor,
                      fontSize: 14,
                    ),
                  ),
                  actions: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: height / 16,
                            width: width / 3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: notifier.textColor,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontSize: 16,
                                  fontFamily: "Ariom-Bold",
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BottomBarScreen(),
                              ),
                            );
                          },
                          child: Container(
                            clipBehavior: Clip.none,
                            height: height / 16,
                            width: width / 3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color(0xffD1E50C),
                            ),
                            child: const Center(
                              child: Text(
                                "Continue",
                                style: TextStyle(
                                  color: Color(0xff121212),
                                  fontFamily: "Ariom-Bold",
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
            child: Image.asset(
              "assets/Delete.png",
              scale: 3,
              color: notifier.textColor,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  height: height / 1.4,
                  // width: width/2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(
                      color: notifier.textColor,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppConstants.Height(height / 50),
                        Center(
                          child: Container(
                            height: height / 4,
                            // width: width/2
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(35),
                                child: Image.asset(
                                  "assets/ticket details.jpg",
                                  fit: BoxFit.cover,
                                  width: width / 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                        AppConstants.Height(height / 40),
                        Text(
                          "Glowing Art Performance",
                          style: TextStyle(
                            fontSize: 22,
                            color: notifier.textColor,
                            fontFamily: "Ariom-Bold",
                          ),
                        ),
                        AppConstants.Height(height / 40),
                        const DottedLine(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.center,
                          lineLength: double.infinity,
                          lineThickness: 2,
                          dashLength: 3,
                          dashColor: Colors.white,
                          dashGapLength: 7,
                          dashGapColor: Colors.black,
                          dashGapRadius: 0.0,
                        ),
                        AppConstants.Height(height / 40),
                        Row(
                          children: [
                            Text(
                              "Date",
                              style: TextStyle(
                                fontSize: 15,
                                color: notifier.subtitleTextColor,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "Time",
                              style: TextStyle(
                                fontSize: 15,
                                color: notifier.subtitleTextColor,
                              ),
                            ),
                          ],
                        ),
                        AppConstants.Height(height / 50),
                        Row(
                          children: [
                            Text(
                              "23 . 06 . 2023",
                              style: TextStyle(
                                fontSize: 15,
                                color: notifier.textColor,
                                fontFamily: "Ariom-Bold",
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "22 : 00 PM",
                              style: TextStyle(
                                fontSize: 15,
                                color: notifier.textColor,
                                fontFamily: "Ariom-Bold",
                              ),
                            ),
                          ],
                        ),
                        AppConstants.Height(height / 60),
                        Row(
                          children: [
                            Text(
                              "Gate",
                              style: TextStyle(
                                fontSize: 15,
                                color: notifier.subtitleTextColor,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "Seat",
                              style: TextStyle(
                                fontSize: 15,
                                color: notifier.subtitleTextColor,
                              ),
                            ),
                          ],
                        ),
                        AppConstants.Height(height / 60),
                        Row(
                          children: [
                            Text(
                              "Zephyrus",
                              style: TextStyle(
                                fontSize: 15,
                                color: notifier.textColor,
                                fontFamily: "Ariom-Bold",
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "F1 - Festival 1",
                              style: TextStyle(
                                fontSize: 15,
                                color: notifier.textColor,
                                fontFamily: "Ariom-Bold",
                              ),
                            ),
                          ],
                        ),
                        AppConstants.Height(height / 60),
                        const DottedLine(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.center,
                          lineLength: double.infinity,
                          lineThickness: 2,
                          dashLength: 3,
                          dashColor: Colors.white,
                          dashGapLength: 7,
                          dashGapColor: Colors.black,
                        ),
                        AppConstants.Height(height / 60),
                        SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: SfBarcodeGenerator(
                            value: '                      ',
                            symbology: Code128B(),
                            barColor: notifier.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const map(),
            ),
          );
        },
        child: Container(
          height: height / 11,
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            color: Color(0xffD1E50C),
          ),
          child: const Center(
            child: Text(
              "Direction",
              style: TextStyle(
                fontSize: 22,
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
