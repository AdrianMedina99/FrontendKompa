// ignore_for_file: file_names

import 'dart:async';
import 'package:kompa/Config/common.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../dark_mode.dart';

class Default extends StatefulWidget {
  const Default({super.key});

  @override
  State<Default> createState() => _DefaultState();
}

class _DefaultState extends State<Default> {
  ColorNotifire notifier = ColorNotifire();

  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center =  LatLng(45.521563,-122.677433);

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
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
            scale: 3,color: notifier.textColor,
          ),
        ),
        title:  Text(
          "Default",
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
          GoogleMap(
            mapType: MapType.satellite,
            onMapCreated: _onMapCreated,
            initialCameraPosition:const CameraPosition(
              target: _center,
              zoom: 20.0,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            child: Padding(
              padding:  const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: Container(
                height: height / 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color:  const Color(0xffD1E50C),
                ),
                child: Padding(
                  padding:  const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        padding:  const EdgeInsets.only(
                          left: 30,
                          right: 30,
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
          ),
        ],
      ),
    );
  }
}
