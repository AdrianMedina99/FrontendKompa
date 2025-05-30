// ignore_for_file: file_names, camel_case_types

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Config/common.dart';
import '../../dark_mode.dart';
import 'Event_detail.dart';
import 'event.dart';

class See_all extends StatefulWidget {
  const See_all({super.key});

  @override
  State<See_all> createState() => _See_allState();
}

class _See_allState extends State<See_all> {
  ColorNotifire notifier = ColorNotifire();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.backGround,
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
            scale: 3,
            color: notifier.textColor,
          ),
        ),
        title: Text(
          "See All",
          style: TextStyle(
            fontSize: 20,
            color: notifier.textColor,
            fontFamily: "Ariom-Bold",
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            ListView.builder(
              physics:  const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              // itemExtent: 1,
              itemCount: eventDetail.length,
              itemBuilder: (_, index) {
                EventModel data = eventDetail[index];
                return Padding(
                  padding:  const EdgeInsets.all(10),
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
                            height: MediaQuery.of(context).size.height / 8,
                            width: MediaQuery.of(context).size.width / 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              image: DecorationImage(
                                image: AssetImage(data.image),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        AppConstants.Width(
                            MediaQuery.of(context).size.width / 30),
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
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 30,
                            ),
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
                                  width: MediaQuery.of(context).size.width / 6,
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
