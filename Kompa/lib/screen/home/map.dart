// ignore_for_file: file_names, camel_case_types

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../Config/common.dart';
import '../../dark_mode.dart';
import 'ar.dart';
import 'default.dart';

class map extends StatefulWidget {
  const map({super.key});

  @override
  State<map> createState() => _mapState();
}

class _mapState extends State<map> {
  ColorNotifire notifier = ColorNotifire();
  int select = 0;
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

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
          "Direction",
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Ariom-Bold",
            color: notifier.textColor,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                isScrollControlled: true,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return Container(
                        height: height / 3.5,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                          color: notifier.backGround,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 25,
                            right: 25,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppConstants.Height(height / 40),
                              Row(
                                children: [
                                  Text(
                                    "Select Map",
                                    style: TextStyle(
                                      color: notifier.textColor,
                                      fontFamily: "Ariom-Bold",
                                      fontSize: 22,
                                    ),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: notifier.textColor,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                              AppConstants.Height(height / 40),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(
                                        () {
                                          select = 0;
                                        },
                                      );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const Default(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: select == 0
                                              ? Colors.yellow
                                              : notifier.backGround,
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            child: Image.asset(
                                              "assets/Default Map 1.png",
                                              scale: 1,
                                            ),
                                          ),
                                          Positioned(
                                            bottom: -5,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              height: height / 20,
                                              width: width / 2.6,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: notifier.backGround,
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Default",
                                                style: TextStyle(
                                                  fontFamily: "Ariom-Bold",
                                                  color: notifier.textColor,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        select = 1;
                                      });
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const Ar(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: select == 1
                                              ? Colors.yellow
                                              : notifier.backGround,
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            child: Image.asset(
                                              "assets/AR Map 1.png",
                                              scale: 3,
                                            ),
                                          ),
                                          Positioned(
                                            bottom: -5,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              height: height / 20,
                                              width: width / 2.6,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: notifier.backGround,
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                "AR",
                                                style: TextStyle(
                                                  fontFamily: "Ariom-Bold",
                                                  color: notifier.textColor,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
            child: Image.asset(
              "assets/Map Logo.png",
              scale: 3,
              color: notifier.textColor,
            ),
          ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
      ),
    );
  }
}
