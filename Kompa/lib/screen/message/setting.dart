// ignore_for_file: file_names, camel_case_types

import 'package:kompa/Config/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dark_mode.dart';

class Message_setting extends StatefulWidget {
  final String image;
  final String name;

  const Message_setting({super.key, required this.image, required this.name});

  @override
  State<Message_setting> createState() => _Message_settingState();
}

class _Message_settingState extends State<Message_setting> {
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
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppConstants.Height(height / 30),
            Center(
              child: Container(
                height: height / 8,
                width: width / 4.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.asset(
                  widget.image,
                  scale: 5,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            AppConstants.Height(height / 30),
            Center(
              child: Text(
                widget.name,
                style:  TextStyle(
                  fontSize: 20,
                  color: notifier.textColor,
                  fontFamily: "Ariom-Bold",
                ),
              ),
            ),
            AppConstants.Height(height / 10),
            Row(
              children: [
                Image.asset(
                  "assets/Profile Bottom.png",
                  scale: 3,
                  color: notifier.textColor,
                ),
                AppConstants.Width(width / 40),
                 Text(
                  "Profile",
                  style: TextStyle(
                    color: notifier.textColor,
                    fontSize: 17,
                    fontFamily: "Ariom-Bold",
                  ),
                ),
              ],
            ),
            AppConstants.Height(height / 15),
            Row(
              children: [
                Image.asset(
                  "assets/notification.png",
                  scale: 3,
                  color: notifier.textColor,
                ),
                AppConstants.Width(width / 40),
                 Text(
                  "Mute",
                  style: TextStyle(
                    fontSize: 17,
                    color: notifier.textColor,
                    fontFamily: "Ariom-Bold",
                  ),
                ),
              ],
            ),
            AppConstants.Height(height / 15),
            Row(
              children: [
                Image.asset(
                  "assets/Lock.png",
                  scale: 3,
                  color: notifier.textColor,
                ),
                AppConstants.Width(width / 40),
                 Text(
                  "Privacy and Safety",
                  style: TextStyle(
                    color: notifier.textColor,
                    fontSize: 17,
                    fontFamily: "Ariom-Bold",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
