// ignore_for_file: camel_case_types

import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

import '../../Config/common.dart';
import '../../dark_mode.dart';
import '../category/ticket_detail.dart';
import 'bottom.dart';

class ticket extends StatefulWidget {
  const ticket({super.key});

  @override
  State<ticket> createState() => _ticketState();
}

class _ticketState extends State<ticket> {
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
        automaticallyImplyLeading: false,
        title: Text(
          "Your Tickets",
          style: TextStyle(
            color: notifier.textColor,
            fontSize: 20,
            fontFamily: "Ariom-Bold",
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BottomBarScreen(),
                ),
              );
            },
            child: Image.asset(
              "assets/Home 1.png",
              scale: 3,
              color: notifier.textColor,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppConstants.Height(height / 16),
              carousel.CarouselSlider(
                items: [
                  Center(
                    child: Container(
                      height: height / 1,
                      // width: width/2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        border: Border.all(
                          color: notifier.textColor,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // AppConstants.Height(height / 90),
                            Center(
                              child: Container(
                                height: height / 4,
                                // width: width/2
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.asset(
                                      "assets/Space Event.png",
                                      fit: BoxFit.cover,
                                      width: width / 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // AppConstants.Height(height / 80),
                            Text(
                              "Glowing Art Performance",
                              style: TextStyle(
                                fontSize: 20,
                                color: notifier.textColor,
                                fontFamily: "Ariom-Bold",
                              ),
                            ),
                            AppConstants.Height(height / 60),
                            const DottedLine(
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.center,
                              lineLength: double.infinity,
                              lineThickness: 2,
                              dashLength: 2,
                              dashColor: Colors.white,
                              dashGapLength: 7,
                              dashGapColor: Colors.black,
                              dashGapRadius: 0.0,
                            ),
                            AppConstants.Height(height / 50),
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
                            AppConstants.Height(height / 60),
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
                            AppConstants.Height(height / 50),
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
                            AppConstants.Height(height / 40),
                            SizedBox(
                              height: 40,
                              width: double.infinity,
                              child: SfBarcodeGenerator(
                                value: '                ',
                                symbology: Code128B(),
                                showValue: true,
                                barColor: notifier.textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: height / 1,
                      // width: width/2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        border: Border.all(
                          color: notifier.textColor,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // AppConstants.Height(height / 70),
                            Center(
                              child: Container(
                                height: height / 4,
                                // width: width/2
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.asset(
                                      "assets/Space Event.png",
                                      fit: BoxFit.cover,
                                      width: width / 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // AppConstants.Height(height / 60),
                            Text(
                              "Glowing Art Performance1",
                              style: TextStyle(
                                fontSize: 20,
                                color: notifier.textColor,
                                fontFamily: "Ariom-Bold",
                              ),
                            ),
                            AppConstants.Height(height / 60),
                            const DottedLine(
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.center,
                              lineLength: double.infinity,
                              lineThickness: 2,
                              dashLength: 2,
                              dashColor: Colors.white,
                              dashGapLength: 7,
                              dashGapColor: Colors.black,
                              dashGapRadius: 0.0,
                            ),
                            AppConstants.Height(height / 50),
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
                            AppConstants.Height(height / 60),
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
                            AppConstants.Height(height / 50),
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
                            AppConstants.Height(height / 40),
                            SizedBox(
                              height: 40,
                              width: double.infinity,
                              child: SfBarcodeGenerator(
                                value: '                ',
                                symbology: Code128B(),
                                showValue: true,
                                barColor: notifier.textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: height / 1,
                      // width: width/2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(35),
                        border: Border.all(
                          color: notifier.textColor,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // AppConstants.Height(height / 70),
                            Center(
                              child: Container(
                                height: height / 4,
                                // width: width/2
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image.asset(
                                      "assets/Space Event.png",
                                      fit: BoxFit.contain,
                                      width: width / 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // AppConstants.Height(height / 60),
                            Text(
                              "Glowing Art Performance",
                              style: TextStyle(
                                fontSize: 20,
                                color: notifier.textColor,
                                fontFamily: "Ariom-Bold",
                              ),
                            ),
                            AppConstants.Height(height / 60),
                            const DottedLine(
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.center,
                              lineLength: double.infinity,
                              lineThickness: 2,
                              dashLength: 2,
                              dashColor: Colors.white,
                              dashGapLength: 7,
                              dashGapColor: Colors.black,
                              dashGapRadius: 0.0,
                            ),
                            AppConstants.Height(height / 50),
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
                            AppConstants.Height(height / 60),
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
                            AppConstants.Height(height / 50),
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
                            AppConstants.Height(height / 40),
                            SizedBox(
                              height: 40,
                              width: double.infinity,
                              child: SfBarcodeGenerator(
                                value: '                ',
                                symbology: Code128B(),
                                showValue: true,
                                barColor: notifier.textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
                options: carousel.CarouselOptions(
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 1 / 1.4,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                ),
              ),
              AppConstants.Height(height / 25),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Ticket_Detail(),
                    ),
                  );
                },
                child: Container(
                  height: height / 13,
                  width: width / 1.5,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    color: Color(0xffD1E50C),
                  ),
                  child: const Center(
                    child: Text(
                      "Ticket Detail",
                      style: TextStyle(
                        color: Color(0xff131313),
                        fontFamily: "Ariom-Bold",
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              AppConstants.Height(height / 16),
            ],
          ),
        ),
      ),
    );
  }
}
