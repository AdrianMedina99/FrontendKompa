// ignore_for_file: file_names, non_constant_identifier_names

import 'package:kompa/Config/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../dark_mode.dart';
import 'wishlist_all.dart';

class WishList extends StatefulWidget {
  const WishList({super.key});

  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  ColorNotifire notifier = ColorNotifire();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: notifier.backGround,
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
          "Wishlist",
          style: TextStyle(
            color: notifier.textColor,
            fontSize: 20,
            fontFamily: "Ariom-Bold",
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppConstants.Height(height / 30),
              Text(
                "List Event",
                style: TextStyle(
                  color: notifier.textColor,
                  fontSize: 30,
                  fontFamily: "Ariom-Bold",
                ),
              ),
              AppConstants.Height(height / 30),
              ListView.builder(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: wishDetail.length,
                itemBuilder: (context, index) {
                  final data = wishDetail[index];
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      setState(
                        () {
                          wishDetail.removeAt(index);
                        },
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'Unsaved',
                            style: TextStyle(
                              fontFamily: "Ariom-Bold",
                              color: Color(0xff131313),
                              fontSize: 20,
                            ),
                          ),
                          backgroundColor: Colors.yellow,
                          dismissDirection: DismissDirection.startToEnd,
                          animation: ProxyAnimation(),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            ),
                          ),
                        ),
                      );
                    },
                    background: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: notifier.textColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 30,
                              top: 40,
                            ),
                            child: Image.asset(
                              "assets/Unsaved.png",
                              scale: 3,
                              color: notifier.imageColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    child: Event_(
                      image: data.image,
                      name: data.name,
                      time: data.time,
                      location: data.location,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget Event_({
    required String image,
    required String name,
    required String time,
    required String location,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 8,
            width: MediaQuery.of(context).size.width / 3.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset(
                    image,
                    scale: 3,
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height / 8,
                    width: MediaQuery.of(context).size.width / 3.5,
                  ),
                ),
              ],
            ),
          ),
          AppConstants.Width(MediaQuery.of(context).size.width / 30),
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Ariom-Bold",
                    color: notifier.textColor,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 40),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        color: notifier.subtitleTextColor,
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width / 6),
                    Text(
                      location,
                      style: TextStyle(
                        fontSize: 12,
                        color: notifier.subtitleTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
