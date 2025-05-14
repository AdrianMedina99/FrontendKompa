// ignore_for_file: file_names, camel_case_types

import 'package:kompa/Config/common.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import '../../dark_mode.dart';
import 'scan_qr.dart';

class Add_Friend extends StatefulWidget {
  const Add_Friend({super.key});

  @override
  State<Add_Friend> createState() => _Add_FriendState();
}

class _Add_FriendState extends State<Add_Friend> {
  ColorNotifire notifier = ColorNotifire();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          "Add Friend",
          style: TextStyle(
            color: notifier.textColor,
            fontSize: 20,
            fontFamily: 'Ariom-Bold',
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Scan_QR(),
                ),
              );
            },
            child: Image.asset(
              "assets/Scan 1.png",
              scale: 3,
              color: notifier.textColor,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            AppConstants.Height(height / 20),
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
              "Send code to your friends to make friends.",
              style: TextStyle(
                fontFamily: "Averta-Regular",
                fontSize: 15,
                color: notifier.textColor,
              ),
            ),
            AppConstants.Height(height / 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: height / 13,
                  width: width / 1.3,
                  child: IntlPhoneField(
                    showDropdownIcon: false,

                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: notifier.textColor),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    textAlignVertical: TextAlignVertical.bottom,
                    dropdownTextStyle: TextStyle(
                      color: notifier.textColor,
                    ),
                    // showDropdownIcon: true,
                    style: TextStyle(
                      color: notifier.textColor,
                      fontFamily: "Ariom-Bold",
                    ),
                    onChanged: (phone) {
                    },
                  ),
                ),
                Container(
                  height: height / 15,
                  width: width / 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: notifier.textColor,
                  ),
                  child: Image.asset(
                    "assets/Next.png",
                    scale: 2.6,
                    color: notifier.imageColor,
                  ),
                ),
              ],
            ),
            AppConstants.Height(height / 20),
            Container(
              height: height / 13,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
                border: Border.all(
                  color: notifier.textColor,
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Image.asset(
                      "assets/Profile Bottom.png",
                      scale: 3,
                      color: notifier.textColor,
                    ),
                  ),
                  AppConstants.Width(width / 10),
                  Text(
                    "Phonebook",
                    style: TextStyle(
                      color: notifier.textColor,
                      fontSize: 17,
                      fontFamily: "Ariom-Bold",
                    ),
                  )
                ],
              ),
            ),
            AppConstants.Height(height / 30),
            Container(
              height: height / 13,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
                border: Border.all(
                  color: notifier.textColor,
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding:const EdgeInsets.only(left: 20),
                    child: Image.asset(
                      "assets/People.png",
                      scale: 3,
                      color: notifier.textColor,
                    ),
                  ),
                  AppConstants.Width(width / 10),
                  Text(
                    "Friends may know",
                    style: TextStyle(
                      color: notifier.textColor,
                      fontSize: 17,
                      fontFamily: "Ariom-Bold",
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
