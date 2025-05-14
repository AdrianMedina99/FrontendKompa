// ignore_for_file: file_names, camel_case_types

import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:flutter/material.dart';
import 'package:kompa/screen/home/space_event.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import '../../Config/common.dart';
import '../../dark_mode.dart';
import '../message/add_friend.dart';
import '../tickets/ticket_book.dart';
import 'event_organizer.dart';
import 'list_friends.dart';

class Event_detail extends StatefulWidget {
  const Event_detail({super.key});

  @override
  State<Event_detail> createState() => _Event_detailState();
}

class _Event_detailState extends State<Event_detail> {
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
        backgroundColor: notifier.backGround,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              "assets/arrow-left.png",
              scale: 2.5,
              color: notifier.textColor,
            ),
          ),
        ),
        title: Text(
          "Event Detail",
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Ariom-Bold",
            color: notifier.textColor,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const Add_Friend(),));
            },
            child: Image.asset(
              "assets/User Invite.png",
              scale: 3,
              color: notifier.textColor,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 8,
          right: 8,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppConstants.Height(height / 60),
              carousel.CarouselSlider(
                items: [
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(55),
                        child: Stack(
                          children: [
                            Container(
                              height: height / 2.8,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/Splash 4.png"),
                                  fit: BoxFit.cover,
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
                              bottom: height / 30,
                              child: const Padding(
                                padding: EdgeInsets.only(
                                  left: 30,
                                  right: 10,
                                ),
                                child: Text(
                                  "Glowing Art\nPerformance",
                                  style: TextStyle(
                                    fontFamily: "Ariom-Bold",
                                    fontSize: 24,
                                    color: Colors.white,
                                    wordSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(55),
                        child: Stack(
                          children: [
                            Container(
                              height: height / 2.8,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/Splash 3.png"),
                                  fit: BoxFit.cover,
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
                              bottom: height / 30,
                              child: const Padding(
                                padding: EdgeInsets.only(
                                  left: 30,
                                  right: 10,
                                ),
                                child: Text(
                                  "Glowing Art\nPerformance",
                                  style: TextStyle(
                                    fontFamily: "Ariom-Bold",
                                    fontSize: 24,
                                    color: Colors.white,
                                    wordSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(55),
                        child: Stack(
                          children: [
                            Container(
                              height: height / 2.8,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/Splash 2.png"),
                                  fit: BoxFit.cover,
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
                              bottom: height / 30,
                              child: const Padding(
                                padding: EdgeInsets.only(
                                  left: 30,
                                  right: 10,
                                ),
                                child: Text(
                                  "Glowing Art\nPerformance",
                                  style: TextStyle(
                                    fontFamily: "Ariom-Bold",
                                    fontSize: 24,
                                    color: Colors.white,
                                    wordSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(55),
                        child: Stack(
                          children: [
                            Container(
                              height: height / 2.8,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/Splash 1.png"),
                                  fit: BoxFit.cover,
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
                              bottom: height / 30,
                              child: const Padding(
                                padding: EdgeInsets.only(
                                  left: 30,
                                  right: 10,
                                ),
                                child: Text(
                                  "Glowing Art\nPerformance",
                                  style: TextStyle(
                                    fontFamily: "Ariom-Bold",
                                    fontSize: 24,
                                    color: Colors.white,
                                    wordSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
                options: carousel.CarouselOptions(
                  enlargeCenterPage: true,
                  autoPlay: true,
                  // aspectRatio: 1 / 0.9,
                  aspectRatio: 1/0.9,
                  autoPlayCurve: Curves.linear,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                  viewportFraction: 0.9,
                ),
              ),
              ListTile(
                leading: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Event_organizer(),
                      ),
                    );
                  },
                  child: const CircleAvatar(
                    foregroundImage: AssetImage("assets/JS Media.png"),
                  ),
                ),
                title: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Event_organizer(),
                      ),
                    );
                  },
                  child: Text(
                    "by APPLEWOOD - JS\nMEDIA",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Ariom-Bold",
                      color: notifier.textColor,
                    ),
                  ),
                ),
                trailing: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Space_event(),
                        ));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: height / 14,
                    width: width / 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: notifier.textColor,
                    ),
                    child: Image.asset(
                      "assets/Box.png",
                      scale: 2.7,
                      color: notifier.imageColor,
                    ),
                  ),
                ),
              ),
              AppConstants.Height(height / 40),
              Row(
                children: [
                  Image.asset(
                    "assets/Clock.png",
                    scale: 2.5,
                    color: notifier.textColor,
                  ),
                  AppConstants.Width(width / 40),
                  Text(
                    "22:00 PM",
                    style: TextStyle(
                      color: notifier.textColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              AppConstants.Height(height / 40),
              Row(
                children: [
                  Image.asset(
                    "assets/location.png",
                    scale: 2.5,
                    color: notifier.textColor,
                  ),
                  AppConstants.Width(width / 40),
                  Text(
                    "Singapore",
                    style: TextStyle(
                      color: notifier.textColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              AppConstants.Height(height / 40),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const List_friends(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: height / 15,
                          width: width / 6,
                          decoration: BoxDecoration(
                            // color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: notifier.backGround,
                              width: 3,
                            ),
                            image: const DecorationImage(
                              image: AssetImage("assets/Splash 1.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 40,
                          child: Container(
                            height: height / 15,
                            width: width / 6,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: notifier.backGround,
                                width: 3,
                              ),
                              image: const DecorationImage(
                                image: AssetImage("assets/Splash 2.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 80,
                          child: Container(
                            height: height / 15,
                            width: width / 6,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: notifier.backGround,
                                width: 3,
                              ),
                              image: const DecorationImage(
                                image: AssetImage("assets/Splash 3.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 120,
                          child: Container(
                            height: height / 15,
                            width: width / 6,
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: notifier.backGround,
                                width: 3,
                              ),
                              image: const DecorationImage(
                                image: AssetImage("assets/Splash 4.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 160,
                          child: Container(
                            height: height / 15,
                            width: width / 6,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: notifier.backGround,
                                width: 3,
                              ),
                              image: const DecorationImage(
                                image: AssetImage("assets/Splash 5.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      "\$100.00",
                      style: TextStyle(
                        color: notifier.textColor,
                        fontSize: 22,
                        fontFamily: "Ariom-Bold",
                      ),
                    ),
                  ],
                ),
              ),
              AppConstants.Height(height / 50),
              Text(
                "Description",
                style: TextStyle(
                  fontFamily: "Ariom-Bold",
                  fontSize: 33,
                  color: notifier.textColor,
                ),
              ),
              ReadMoreText(
                "This exciting and inspiring event is organized to create a space for founders, researchers, and creative enthusiasts to meet, exchange and find new ideas. we are looking for cooperation opportunities.",
                trimLines: 3,
                preDataTextStyle: TextStyle(
                  color: notifier.subtitleTextColor,
                  fontFamily: "Averta-Regular",
                  fontSize: 17,
                ),
                style: const TextStyle(
                  color: Color(0xff6C6D80),
                  fontFamily: "Averta-Bold",
                  fontSize: 17,
                ),
                colorClickableText: notifier.textColor,
                trimMode: TrimMode.Line,
                trimCollapsedText: 'Show more',
                trimExpandedText: ' Show less',
              ),
              AppConstants.Height(height / 50),
              AppConstants.Height(height / 40),
              Text(
                "Location",
                style: TextStyle(
                  fontFamily: "Ariom-Bold",
                  fontSize: 33,
                  color: notifier.textColor,
                ),
              ),
              AppConstants.Height(height / 40),
              Container(
                height: height / 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: AssetImage("assets/Map.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              AppConstants.Height(height / 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ticket1(),
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
              "Book Event",
              style: TextStyle(
                fontSize: 22,
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
