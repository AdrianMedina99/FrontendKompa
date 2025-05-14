// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';


class Space_event extends StatefulWidget {
  const Space_event({super.key});

  @override
  State<Space_event> createState() => _Space_eventState();
}

class _Space_eventState extends State<Space_event> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
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
            ),
          ),
        ),
        title: const Text(
          "Space Event",
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Ariom-Bold",
            color: Color(0xff131313),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Transform.rotate(
              angle: 6.28,
              child: SizedBox(
                height: height,
                width: double.infinity,
                child: Image.asset(
                  "assets/Space Event.png",
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          backgroundColor: const Color(0xff131313),
          onPressed: () {
            setState(() {});
            Navigator.pop(context);
          },
          child: Image.asset(
            "assets/Box.png",
            alignment: Alignment.center,
            height: 35,
          ),
        ),
      ),
    );
  }
}
