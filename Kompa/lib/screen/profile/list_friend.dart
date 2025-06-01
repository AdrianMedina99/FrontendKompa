// ignore_for_file: non_constant_identifier_names, camel_case_types, file_names

import 'package:kompa/config/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/dark_mode.dart';

class List_friend extends StatefulWidget {
  const List_friend({super.key});

  @override
  State<List_friend> createState() => _List_friendState();
}

class _List_friendState extends State<List_friend> {
  List Friend = [
    {
      "image": "assets/Avtar 1.png",
      "name": "Nemus Genesis",
      "subtitle": "by Spacybox",
    },
    {
      "image": "assets/Avtar 2.png",
      "name": "Stories from JX",
      "subtitle": "by Andre Mix",
    },
    {
      "image": "assets/Avtar 3.png",
      "name": "Crystal Doomed",
      "subtitle": "by Akarasaka",
    },
    {
      "image": "assets/Avtar 1.png",
      "name": "Expressions",
      "subtitle": "by expression",
    },
    {
      "image": "assets/Avtar 3.png",
      "name": "Nemus Genesis",
      "subtitle": "by Spacybox",
    },
    {
      "image": "assets/Avtar 2.png",
      "name": "Visionxxx",
      "subtitle": "by Grondigen",
    },
    {
      "image": "assets/Avtar 1.png",
      "name": "Manuelaveux",
      "subtitle": "by alesiaLuxx",
    },
    {
      "image": "assets/Avtar 1.png",
      "name": "Nemus Genesis",
      "subtitle": "by Spacybox",
    },
    {
      "image": "assets/Avtar 2.png",
      "name": "Stories from JX",
      "subtitle": "by Andre Mix",
    },
    {
      "image": "assets/Avtar 3.png",
      "name": "Crystal Doomed",
      "subtitle": "by Akarasaka",
    },
    {
      "image": "assets/Avtar 1.png",
      "name": "Expressions",
      "subtitle": "by expression",
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
        elevation: 0,
        backgroundColor: notifier.backGround,
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
          "List Friend",
          style: TextStyle(
            fontSize: 20,
            color: notifier.textColor,
            fontFamily: "Ariom-Bold",
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              AppConstants.Height(height / 40),
              ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: Friend.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding:  const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        alignment: Alignment.center,
                        height: height / 14,
                        width: width / 5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(
                              Friend[index]['image'],
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        // child: Image.asset(Friend[index]['image'], scale: 3,fit: BoxFit.cover),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Friend[index]['name'],
                            style: TextStyle(
                              color: notifier.textColor,
                              fontSize: 16,
                              fontFamily: "Ariom-Bold",
                            ),
                          ),
                          AppConstants.Height(height / 50),
                          Text(
                            Friend[index]['subtitle'],
                            style: TextStyle(
                              color: notifier.subtitleTextColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      trailing: Container(
                        height: height / 17,
                        width: width / 3.7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: notifier.textColor,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Unfriend",
                            style: TextStyle(
                              color: notifier.textColor,
                              fontSize: 17,
                              fontFamily: "Ariom-Bold",
                            ),
                          ),
                        ),
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
}
