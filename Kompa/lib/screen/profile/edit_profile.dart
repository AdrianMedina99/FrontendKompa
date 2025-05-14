// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Config/common.dart';
import '../../dark_mode.dart';
import '../Home/bottom.dart';

class Edit_Profile extends StatefulWidget {
  const Edit_Profile({super.key});

  @override
  State<Edit_Profile> createState() => _Edit_ProfileState();
}

class _Edit_ProfileState extends State<Edit_Profile> {
  ColorNotifire notifier = ColorNotifire();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: notifier.backGround,
      resizeToAvoidBottomInset: false,
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
          "Edit Profile",
          style: TextStyle(
            color: notifier.textColor,
            fontSize: 22,
            fontFamily: "Ariom-Bold",
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppConstants.Height(height / 30),
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: height / 5,
                    width: width / 2.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.asset(
                        "assets/Profile.jpeg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: -15,
                    child: Container(
                      height: height / 17,
                      width: width / 5,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffB6B6C0),
                      ),
                      child: Image.asset(
                        "assets/Edit.png",
                        scale: 2.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AppConstants.Height(height / 30),
            Text(
              "Your phone number",
              style: TextStyle(
                color: notifier.textColor,
                fontSize: 20,
                fontFamily: "Ariom-Bold",
              ),
            ),
            AppConstants.Height(height / 30),
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
                keyboardType: TextInputType.number,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Image.asset(
                    "assets/Call.png",
                    scale: 3,
                    color: notifier.textColor,
                  ),
                  hintText: "0123 456 789",
                  hintStyle: TextStyle(
                    color: notifier.textColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            AppConstants.Height(height / 30),
            Text(
              "Name",
              style: TextStyle(
                color: notifier.textColor,
                fontSize: 20,
                fontFamily: "Ariom-Bold",
              ),
            ),
            AppConstants.Height(height / 30),
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
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Image.asset(
                    "assets/Profile Bottom.png",
                    scale: 3,
                    color: notifier.textColor,
                  ),
                  hintText: "Andrew",
                  hintStyle: TextStyle(
                    color: notifier.textColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
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
              "Save changes",
              style: TextStyle(
                fontSize: 20,
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
