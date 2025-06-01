// ignore_for_file: file_names, camel_case_types

import 'package:kompa/config/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/dark_mode.dart';
import 'call.dart';
import 'setting.dart';

class Message_detail extends StatefulWidget {
  final String image;
  final String name;

  const Message_detail({
    super.key,
    required this.image,
    required this.name,
  });

  @override
  State<Message_detail> createState() => _Message_detailState();
}

class _Message_detailState extends State<Message_detail> {
  ColorNotifire notifier = ColorNotifire();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: notifier.backGround,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: notifier.backGround,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                "assets/arrow-left.png",
                scale: 3,
                color: notifier.textColor,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Message_setting(
                      image: widget.image,
                      name: widget.name,
                    ),
                  ),
                );
              },
              child: Container(
                alignment: Alignment.center,
                height: height / 17,
                width: width / 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(widget.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Text(
              widget.name,
              style: TextStyle(
                fontSize: 20,
                color: notifier.textColor,
                fontFamily: "Ariom-Bold",
              ),
            ),
          ],
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => call(
                    image: widget.image,
                    name: widget.name,
                  ),
                ),
              );
            },
            child: Image.asset(
              "assets/Call.png",
              scale: 3,
              color: notifier.textColor,
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
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppConstants.Height(height / 30),
              Center(
                child: Text(
                  "today, Jul 10",
                  style: TextStyle(
                    fontSize: 15,
                    color: notifier.textColor,
                  ),
                ),
              ),
              AppConstants.Height(height / 30),
              Container(
                height: height / 15,
                width: width / 2,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  color: notifier.textColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hey! Cool picture 🙃 where is that?",
                        style: TextStyle(
                          color: notifier.backGround,
                          fontSize: 16,
                          fontFamily: "Areta-Regular",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppConstants.Height(height / 90),
              Text(
                "14:45",
                style: TextStyle(
                  fontSize: 15,
                  color: notifier.subtitleTextColor,
                  fontFamily: "Areta-Regular",
                ),
              ),
              AppConstants.Height(height / 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: height / 14,
                    width: width / 1.7,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      ),
                      color: Color(0xffB6B6C0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 7,
                      ),
                      child: Text(
                        "Hi! I recently traveled through Quang Ninh and there were views like this",
                        style: TextStyle(
                          color: notifier.textColor,
                          fontSize: 16,
                          fontFamily: "Areta-Regular",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              AppConstants.Height(height / 90),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "14:46",
                    style: TextStyle(
                      fontSize: 15,
                      color: notifier.subtitleTextColor,
                      fontFamily: "Areta-Regular",
                    ),
                  ),
                ],
              ),
              AppConstants.Height(height / 30),
              Container(
                height: height / 15.5,
                width: width / 1.7,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  color: notifier.textColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 20,
                    top: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "yeah! I love to travel too 😊",
                        style: TextStyle(
                          color: notifier.backGround,
                          fontSize: 16,
                          fontFamily: "Areta-Regular",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppConstants.Height(height / 90),
              Text(
                "14:45",
                style: TextStyle(
                  fontSize: 15,
                  color: notifier.subtitleTextColor,
                  fontFamily: "Areta-Regular",
                ),
              ),
              AppConstants.Height(height / 30),
              Container(
                height: height / 15,
                width: width / 1.5,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  color: notifier.textColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 20,
                    top: 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "listen, tell me. Where have you been recently?",
                        style: TextStyle(
                          color: notifier.backGround,
                          fontSize: 16,
                          fontFamily: "Areta-Regular",
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              AppConstants.Height(height / 90),
              Text(
                "14:45",
                style: TextStyle(
                  fontSize: 15,
                  color: notifier.subtitleTextColor,
                  fontFamily: "Areta-Regular",
                ),
              ),
              AppConstants.Height(height / 10),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        color: notifier.backGround,
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Image.asset(
            "assets/Link.png",
            scale: 3,
            color: notifier.textColor,
          ),
          title: Container(
            height: height / 13,
            width: width / 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xffFDFEF3),
            ),
            child: const Padding(
              padding: EdgeInsets.only(
                top: 6,
                left: 10,
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Type your text here",
                  hintStyle: TextStyle(
                    color: Color(0xff6C6D80),
                  ),
                ),
              ),
            ),
          ),
          trailing: Container(
            height: height / 14,
            width: width / 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: notifier.textColor,
            ),
            child: Center(
              child: Image.asset(
                "assets/Send.png",
                scale: 3,
                color: notifier.imageColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
