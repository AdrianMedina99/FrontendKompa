// ignore_for_file: file_names, camel_case_types

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Config/common.dart';
import '../../Config/concert 1.dart';
import '../../dark_mode.dart';
import 'Event_detail.dart';

class Concert_see_all extends StatefulWidget {
  const Concert_see_all({super.key});

  @override
  State<Concert_see_all> createState() => _Concert_see_allState();
}

class _Concert_see_allState extends State<Concert_see_all> {
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
        elevation: 0,
        backgroundColor: notifier.backGround,
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
          "Concert See All",
          style: TextStyle(
            fontSize: 20,
            color: notifier.textColor,
            fontFamily: "Ariom-Bold",
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              // itemExtent: 1,
              itemCount: concertDetail.length,
              itemBuilder: (_, index) {
                ConcertModel data = concertDetail[index];
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      /*Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Event_detail(),
                        ),
                      );*/
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ImageFiltered(
                          imageFilter: ImageFilter.blur(
                            sigmaY: 1,
                            sigmaX: 1,
                          ),
                          enabled: false,
                          child: Container(
                            height: height / 8,
                            width: width / 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              image: DecorationImage(
                                image: AssetImage(data.image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        AppConstants.Width(width / 30),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Ariom-Bold",
                                color: notifier.textColor,
                              ),
                            ),
                            SizedBox(height: height / 30),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  data.time,
                                  style: TextStyle(
                                    color: notifier.subtitleTextColor,
                                  ),
                                ),
                                SizedBox(
                                  width: width / 6,
                                ),
                                Text(
                                  data.location,
                                  style: TextStyle(
                                    color: notifier.subtitleTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
