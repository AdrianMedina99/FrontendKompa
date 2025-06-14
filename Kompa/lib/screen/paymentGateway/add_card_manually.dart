// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

import 'package:kompa/config/AppConstants.dart';
import '../common/BottomScreen.dart';
import '../../config/dark_mode.dart';

class Card_Manually extends StatefulWidget {
  const Card_Manually({super.key});

  @override
  State<Card_Manually> createState() => _Card_ManuallyState();
}

class _Card_ManuallyState extends State<Card_Manually> {
  ColorNotifire notifier = ColorNotifire();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: notifier.backGround,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: notifier.backGround,
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
          "Add New Card",
          style: TextStyle(
            fontSize: 22,
            color: notifier.textColor,
            fontFamily: "Arion-Bold",
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: SizedBox(
              height: height / 12,
              width: width / 9,
              child: SfBarcodeGenerator(
                value: '',
                symbology: QRCode(),
                showValue: true,
                barColor: notifier.textColor,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppConstants.Height(height / 30),
              Center(
                child: Container(
                  height: height / 3.8,
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
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
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
              ),
              AppConstants.Height(height / 30),
              Text(
                "Name on Card",
                style: TextStyle(
                  fontSize: 20,
                  color: notifier.textColor,
                  fontFamily: "Ariom-Bold",
                ),
              ),
              AppConstants.Height(height / 50),
              Container(
                alignment: Alignment.center,
                height: height / 13,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: notifier.textColor,
                  ),
                ),
                child: TextField(
                  style: TextStyle(
                    color: notifier.textColor,
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Image.asset(
                      "assets/Profile Bottom.png",
                      scale: 3,
                      color: notifier.textColor,
                    ),
                    hintText: "HanSho",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: notifier.textColor,
                    ),
                  ),
                ),
              ),
              AppConstants.Height(height / 50),
              Text(
                "Number Card ",
                style: TextStyle(
                  fontSize: 20,
                  color: notifier.textColor,
                  fontFamily: "Ariom-Bold",
                ),
              ),
              AppConstants.Height(height / 50),
              Container(
                alignment: Alignment.center,
                height: height / 13,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: notifier.textColor,
                  ),
                ),
                child: TextField(
                  style: TextStyle(
                    color: notifier.textColor,
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Image.asset(
                      "assets/card.png",
                      scale: 3,
                      color: notifier.textColor,
                    ),
                    hintText: "1233 1234 5242 1243",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: notifier.textColor,
                    ),
                  ),
                ),
              ),
              AppConstants.Height(height / 50),
              Row(
                children: [
                  Text(
                    "CVV",
                    style: TextStyle(
                      fontSize: 20,
                      color: notifier.textColor,
                      fontFamily: "Ariom-Bold",
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "Expired Date",
                    style: TextStyle(
                      fontSize: 20,
                      color: notifier.textColor,
                      fontFamily: "Ariom-Bold",
                    ),
                  ),
                ],
              ),
              AppConstants.Height(height / 50),
              Row(
                children: [
                  Container(
                    height: height / 13,
                    width: width / 2.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: notifier.textColor,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextField(
                        style: TextStyle(
                          color: notifier.textColor,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "1234",
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: notifier.textColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: height / 13,
                    width: width / 2.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: notifier.textColor,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextField(
                        style: TextStyle(color: notifier.textColor),
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "22 / 12",
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: notifier.textColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              AppConstants.Height(height / 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomBarScreen(),
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
              "Add New Card",
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
