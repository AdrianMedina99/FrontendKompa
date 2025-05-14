// ignore_for_file: file_names, camel_case_types

import 'package:kompa/Config/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:provider/provider.dart';

import '../Home/bottom.dart';
import '../../dark_mode.dart';

class New_password extends StatefulWidget {
  const New_password({super.key});

  @override
  State<New_password> createState() => _New_passwordState();
}

class _New_passwordState extends State<New_password> {
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
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              "assets/arrow-left.png",
              scale: 2.5,
              color: notifier.textColor,
            ),
          ),
        ),
        title: Text(
          "New Password",
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Ariom-Bold",
            color: notifier.textColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppConstants.Height(height / 30),
            Text(
              "Enter password",
              style: TextStyle(
                color: notifier.textColor,
                fontFamily: "Ariom-Bold",
                fontSize: 20,
              ),
            ),
            AppConstants.Height(height / 50),
            OtpTextField(
              textStyle: TextStyle(
                fontSize: 30,
                fontFamily: "Ariom-Bold",
                color: notifier.textColor,
              ),
              numberOfFields: 6,
              focusedBorderColor: const Color(0xffD1E50C),
              showFieldAsBox: false,
              borderWidth: 2,
              keyboardType: TextInputType.number,
              clearText: true,
              obscureText: true,
              enabledBorderColor: notifier.onBoardTextColor,
              fieldWidth: width / 9,
              margin: const EdgeInsets.only(left: 7, right: 7),
              onCodeChanged: (String code) {},
              onSubmit: (String verificationCode) {},
            ),
            AppConstants.Height(height / 30),
            Text(
              "Confirm password",
              style: TextStyle(
                color: notifier.textColor,
                fontFamily: "Ariom-Bold",
                fontSize: 20,
              ),
            ),
            AppConstants.Height(height / 50),
            OtpTextField(
              textStyle: TextStyle(
                fontSize: 30,
                fontFamily: "Ariom-Bold",
                color: notifier.textColor,
              ),
              numberOfFields: 6,
              focusedBorderColor: const Color(0xffD1E50C),
              showFieldAsBox: false,
              borderWidth: 2,
              keyboardType: TextInputType.number,
              clearText: true,
              obscureText: true,
              enabledBorderColor: notifier.onBoardTextColor,
              fieldWidth: width / 9,
              margin: const EdgeInsets.only(left: 7, right: 7),
              onCodeChanged: (String code) {},
              onSubmit: (String verificationCode) {},
            ),
            AppConstants.Height(height / 10),
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
                height: height / 13,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xffD1E50C),
                ),
                child: const Center(
                  child: Text(
                    "Confirm",
                    style: TextStyle(
                      color: Color(0xff131313),
                      fontSize: 25,
                      fontFamily: "Ariom-Bold",
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
