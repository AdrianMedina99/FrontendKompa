// ignore_for_file: file_names, camel_case_types
import 'package:kompa/Config/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dark_mode.dart';
import 'event.dart';
import 'filter.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
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
          "Search",
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Ariom-Bold",
            color: notifier.textColor,
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
              AppConstants.Height(height / 40),
              Row(
                children: [
                  Container(
                    height: height / 14,
                    width: width / 1.30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: notifier.backGround,
                      border: Border.all(
                        color: notifier.textColor,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: TextField(
                        style: TextStyle(color: notifier.textColor),
                        decoration: InputDecoration(
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Image.asset(
                              "assets/Search.png",
                              scale: 3,
                              color: notifier.textColor,
                            ),
                          ),
                          hintText: "Event",
                          hintStyle: TextStyle(
                            color: notifier.textColor,
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.only(top: 20),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const filter(),
                        ),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: height / 14,
                      width: width / 7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: notifier.textColor,
                      ),
                      child: Image.asset(
                        "assets/Filter.png",
                        scale: 2.5,
                        color: notifier.imageColor,
                      ),
                    ),
                  ),
                ],
              ),
              AppConstants.Height(height / 40),
              Text(
                "Suggested events",
                style: TextStyle(
                  color: notifier.textColor,
                  fontFamily: "Ariom-Bold",
                  fontSize: 32,
                ),
              ),
              AppConstants.Height(height / 40),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: eventDetail1.length,
                itemBuilder: (context, index) {
                  EventModel1 data = eventDetail1[index];
                  return Event1(
                    image: data.image,
                    name: data.name,
                    time: data.time,
                    location: data.location,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget Event1({
    required String image,
    required String name,
    required String time,
    required String location,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: SizedBox(
        width: double.maxFinite,
        height: 120,
        // Dentro de Event1
        child: Row(
          children: [
            Container(
              height: 120,
              width: MediaQuery.of(context).size.width * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                    image: AssetImage(image), fit: BoxFit.cover),
              ),
            ),
            SizedBox(width: 8),
            Expanded( // <-- Cambia SizedBox por Expanded
              child: SizedBox(
                height: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: "Ariom-Bold",
                        color: notifier.textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 12,
                            color: notifier.subtitleTextColor,
                          ),
                        ),
                        Spacer(),
                        Text(
                          location,
                          style: TextStyle(
                            color: notifier.subtitleTextColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      /* Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 7,
            width: MediaQuery.of(context).size.width / 3.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              color: Colors.red,
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset(
                    image,
                    scale: 2,
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height / 6,
                    width: MediaQuery.of(context).size.width / 3.5,
                  ),
                ),
              ],
            ),
          ),
          AppConstants.Width(MediaQuery.of(context).size.width / 30),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: "Ariom-Bold",
                    color: notifier.textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 20),
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
                        color: notifier.subtitleTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),*/
    );
  }
}
