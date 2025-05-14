// ignore_for_file: file_names, camel_case_types, non_constant_identifier_names

import 'package:kompa/Config/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dark_mode.dart';
import 'bottom.dart';

class filter extends StatefulWidget {
  const filter({super.key});

  @override
  State<filter> createState() => _filterState();
}

class _filterState extends State<filter> {
  double _Value = 0;
  bool Select1 = false;
  bool Select2 = false;
  bool Select3 = false;
  bool Select4 = false;
  bool Select5 = false;
  ColorNotifire notifier = ColorNotifire();

  DateTime date = DateTime(2016, 10, 26);
  DateTime time1 = DateTime(2, 5, 10);

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

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
          "Filter",
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
              AppConstants.Height(height / 30),
              Text(
                "Location",
                style: TextStyle(
                  fontFamily: "Ariom-Bold",
                  fontSize: 20,
                  color: notifier.textColor,
                ),
              ),
              AppConstants.Height(height / 40),
              Row(
                children: [
                  Container(
                    height: height / 14,
                    width: width / 1.4,
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
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Image.asset(
                              "assets/location.png",
                              scale: 2.5,
                              color: notifier.textColor,
                            ),
                          ),
                          hintText: "New York City",
                          hintStyle: TextStyle(
                            color: notifier.textColor,
                            fontSize: 17,
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
                      height: height / 12,
                      width: width / 7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: notifier.textColor,
                      ),
                      child: Image.asset(
                        "assets/Gps.png",
                        scale: 2.5,
                        color: notifier.imageColor,
                      ),
                    ),
                  ),
                ],
              ),
              AppConstants.Height(height / 30),
              Text(
                "Date",
                style: TextStyle(
                  fontFamily: "Ariom-Bold",
                  fontSize: 20,
                  color: notifier.textColor,
                ),
              ),
              AppConstants.Height(height / 40),
              InkWell(
                onTap: () => _showDialog(
                  CupertinoDatePicker(
                    initialDateTime: date,
                    mode: CupertinoDatePickerMode.date,
                    use24hFormat: true,
                    showDayOfWeek: true,
                    onDateTimeChanged: (DateTime newDate) {
                      setState(() => date = newDate);
                    },
                  ),
                ),
                child: Container(
                  height: height / 14,
                  // width: width/1.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: notifier.backGround,
                    border: Border.all(
                      color: notifier.textColor,
                    ),
                  ),
                  child: Center(
                    child: ListTile(
                      leading: Image.asset(
                        "assets/Calendar.png",
                        scale: 2.5,
                        color: notifier.textColor,
                      ),
                      title: Text(
                        '${date.month}-${date.day}-${date.year}',
                        style: TextStyle(
                          color: notifier.textColor,
                          fontSize: 17,
                          fontFamily: "Ariom-Bold",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              AppConstants.Height(height / 30),
              Text(
                "Hour",
                style: TextStyle(
                  fontFamily: "Ariom-Bold",
                  fontSize: 20,
                  color: notifier.textColor,
                ),
              ),
              AppConstants.Height(height / 40),
              InkWell(
                onTap: () => _showDialog(
                  CupertinoTheme(
                    data: const CupertinoThemeData(
                      barBackgroundColor: Colors.red,
                    ),
                    child: CupertinoDatePicker(
                      initialDateTime: time1,
                      showDayOfWeek: false,
                      mode: CupertinoDatePickerMode.time,
                      use24hFormat: true,
                      onDateTimeChanged: (DateTime newTime) {
                        setState(() => time1 = newTime);
                      },
                    ),
                  ),
                ),
                child: Container(
                  height: height / 14,
                  // width: width/1.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: notifier.backGround,
                    border: Border.all(
                      color: notifier.textColor,
                    ),
                  ),

                  child: Center(
                    child: ListTile(
                      leading: Image.asset(
                        "assets/Clock.png",
                        scale: 1.8,
                        color: notifier.textColor,
                      ),
                      title: Text(
                        '${time1.hour}:${time1.minute}',
                        style: TextStyle(
                          color: notifier.textColor,
                          fontSize: 17,
                          fontFamily: "Ariom-Bold",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              AppConstants.Height(height / 30),
              Text(
                "Distance",
                style: TextStyle(
                  fontFamily: "Ariom-Bold",
                  fontSize: 20,
                  color: notifier.textColor,
                ),
              ),
              AppConstants.Height(height / 30),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 5,
                  trackShape: const RoundedRectSliderTrackShape(),
                  valueIndicatorShape: const DropSliderValueIndicatorShape(),
                  valueIndicatorTextStyle: TextStyle(
                    fontSize: 20,
                    fontFamily: "Ariom-Regular",
                    color: notifier.backGround,
                  ),
                ),
                child: Slider(
                  value: _Value,
                  max: 100,
                  divisions: 100,
                  label: '${_Value.toInt()}',
                  thumbColor: notifier.textColor,
                  activeColor: notifier.textColor,
                  inactiveColor: const Color(0xffB6B6C0),
                  onChanged: (value) {
                    setState(
                      () {
                        _Value = value;
                      },
                    );
                  },
                ),
              ),
              AppConstants.Height(height / 30),
              Text(
                "Category",
                style: TextStyle(
                  fontFamily: "Ariom-Bold",
                  fontSize: 20,
                  color: notifier.textColor,
                ),
              ),
              AppConstants.Height(height / 40),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(
                        () {
                          Select1 = !Select1;
                        },
                      );
                    },
                    child: Container(
                      height: height / 18,
                      width: width / 3.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Select1
                            ? notifier.backGround
                            : notifier.isDark
                                ? Colors.yellow
                                : Colors.yellow,
                        border: Border.all(
                          color: Select1 ? notifier.textColor : Colors.black,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Outdoor",
                          style: TextStyle(
                            fontSize: 14,
                            color: Select1
                                ? notifier.subtitleTextColor
                                : notifier.isDark
                                    ? Colors.black
                                    : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  AppConstants.Width(width / 12),
                  InkWell(
                    onTap: () {
                      setState(
                        () {
                          Select2 = !Select2;
                        },
                      );
                    },
                    child: Container(
                      height: height / 18,
                      width: width / 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Select2
                            ? notifier.backGround
                            : notifier.isDark
                                ? Colors.yellow
                                : Colors.yellow,
                        border: Border.all(
                          color: Select2 ? notifier.textColor : Colors.black,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Indoor",
                          style: TextStyle(
                            fontSize: 14,
                            color: Select2
                                ? notifier.subtitleTextColor
                                : notifier.isDark
                                    ? Colors.black
                                    : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              AppConstants.Height(height / 40),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(
                        () {
                          Select3 = !Select3;
                        },
                      );
                    },
                    child: Container(
                      height: height / 18,
                      width: width / 2.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Select3
                            ? notifier.backGround
                            : notifier.isDark
                                ? Colors.yellow
                                : Colors.yellow,
                        border: Border.all(
                          color: Select3 ? notifier.textColor : Colors.black,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "On the beach",
                          style: TextStyle(
                            fontSize: 14,
                            color: Select3
                                ? notifier.subtitleTextColor
                                : notifier.isDark
                                    ? Colors.black
                                    : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  AppConstants.Width(width / 12),
                  InkWell(
                    onTap: () {
                      setState(
                        () {
                          Select4 = !Select4;
                        },
                      );
                    },
                    child: Container(
                      height: height / 18,
                      width: width / 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Select4
                            ? notifier.backGround
                            : notifier.isDark
                                ? Colors.yellow
                                : Colors.yellow,
                        border: Border.all(
                          color: Select4 ? notifier.textColor : Colors.black,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Education",
                          style: TextStyle(
                            fontSize: 14,
                            color: Select4
                                ? notifier.subtitleTextColor
                                : notifier.isDark
                                    ? Colors.black
                                    : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              AppConstants.Height(height / 40),
              InkWell(
                onTap: () {
                  setState(
                    () {
                      Select5 = !Select5;
                    },
                  );
                },
                child: Container(
                  height: height / 18,
                  width: width / 2.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Select5
                        ? notifier.backGround
                        : notifier.isDark
                            ? Colors.yellow
                            : Colors.yellow,
                    border: Border.all(
                      color: Select5 ? notifier.textColor : Colors.black,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Workshops",
                      style: TextStyle(
                        fontSize: 14,
                        color: Select5
                            ? notifier.subtitleTextColor
                            : notifier.isDark
                                ? Colors.black
                                : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              AppConstants.Height(height / 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomBarScreen(),
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
              "Apply",
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
