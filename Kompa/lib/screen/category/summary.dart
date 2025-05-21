// ignore_for_file: file_names

import 'package:dotted_line/dotted_line.dart';
import 'package:kompa/Config/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dark_mode.dart';
import '../home/ticket.dart';
import '../voucher/payment_method.dart';
import '../voucher/voucher.dart';

class Summary extends StatefulWidget {
  const Summary({super.key});

  @override
  State<Summary> createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  int filter = 0;
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
          "Summary",
          style: TextStyle(
            fontSize: 20,
            color: notifier.textColor,
            fontFamily: "Ariom-Bold",
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: height / 1.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: notifier.textColor,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            Container(
                              height: height / 15,
                              width: width / 8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                image: const DecorationImage(
                                  image: AssetImage("assets/Splash 1.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            AppConstants.Width(width / 40),
                            Text(
                              "Glowing Art Performance",
                              style: TextStyle(
                                fontSize: 18,
                                color: notifier.textColor,
                                fontFamily: "Ariom-Bold",
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppConstants.Height(height / 60),
                      Divider(
                        color: notifier.textColor,
                        thickness: 0.5,
                      ),
                      AppConstants.Height(height / 70),
                      Text(
                        "Time",
                        style: TextStyle(
                          color: notifier.subtitleTextColor,
                          fontSize: 12,
                        ),
                      ),
                      AppConstants.Height(height / 70),
                      Text(
                        "20 : 00 PM",
                        style: TextStyle(
                          color: notifier.textColor,
                          fontSize: 12,
                          fontFamily: "Ariom-Bold",
                        ),
                      ),
                      AppConstants.Height(height / 70),
                      Text(
                        "Location",
                        style: TextStyle(
                          color: notifier.subtitleTextColor,
                          fontSize: 12,
                        ),
                      ),
                      AppConstants.Height(height / 70),
                      Text(
                        "Korean",
                        style: TextStyle(
                          color: notifier.textColor,
                          fontSize: 12,
                          fontFamily: "Ariom-Bold",
                        ),
                      ),
                      AppConstants.Height(height / 70),
                      Text(
                        "Seats",
                        style: TextStyle(
                          color: notifier.subtitleTextColor,
                          fontSize: 12,
                        ),
                      ),
                      AppConstants.Height(height / 70),
                      Row(
                        children: [
                          Text(
                            "F1",
                            style: TextStyle(
                              color: notifier.textColor,
                              fontSize: 12,
                              fontFamily: "Ariom-Bold",
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "50.00\$",
                            style: TextStyle(
                              color: notifier.textColor,
                              fontSize: 12,
                              fontFamily: "Ariom-Bold",
                            ),
                          ),
                        ],
                      ),
                      AppConstants.Height(height / 70),
                      Row(
                        children: [
                          Text(
                            "2 - F2",
                            style: TextStyle(
                              color: notifier.textColor,
                              fontSize: 12,
                              fontFamily: "Ariom-Bold",
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "100.00\$",
                            style: TextStyle(
                              color: notifier.textColor,
                              fontSize: 12,
                              fontFamily: "Ariom-Bold",
                            ),
                          ),
                        ],
                      ),
                      AppConstants.Height(height / 70),
                      Row(
                        children: [
                          Text(
                            "3 - F3",
                            style: TextStyle(
                              color: notifier.textColor,
                              fontSize: 12,
                              fontFamily: "Ariom-Bold",
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "150.00\$",
                            style: TextStyle(
                              color: notifier.textColor,
                              fontSize: 12,
                              fontFamily: "Ariom-Bold",
                            ),
                          ),
                        ],
                      ),
                      AppConstants.Height(height / 50),
                      Text(
                        "Name",
                        style: TextStyle(
                          color: notifier.subtitleTextColor,
                          fontSize: 12,
                        ),
                      ),
                      AppConstants.Height(height / 70),
                      Text(
                        "Andrew",
                        style: TextStyle(
                          color: notifier.textColor,
                          fontSize: 12,
                          fontFamily: "Ariom-Bold",
                        ),
                      ),
                      AppConstants.Height(height / 70),
                      Text(
                        "Phone Number",
                        style: TextStyle(
                          color: notifier.subtitleTextColor,
                          fontSize: 12,
                        ),
                      ),
                      AppConstants.Height(height / 70),
                      Text(
                        "0123 456 789",
                        style: TextStyle(
                          color: notifier.textColor,
                          fontSize: 12,
                          fontFamily: "Ariom-Bold",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppConstants.Height(height / 40),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Voucher(),
                    ),
                  );
                  setState(
                    () {
                      filter = 0;
                    },
                  );
                },
                child: Container(
                  height: height / 13,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: filter == 0 ? Colors.yellow : notifier.textColor,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          "assets/Ticket.png",
                          scale: 3,
                          color: notifier.textColor,
                        ),
                        AppConstants.Width(width / 40),
                        Text(
                          "ABCD12",
                          style: TextStyle(
                            fontSize: 14,
                            color: notifier.textColor,
                            fontFamily: "Ariom-Bold",
                          ),
                        ),
                        const Spacer(),
                        Image.asset(
                          "assets/arrow-right.png",
                          scale: 3,
                          color: notifier.textColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AppConstants.Height(height / 40),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Payment_method(),
                    ),
                  );
                  setState(() {
                    filter = 1;
                  });
                },
                child: Container(
                  height: height / 13,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: filter == 1 ? Colors.yellow : notifier.textColor,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          "assets/card.png",
                          scale: 3,
                          color: notifier.textColor,
                        ),
                        AppConstants.Width(width / 40),
                        Text(
                          "Payment by card",
                          style: TextStyle(
                            fontSize: 14,
                            color: notifier.textColor,
                            fontFamily: "Ariom-Bold",
                          ),
                        ),
                        const Spacer(),
                        Image.asset(
                          "assets/arrow-right.png",
                          scale: 3,
                          color: notifier.textColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              AppConstants.Height(height / 40),
              Container(
                height: height / 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  color: notifier.textColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Sub Total",
                            style: TextStyle(
                              color: notifier.backGround,
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "\$300.00",
                            style: TextStyle(
                              color: notifier.backGround,
                              fontSize: 16,
                              fontFamily: "Ariom-Bold",
                            ),
                          ),
                        ],
                      ),
                      AppConstants.Height(height / 70),
                      Row(
                        children: [
                          Text(
                            "Discount",
                            style: TextStyle(
                              color: notifier.backGround,
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "-\$10.00",
                            style: TextStyle(
                              color: notifier.imageColor,
                              fontSize: 16,
                              fontFamily: "Ariom-Bold",
                            ),
                          ),
                        ],
                      ),
                      AppConstants.Height(height / 30),
                      DottedLine(
                        lineLength: 350,
                        dashColor: notifier.backGround,
                      ),
                      AppConstants.Height(height / 70),
                      Row(
                        children: [
                          Text(
                            "Total Price",
                            style: TextStyle(
                              color: notifier.backGround,
                              fontSize: 20,
                              fontFamily: "Ariom-Bold",
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "\$290.00",
                            style: TextStyle(
                              color: notifier.backGround,
                              fontSize: 20,
                              fontFamily: "Ariom-Bold",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ticket(),
            ),
          );
        },
        child: Container(
          height: height / 10,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(25),
              topLeft: Radius.circular(25),
            ),
            color: Color(0xffD1E50C),
          ),
          child: const Center(
            child: Text(
              "Pay Now",
              style: TextStyle(
                color: Color(0xff131313),
                fontFamily: "Ariom-Bold",
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
