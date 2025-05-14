// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Config/common.dart';
import '../../dark_mode.dart';


class Ar extends StatefulWidget {
  const Ar({super.key});

  @override
  State<Ar> createState() => _ArState();
}

class _ArState extends State<Ar> {
  ColorNotifire notifier = ColorNotifire();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
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
            scale: 3,
            color: notifier.textColor,
          ),
        ),
        title: Text(
          "AR",
          style: TextStyle(
            color: notifier.textColor,
            fontSize: 20,
            fontFamily: "Ariom-Bold",
          ),
        ),
        actions: [
          Image.asset(
            "assets/Map Logo.png",
            scale: 3,
            color: notifier.textColor,
          ),
        ],
      ),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "assets/AR Map.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 20,
            right: 0,
            child: Row(
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    height: height / 5,
                    width: width / 3.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(37),
                      image: const DecorationImage(
                        image: AssetImage("assets/Map.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                AppConstants.Width(width / 30),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    height: height / 5,
                    width: width / 1.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(37),
                      color: const Color(0xffD1E50C),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              "400 m",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xff131313),
                                fontFamily: "Ariom-Bold",
                              ),
                            ),
                          ),
                          AppConstants.Height(height / 90),
                          const Center(
                            child: Text(
                              "Turn right",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff131313),
                              ),
                            ),
                          ),
                          const Divider(
                            color: Color(0xffFFFFFF),
                            thickness: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    const Text(
                                      "08:08",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xff131313),
                                        fontFamily: "Ariom-Bold",
                                      ),
                                    ),
                                    AppConstants.Height(10),
                                    const Text(
                                      "arrival",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff131313),
                                        fontFamily: "Ariom-Bold",
                                      ),
                                    ),
                                  ],
                                ),
                                // Container(
                                //   height: height/20,
                                //   width: 2,
                                //   color: Color(0xffFFFFFF),
                                // ),
                                Column(
                                  children: [
                                    const Text(
                                      "15",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xff131313),
                                        fontFamily: "Ariom-Bold",
                                      ),
                                    ),
                                    AppConstants.Height(10),
                                    const Text(
                                      "min",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff131313),
                                        fontFamily: "Ariom-Bold",
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      "1",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xff131313),
                                        fontFamily: "Ariom-Bold",
                                      ),
                                    ),
                                    AppConstants.Height(10),
                                    const Text(
                                      "km",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff131313),
                                        fontFamily: "Ariom-Bold",
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
