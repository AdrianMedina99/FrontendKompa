// ignore_for_file: file_names, camel_case_types

import 'package:kompa/config/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/dark_mode.dart';

class Event_organizer extends StatefulWidget {
  const Event_organizer({super.key});

  @override
  State<Event_organizer> createState() => _Event_organizerState();
}

class _Event_organizerState extends State<Event_organizer> {
  final List<Map<String, String>> data1 = [
    {
      "image": "assets/Splash 1.png",
      "date": "2 May",
      "name": "New Product Press\nConference",
    },
    {
      "image": "assets/Splash 3.png",
      "date": "12 Jun",
      "name": "Seminar Book",
    },
    {
      "image": "assets/Splash 2.png",
      "date": "23 Jun",
      "name": "Glowing Art\nPerformance",
    },
    {
      "image": "assets/Splash 1.png",
      "date": "30 Sep",
      "name": "Light Festival",
    },
    {
      "image": "assets/Splash 4.png",
      "date": "12 Apr",
      "name": "Book",
    },
    {
      "image": "assets/Splash 5.png",
      "date": "24 Jan",
      "name": "Performance",
    },
  ];

  ColorNotifire notifier = ColorNotifire();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
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
          "Organizer",
          style: TextStyle(
            fontSize: 20,
            color: notifier.textColor,
            fontFamily: "Ariom-Bold",
          ),
        ),
        actions: [
          Image.asset(
            "assets/Message 1.png",
            scale: 3,
            color: notifier.textColor,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppConstants.Height(height / 40),
              Center(
                child: Container(
                  height: height / 3.6,
                  // width: width/3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    image: const DecorationImage(
                      image: AssetImage("assets/Splash 1.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              AppConstants.Height(height / 30),
              Text(
                "About",
                style: TextStyle(
                  color: notifier.textColor,
                  fontSize: 32,
                  fontFamily: "Ariom-Bold",
                ),
              ),
              AppConstants.Height(height / 30),
              Text(
                "Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubted source. ver since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. ",
                style: TextStyle(
                  fontSize: 14,
                  color: notifier.subtitleTextColor,
                  fontFamily: "Averta-Regular",
                  wordSpacing: 10,
                ),
              ),
              Text(
                "Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here , making it look like readable English. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet.",
                style: TextStyle(
                  fontSize: 14,
                  color: notifier.subtitleTextColor,
                  fontFamily: "Averta-Regular",
                  wordSpacing: 12,
                ),
              ),
              AppConstants.Height(height / 40),
              Text(
                "List Event",
                style: TextStyle(
                  fontFamily: "Ariom-Bold",
                  color: notifier.textColor,
                  fontSize: 32,
                ),
              ),
              AppConstants.Height(height / 30),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data1.length,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5 / 3,
                  // childAspectRatio: 3 / 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemBuilder: (_, index) {
                  return Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Stack(
                          children: [
                            Image.asset(
                              data1[index]['image']!,
                              fit: BoxFit.cover,
                              height: height / 4.2,
                              width: width / 1,
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                height: height / 18,
                                width: width / 4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: notifier.backGround,
                                    width: 1.5,
                                  ),
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                child: Center(
                                  child: Text(
                                    data1[index]['date']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: "Ariom-Bold",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: height / 45,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                ),
                                child: Text(
                                  data1[index]['name']!,
                                  style: const TextStyle(
                                    fontFamily: "Ariom-Bold",
                                    fontSize: 15,
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
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
