// ignore_for_file: camel_case_types, non_constant_identifier_names, file_names

import 'package:kompa/config/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/dark_mode.dart';
import 'message_detail.dart';


class message extends StatefulWidget {
  const message({super.key});

  @override
  State<message> createState() => _messageState();
}

class _messageState extends State<message> {
  List Message = [
    {
      "image": "assets/Avtar 1.png",
      "name": "Nemus Genesis",
      "subtitle": "by Andre Mix",
      "time": "06:00",
    },
    {
      "image": "assets/Avtar 2.png",
      "name": "Stories from JX",
      "subtitle": "by Andre Mix",
      "time": "06:00",
    },
    {
      "image": "assets/Avtar 3.png",
      "name": "Crystal Doomed",
      "subtitle": "by Akarasaka",
      "time": "06:00",
    },
    {
      "image": "assets/Avtar 1.png",
      "name": "Expressions",
      "subtitle": "by expression",
      "time": "06:00",
    },
    {
      "image": "assets/Avtar 3.png",
      "name": "Nemus Genesis",
      "subtitle": "by Spacybox",
      "time": "06:00",
    },
    {
      "image": "assets/Avtar 2.png",
      "name": "Visionxxx",
      "subtitle": "by Grondigen",
      "time": "06:00",
    },
    {
      "image": "assets/Avtar 1.png",
      "name": "Manuelaveux",
      "subtitle": "by alesiaLuxx",
      "time": "06:00",
    },
    {
      "image": "assets/Avtar 2.png",
      "name": "Visionxxx",
      "subtitle": "by Grondigen",
      "time": "06:00",
    },
    {
      "image": "assets/Avtar 1.png",
      "name": "Manuelaveux",
      "subtitle": "by alesiaLuxx",
      "time": "06:00",
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
        automaticallyImplyLeading: false,
        title: Text(
          "Message",
          style: TextStyle(
            fontSize: 20,
            color: notifier.textColor,
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
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppConstants.Height(height / 30),
              Container(
                height: height / 15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: notifier.textColor,
                  ),
                ),
                child: Center(
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(top: 17),
                      hintText: "Search laQuedada",
                      hintStyle: TextStyle(
                        color: notifier.subtitleTextColor,
                        fontSize: 15,
                      ),
                      border: InputBorder.none,
                      prefixIcon: Image.asset(
                        "assets/Search.png",
                        scale: 3,
                        color: notifier.textColor,
                      ),
                    ),
                  ),
                ),
              ),
              AppConstants.Height(height / 40),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: Message.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Message_detail(
                              image: Message[index]['image'],
                              name: Message[index]['name'],
                            ),
                          ),
                        );
                      },
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
                                Message[index]['image'],
                              ),
                              fit: BoxFit.cover,
                              scale: 3,
                            ),
                          ),
                        ),
                        title: Text(
                          Message[index]['name'],
                          style: TextStyle(
                            color: notifier.textColor,
                            fontSize: 17,
                            fontFamily: "Ariom-Bold",
                          ),
                        ),
                        subtitle: Text(
                          Message[index]['subtitle'],
                          style: TextStyle(
                            color: notifier.subtitleTextColor,
                            fontSize: 14,
                          ),
                        ),
                        trailing: Text(
                          Message[index]['time'],
                          style: TextStyle(
                            color: notifier.textColor,
                            fontSize: 14,
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
