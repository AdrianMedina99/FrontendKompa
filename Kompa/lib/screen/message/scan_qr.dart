// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../dark_mode.dart';


class Scan_QR extends StatefulWidget {
  const Scan_QR({super.key});

  @override
  State<Scan_QR> createState() => _Scan_QRState();
}

class _Scan_QRState extends State<Scan_QR> {
  ColorNotifire notifier = ColorNotifire();
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
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
            scale: 3,color: notifier.textColor,
          ),
        ),
        title: Text(
          "Scan QR",
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Ariom-Bold",
            color: notifier.textColor,
          ),
        ),
      ),
    );
  }
}
