// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

import '../../config/dark_mode.dart';

class Share_profile extends StatefulWidget {
  const Share_profile({super.key});

  @override
  State<Share_profile> createState() => _Share_profileState();
}

class _Share_profileState extends State<Share_profile> {
  ColorNotifire notifier = ColorNotifire();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
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
          "Compartir perfil",
          style: TextStyle(
            color: notifier.textColor,
            fontSize: 22,
            fontFamily: "Ariom-Bold",
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: height / 3,
            width: double.infinity,
            child: SfBarcodeGenerator(
              value: '',
              symbology: QRCode(),
              showValue: true,
              barColor: notifier.textColor,
            ),
          ),
          Text(
            "Envia tu codigo de amigo.",
            style: TextStyle(
              fontSize: 15,
              color: notifier.textColor,
            ),
          ),
        ],
      ),
    );
  }
}