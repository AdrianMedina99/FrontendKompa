// ignore_for_file: file_names, camel_case_types

import 'package:kompa/config/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/dark_mode.dart';

class call extends StatefulWidget {
  final String image;
  final String name;

  const call({super.key, required this.image, required this.name});

  @override
  State<call> createState() => _callState();
}

class _callState extends State<call> {
  ColorNotifire notifier = ColorNotifire();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: notifier.backGround,
      body: Column(
        children: [
          AppConstants.Height(height / 5),
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            child: Center(
              child: Container(
                alignment: Alignment.center,
                height: height / 5,
                width: width / 3,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(widget.image),
                    fit: BoxFit.cover,
                    scale: 2.5,
                  ),
                ),
              ),
            ),
          ),
          Text(
            widget.name,
            style: TextStyle(
              fontSize: 22,
              fontFamily: "Ariom-Bold",
              color: notifier.textColor,
            ),
          ),
          Text(
            "Ringing...",
            style: TextStyle(
              fontSize: 15,
              color: notifier.subtitleTextColor,
              fontFamily: "Averta-Regular",
            ),
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 20,
        ),
        child: Container(
          height: height / 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                "assets/Video.png",
                scale: 2,
              ),
              Image.asset(
                "assets/Microphone.png",
                scale: 2,
              ),
              Image.asset(
                "assets/Camera.png",
                scale: 2,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: height / 14,
                  width: width / 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: const Color(0xffFF4051),
                  ),
                  child: const Icon(
                    Icons.phone_rounded,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
