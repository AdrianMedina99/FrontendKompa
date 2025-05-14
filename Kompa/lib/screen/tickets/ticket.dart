// ignore_for_file: file_names, camel_case_types


import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:dotted_line/dotted_line.dart';
import 'package:kompa/Config/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import '../../dark_mode.dart';
import 'ticket_detail.dart';

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
        backgroundColor: notifier.backGround,
        elevation: 0,
        centerTitle: true,
        leading: Image.asset(
          "assets/arrow-left.png",
          color: notifier.textColor,
          scale: 3,
        ),
        title: Text(
          "Your Tickets",
          style: TextStyle(
            fontSize: 22,
            fontFamily: "Ariom-Bold",
            color: notifier.textColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppConstants.Height(height / 30),
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
                        padding:  const EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppConstants.Height(10),
                            Center(
                              child: Container(
                                height: height / 4,
                                // width: width/2
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image.asset(
                                      "assets/Concert 1.png",
                                      fit: BoxFit.cover,
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
                              // dashGradient: [Colors.red, Colors.blue],
                              dashGapLength: 7,
                              dashGapColor: Colors.black,
                              // dashGapGradient: [Colors.red, Colors.blue],
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
                                )
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
                                )
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
                                )
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
                                )
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
                              // dashGradient: [Colors.red, Colors.blue],
                              dashGapLength: 7,
                              dashGapColor: Colors.black,
                              // dashGapGradient: [Colors.red, Colors.blue],
                            ),
                            AppConstants.Height(height / 60),
                            SizedBox(
                              height: 40,
                              width: double.infinity,
                              child: SfBarcodeGenerator(
                                value: '                ',
                                symbology: Code128B(),
                                showValue: true,
                                barColor: notifier.textColor,
                              ),
                            )
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
                        padding:  const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppConstants.Height(10),
                            Center(
                              child: Container(
                                height: height / 4,
                                // width: width/2
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image.asset(
                                      "assets/Concert 3.jpg",
                                      fit: BoxFit.cover,
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
                                )
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
                                )
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
                                )
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
                                )
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
                              height: 40,
                              width: double.infinity,
                              child: SfBarcodeGenerator(
                                value: '                ',
                                symbology: Code128B(),
                                showValue: true,
                                barColor: notifier.textColor,
                              ),
                            )
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
                        padding:  const EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppConstants.Height(10),
                            Center(
                              child: Container(
                                height: height / 4,
                                // width: width/2
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image.asset(
                                      "assets/Concert 1.png",
                                      fit: BoxFit.cover,
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
                                )
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
                                )
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
                                )
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
                                )
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
                              height: 40,
                              width: double.infinity,
                              child: SfBarcodeGenerator(
                                value: '                ',
                                symbology: Code128B(),
                                showValue: true,
                                barColor: notifier.textColor,
                              ),
                            )
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
                  autoPlayAnimationDuration:const Duration(milliseconds: 800),
                  viewportFraction: 0.9,
                ),
              ),
              AppConstants.Height(height / 20),
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
                  height: height / 15,
                  width: width / 1.7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xffD1E50C),
                  ),
                  child: const Center(
                    child: Text(
                      "Ticket Detail",
                      style: TextStyle(
                        fontFamily: "Ariom-Bold",
                        color: Color(0xff131313),
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              // AppConstants.Height(height / 90),
            ],
          ),
        ),
      ),
    );
  }
}
