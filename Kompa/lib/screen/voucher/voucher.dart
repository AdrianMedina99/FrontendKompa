// ignore_for_file: file_names, non_constant_identifier_names
import 'package:kompa/Config/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../dark_mode.dart';

class Voucher extends StatefulWidget {
  const Voucher({super.key});

  @override
  State<Voucher> createState() => _VoucherState();
}

class _VoucherState extends State<Voucher> {
  int value = 0;
  List Voucher = [
    {
      "title": "Reduce 10%",
      "subtitle": "For you quickly book\nevents",
      "expiry": "Expiry date: 12 hours left",
    },
    {
      "title": "Reduce 10%",
      "subtitle": "For you quickly book\nevents",
      "expiry": "Expiry date: 12 hours left",
    },
    {
      "title": "Reduce 10%",
      "subtitle": "For you quickly book\nevents",
      "expiry": "Expiry date: 12 hours left",
    },
    {
      "title": "Reduce 10%",
      "subtitle": "For you quickly book\nevents",
      "expiry": "Expiry date: 12 hours left",
    },
    {
      "title": "Reduce 10%",
      "subtitle": "For you quickly book\nevents",
      "expiry": "Expiry date: 12 hours left",
    },
    {
      "title": "Reduce 10%",
      "subtitle": "For you quickly book\nevents",
      "expiry": "Expiry date: 12 hours left",
    },
    {
      "title": "Reduce 10%",
      "subtitle": "For you quickly book\nevents",
      "expiry": "Expiry date: 12 hours left",
    },
    {
      "title": "Reduce 10%",
      "subtitle": "For you quickly book\nevents",
      "expiry": "Expiry date: 12 hours left",
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
        centerTitle: true,
        elevation: 0,
        backgroundColor: notifier.backGround,
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
          "Voucher",
          style: TextStyle(
            color: notifier.textColor,
            fontSize: 20,
            fontFamily: "Ariom-Bold",
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              AppConstants.Height(height / 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: height / 13,
                    width: width / 1.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: notifier.textColor,
                      ),
                    ),
                    child:  Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: TextField(
                          style: TextStyle(color: notifier.textColor,fontSize: 20),
                          textAlign: TextAlign.start,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Insert Code",
                            hintStyle: TextStyle(
                              color: Color(0xff6C6D80),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: height / 13,
                    width: width / 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.yellow,
                    ),
                    child: const Center(
                      child: Text(
                        "Apply",
                        style: TextStyle(
                          color: Color(0xff131313),
                          fontSize: 16,
                          fontFamily: "Ariom-Bold",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              AppConstants.Height(height / 30),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: Voucher.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: InkWell(
                      onTap: () {
                        setState(
                          () {
                            value = index;
                          },
                        );
                      },
                      child: SizedBox(
                        height: height / 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  notifier.isDark
                                      ? 'assets/Voucher dark.png'
                                      : "assets/Voucher 1.png",
                                  scale: 2.5,
                                ),
                                AppConstants.Width(width / 30),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Voucher[index]['title'],
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontFamily: "Ariom-Bold",
                                          color: notifier.textColor,
                                        ),
                                      ),
                                      AppConstants.Height(height / 80),
                                      Row(
                                        children: [
                                          Text(
                                            Voucher[index]['subtitle'],
                                            style: TextStyle(
                                              color: notifier.textColor,
                                              fontSize: 16,
                                              fontFamily: "Averta-Regular",
                                            ),
                                          ),
                                          SizedBox(
                                            width: width / 11,
                                          ),
                                          radioButton(index),
                                        ],
                                      ),
                                      AppConstants.Height(height / 40),
                                      Text(
                                        Voucher[index]['expiry'],
                                        style: const TextStyle(
                                          color: Color(0xffFF4051),
                                          fontSize: 13,
                                          fontFamily: "Averta-Regular",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              AppConstants.Height(height / 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          height: height / 11,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Color(0xffD1E50C),
          ),
          child: const Center(
            child: Text(
              "Continue",
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Ariom-Bold",
                color: Color(0xff131313),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget radioButton(int index) {
    return SizedBox(
      height: 25,
      width: 25,
      child: OutlinedButton(
        onPressed: () {
          value = index;
          setState(() {});
        },
        style: ElevatedButton.styleFrom(
          // side: BorderSide(
          //   color: (value == index)
          //       ? const Color(0xff0056D2)
          //       : const Color(0xffE2E8F0),
          //   width: (value == index) ? 7 : 2,
          // ),
          backgroundColor: (value == index) ? notifier.textColor : Colors.grey,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(0),
          elevation: 0,
        ),
        child: Icon(
          Icons.check,
          color: notifier.backGround,
        ),
      ),
    );
  }
}
