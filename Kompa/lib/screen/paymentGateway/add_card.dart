// ignore_for_file: file_names, camel_case_types

import 'package:kompa/config/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import '../../config/dark_mode.dart';

class Add_Card extends StatefulWidget {
  const Add_Card({super.key});

  @override
  State<Add_Card> createState() => _Add_CardState();
}

class _Add_CardState extends State<Add_Card> {
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
          "Add New Card",
          style: TextStyle(
            color: notifier.textColor,
            fontSize: 20,
            fontFamily: "Ariom-Bold",
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppConstants.Height(height / 30),
            Text(
              "Show the front of the card",
              style: TextStyle(
                color: notifier.textColor,
                fontSize: 20,
                fontFamily: "Ariom-Bold",
              ),
            ),
            AppConstants.Height(height / 10),
            SizedBox(
              height: height / 2,
              width: double.infinity,
              child: SfBarcodeGenerator(
                value: '',
                symbology: QRCode(),
                showValue: true,
                barColor: notifier.textColor,
              ),
            ),
            AppConstants.Height(height / 20),
            Container(
              height: height / 16,
              width: width / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: notifier.textColor,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/Info-circle.png",
                      scale: 3,
                      color: notifier.backGround,
                    ),
                    AppConstants.Width(width / 40),
                    Text(
                      "Support issue",
                      style: TextStyle(
                        color: notifier.backGround,
                        fontSize: 16,
                        fontFamily: "Ariom-Bold",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
