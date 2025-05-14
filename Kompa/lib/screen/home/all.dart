// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:ui';
import 'package:kompa/Config/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../dark_mode.dart';
import 'event_detail.dart';
import 'event.dart';
import 'see_all.dart';

class All extends StatefulWidget {
  const All({super.key});

  @override
  State<All> createState() => _AllState();
}

class _AllState extends State<All> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
    value: 1.0,
  );
  bool _isFavorite = false;
  bool _isFavorite1 = false;
  ColorNotifire notifier = ColorNotifire();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: notifier.backGround,
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Event_detail(),
                          ),
                        );
                      },
                      child: Container(
                        height: height / 3,
                        width: width / 1.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          gradient: LinearGradient(
                            end: const Alignment(0.0, -1),
                            begin: const Alignment(0.0, 0.6),
                            colors: <Color>[
                              const Color(0x8A000000),
                              Colors.black.withOpacity(0.0)
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Stack(
                                children: [
                                  Image.asset(
                                    "assets/Splash 1.png",
                                    fit: BoxFit.cover,
                                    height: height / 3,
                                    width: width / 1,
                                  ),
                                  Container(
                                    height: height / 3,
                                    width: width / 1.1,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      gradient: LinearGradient(
                                        end: const Alignment(0.0, -1),
                                        begin: const Alignment(0.0, 0.6),
                                        colors: <Color>[
                                          const Color(0x8A000000),
                                          Colors.black.withOpacity(0.0)
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 20,
                                    right: 20,
                                    child: Container(
                                      height: height / 18,
                                      width: width / 4,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.all(
                                          color: notifier.backGround,
                                          width: 2,
                                        ),
                                        color: Colors.white.withOpacity(0.2),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "23 Jun",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontFamily: "Ariom-Bold",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: height / 10,
                                    child: const Padding(
                                      padding: EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                      ),
                                      child: Text(
                                        "Glowing Art\nPerformance",
                                        style: TextStyle(
                                          fontFamily: "Ariom-Bold",
                                          fontSize: 26,
                                          color: Colors.white,
                                          wordSpacing: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: height / 70,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                      ),
                                      child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Image.asset(
                                            "assets/Clock.png",
                                            color: Colors.white,
                                            scale: 2.5,
                                          ),
                                          AppConstants.Width(width / 50),
                                          const Text(
                                            "22:00 PM",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                          AppConstants.Width(width / 30),
                                          Image.asset(
                                            "assets/location.png",
                                            scale: 3,
                                            color: Colors.white,
                                          ),
                                          AppConstants.Width(width / 50),
                                          const Text(
                                            "Singapore",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                          AppConstants.Width(width / 8),
                                          Container(
                                            height: height / 14,
                                            width: width / 5,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xffD1E50C),
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(
                                                  () {
                                                    _isFavorite = !_isFavorite;
                                                  },
                                                );
                                                _controller.reverse().then(
                                                      (value) =>
                                                          _controller.forward(),
                                                    );
                                              },
                                              child: ScaleTransition(
                                                scale: Tween(
                                                  begin: 0.7,
                                                  end: 1.0,
                                                ).animate(
                                                  CurvedAnimation(
                                                    parent: _controller,
                                                    curve: Curves.linear,
                                                  ),
                                                ),
                                                child: _isFavorite
                                                    ? const Icon(
                                                        Icons.favorite,
                                                        size: 30,
                                                        color: Colors.red,
                                                      )
                                                    : const Icon(
                                                        Icons.favorite_border,
                                                        size: 30,
                                                        color: Colors.black,
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppConstants.Width(width / 30),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Event_detail(),
                          ),
                        );
                      },
                      child: Container(
                        height: height / 3,
                        width: width / 1.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Stack(
                                children: [
                                  Image.asset(
                                    "assets/Splash 2.png",
                                    fit: BoxFit.fitHeight,
                                    height: height / 3,
                                  ),
                                  Container(
                                    height: height / 3,
                                    width: width / 1.1,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      gradient: LinearGradient(
                                        end: const Alignment(0.0, -1),
                                        begin: const Alignment(0.0, 0.6),
                                        colors: <Color>[
                                          const Color(0x8A000000),
                                          Colors.black.withOpacity(0.0)
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 20,
                                    right: 20,
                                    child: Container(
                                      height: height / 18,
                                      width: width / 4,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        border: Border.all(
                                          color: notifier.backGround,
                                          width: 2,
                                        ),
                                        color: Colors.white.withOpacity(0.2),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "10 Apr",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontFamily: "Ariom-Bold",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: height / 10,
                                    child: const Padding(
                                      padding: EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                      ),
                                      child: Text(
                                        "Glowing Art\nPerformance",
                                        style: TextStyle(
                                          fontFamily: "Ariom-Bold",
                                          fontSize: 26,
                                          color: Colors.white,
                                          wordSpacing: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: height / 70,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/Clock.png",
                                            color: const Color(0xffFFFFFF),
                                            scale: 2.5,
                                          ),
                                          AppConstants.Width(width / 35),
                                          const Text(
                                            "10:00 PM",
                                            style: TextStyle(
                                              color: Color(0xffFFFFFF),
                                              fontSize: 16,
                                            ),
                                          ),
                                          AppConstants.Width(width / 20),
                                          Image.asset(
                                            "assets/location.png",
                                            scale: 3,
                                            color: const Color(0xffFFFFFF),
                                          ),
                                          AppConstants.Width(width / 35),
                                          const Text(
                                            "Tokyo",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                          AppConstants.Width(width / 5),
                                          Container(
                                            height: height / 14,
                                            width: width / 5,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xffD1E50C),
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(
                                                  () {
                                                    _isFavorite1 =
                                                        !_isFavorite1;
                                                  },
                                                );
                                                _controller.reverse().then(
                                                      (value) =>
                                                          _controller.forward(),
                                                    );
                                              },
                                              child: ScaleTransition(
                                                scale: Tween(
                                                  begin: 0.7,
                                                  end: 1.0,
                                                ).animate(
                                                  CurvedAnimation(
                                                    parent: _controller,
                                                    curve: Curves.linear,
                                                  ),
                                                ),
                                                child: _isFavorite1
                                                    ? const Icon(
                                                        Icons.favorite,
                                                        size: 30,
                                                        color: Colors.red,
                                                      )
                                                    : const Icon(
                                                        Icons.favorite_border,
                                                        size: 30,
                                                        color: Color(0xff131313),
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AppConstants.Height(height / 30),
              Row(
                children: [
                  Text(
                    "Trending Event",
                    style: TextStyle(
                      fontSize: 32,
                      color: notifier.textColor,
                      fontFamily: "Ariom-Bold",
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const See_all(),
                        ),
                      );
                    },
                    child: Text(
                      "See all",
                      style: TextStyle(
                        color: notifier.textColor,
                        fontSize: 12,
                      ),
                    ),
                  )
                ],
              ),
              AppConstants.Height(height / 40),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                // itemExtent: 1,
                itemCount: eventDetail.length,
                itemBuilder: (_, index) {
                  EventModel data = eventDetail[index];
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      bottom: 15,
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Event_detail(),
                          ),
                        );
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
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Column(
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
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      data.time,
                                      style: TextStyle(
                                        color: notifier.subtitleTextColor,
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 3.9,
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
      ),
    );
  }

  Widget Event({
    required String image,
    required String name,
    required String time,
    required String location,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 10,
            width: MediaQuery.of(context).size.width / 5,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaY: 1,
                sigmaX: 1,
              ),
              child: const Column(
                children: [
                  Text(
                    "data",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          AppConstants.Width(MediaQuery.of(context).size.width / 30),
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: "Ariom-Bold",
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 40),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(time),
                  SizedBox(width: MediaQuery.of(context).size.width / 6),
                  Text(location),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
