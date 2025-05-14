// ignore_for_file: file_names, camel_case_types

import 'package:book_my_seat/book_my_seat.dart';
import 'package:kompa/Config/common.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../dark_mode.dart';
import 'summary.dart';

class ticket1 extends StatefulWidget {
  const ticket1({Key? key}) : super(key: key);

  @override
  State<ticket1> createState() => _ticket();
}

class _ticket extends State<ticket1> {
  List selectedSeats = [];
  List selectedSeats1 = [];
  int price = 600;
  int price1 = 0;
  int price_ = 600;
  int price1_ = 0;
  int one = 0;
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
          "Choose Seat(s)",
          style: TextStyle(
            fontSize: 24,
            color: notifier.textColor,
            fontFamily: "Urbanist-Bold",
          ),
        ),
      ),
      body: PageView(
        onPageChanged: (value) {
          setState(
            () {
              one = value;
            },
          );
        },
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Stack(
                  children: [
                    Image.asset("assets/Screen.png"),
                    Image.asset("assets/Shadow.png"),
                    Positioned(
                      top: 30,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          "Cinema Screen Here 1",
                          style: TextStyle(
                            color: notifier.isDark
                                ? const Color(0xffFFFFFF)
                                : const Color(0xff616161),
                            fontSize: 15,
                            // fontFamily: "Urbanist-Medium",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: SizedBox(
                    width: double.infinity,
                    height: 500,
                    child: SeatLayoutWidget(
                      onSeatStateChanged: (rowI, colI, seatState) {
                        if (seatState == SeatState.selected) {
                          setState(
                            () {
                              price1 += price;
                            },
                          );
                          selectedSeats.add("[$rowI][$colI]");
                        } else {
                          setState(
                            () {
                              selectedSeats.remove(
                                "[$rowI][$colI]",
                              );
                              price1 -= price;
                            },
                          );
                        }
                      },
                      stateModel: SeatLayoutStateModel(
                        pathDisabledSeat: 'assets/seat 4.svg',
                        pathSelectedSeat: 'assets/Seat 3 Dark.svg',
                        pathSoldSeat: 'assets/Seat 2 Dark.svg',
                        pathUnSelectedSeat: 'assets/Seat 1 Dark.svg',
                        rows: MediaQuery.of(context).size.height < 450 ? 8 : 11,
                        cols: MediaQuery.of(context).size.width < 450 ? 13 : 14,
                        seatSvgSize: 21,
                        currentSeatsState: const [
                          [
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.empty,
                            SeatState.empty,
                            // SeatState.empty,
                            // SeatState.empty,
                          ],
                          [
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.empty,
                            SeatState.empty,
                            // SeatState.empty,
                            // SeatState.empty,
                          ],
                          [
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.empty,
                            SeatState.empty,
                            // SeatState.empty,
                            // SeatState.empty,
                          ],
                          [
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.sold,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.empty,
                            SeatState.empty,
                            // SeatState.empty,
                            // SeatState.empty,
                          ],
                          [
                            SeatState.unselected,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.unselected,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.empty,
                            SeatState.empty,
                            // SeatState.empty,
                            // SeatState.empty,
                          ],
                          [
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.empty,
                            SeatState.empty,
                            // SeatState.empty,
                            // SeatState.empty,
                          ],
                          [
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.empty,
                            SeatState.empty,
                            // SeatState.empty,
                            // SeatState.empty,
                          ],
                          [
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.sold,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.empty,
                            SeatState.empty,
                            // SeatState.empty,
                            // SeatState.empty,
                          ],
                          [
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.empty,
                            SeatState.empty,
                            // SeatState.empty,
                            // SeatState.empty,
                          ],
                          [
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.sold,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.empty,
                            SeatState.empty,
                            // SeatState.empty,
                            // SeatState.empty,
                          ],
                          [
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.empty,
                            SeatState.empty,
                            // SeatState.empty,
                            // SeatState.empty,
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      margin: const EdgeInsets.only(right: 5),
                      height: 10,
                      curve: Curves.easeIn,
                      width: one == 0 ? 20 : 10,
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: notifier.textColor,
                      ),
                      margin: const EdgeInsets.only(right: 5),
                      height: 10,
                      curve: Curves.easeIn,
                      width: one == 1 ? 20 : 10,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/Seat 2 Dark.svg',
                            width: 20,
                            height: 20,
                          ),
                          AppConstants.Width(width / 40),
                          Text(
                            'Sold',
                            style: TextStyle(color: notifier.textColor),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/Seat 1 Dark.svg',
                            width: 20,
                            height: 20,
                          ),
                          AppConstants.Width(width / 40),
                          Text(
                            'Available',
                            style: TextStyle(color: notifier.textColor),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/Seat 3 Dark.svg',
                            width: 20,
                            height: 20,
                          ),
                          AppConstants.Width(width / 40),
                          Text(
                            'Selected by you',
                            style: TextStyle(color: notifier.textColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Container(
                        height: height / 10,
                        width: width / 2.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: notifier.textColor,
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                "Total price",
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontSize: 14,
                                  // fontFamily: "Urbanist-Regular",
                                ),
                              ),
                            ),
                            AppConstants.Height(height / 60),
                            Text(
                              "$price1",
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily: "Ariom-Bold",
                                color: notifier.textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: height / 10,
                        width: width / 2.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: notifier.textColor,
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                "Seat(s)",
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontSize: 14,
                                  // fontFamily: "Urbanist-Regular",
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height / 17,
                              width: width / 2.5,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: selectedSeats.length,
                                itemBuilder: (context, index) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 5,
                                        right: 5,
                                      ),
                                      child: Text(
                                        selectedSeats[index].toString(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: "Ariom-Bold",
                                          color: notifier.textColor,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 16),
                Stack(
                  children: [
                    Image.asset("assets/Screen.png"),
                    Image.asset("assets/Shadow.png"),
                    Positioned(
                      top: 30,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          "Cinema Screen Here 2",
                          style: TextStyle(
                            color: notifier.isDark
                                ? const Color(0xffFFFFFF)
                                : const Color(0xff616161),
                            fontSize: 15,
                            // fontFamily: "Urbanist-Medium",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: SizedBox(
                    width: double.infinity,
                    height: 500,
                    child: SeatLayoutWidget(
                      onSeatStateChanged: (rowI, colI, seatState) {
                        if (seatState == SeatState.selected) {
                          setState(() {});
                          selectedSeats1.add(
                            "[$rowI][$colI]",
                          );
                          setState(() {
                            price1_ += price_;
                          });
                        } else {
                          setState(() {
                            price1_ -= price_;
                            selectedSeats1.remove(
                              "[$rowI][$colI]",
                            );
                          });
                        }
                      },
                      stateModel: SeatLayoutStateModel(
                        pathDisabledSeat: 'assets/seat 4.svg',
                        pathSelectedSeat: 'assets/Seat 3 Dark.svg',
                        pathSoldSeat: 'assets/Seat 2 Dark.svg',
                        pathUnSelectedSeat: 'assets/Seat 1 Dark.svg',
                        rows: MediaQuery.of(context).size.height < 450 ? 8 : 11,
                        cols: MediaQuery.of(context).size.width < 450 ? 13 : 14,
                        seatSvgSize: 21,
                        currentSeatsState: const [
                          [
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.empty,
                            SeatState.empty,
                            // SeatState.empty,
                            // SeatState.empty,
                          ],
                          [
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.sold,
                            SeatState.empty,
                            SeatState.empty,
                            // SeatState.empty,
                            // SeatState.empty,
                          ],
                          [
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.empty,
                            SeatState.empty,
                            // SeatState.empty,
                            // SeatState.empty,
                          ],
                          [
                            SeatState.unselected,
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.empty,
                            SeatState.empty,
                            // SeatState.empty,
                            // SeatState.empty,
                          ],
                          [
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.sold,
                            SeatState.empty,
                            SeatState.empty,
                            // SeatState.empty,
                            // SeatState.empty,
                          ],
                          [
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.sold,
                            SeatState.empty,
                            SeatState.empty,
                            // SeatState.empty,
                            // SeatState.empty,
                          ],
                          [
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.empty,
                            SeatState.empty,
                            // SeatState.empty,
                            // SeatState.empty,
                          ],
                          [
                            SeatState.unselected,
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.unselected,
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.empty,
                            SeatState.empty,
                            // SeatState.empty,
                            // SeatState.empty,
                          ],
                          [
                            SeatState.unselected,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.unselected,
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.sold,
                            SeatState.empty,
                            SeatState.empty,
                            // SeatState.empty,
                            // SeatState.empty,
                          ],
                          [
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.unselected,
                            SeatState.sold,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.empty,
                            SeatState.empty,
                            // SeatState.empty,
                            // SeatState.empty,
                          ],
                          [
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.sold,
                            SeatState.empty,
                            SeatState.empty,
                            SeatState.sold,
                            SeatState.unselected,
                            SeatState.empty,
                            SeatState.empty,
                            // SeatState.empty,
                            // SeatState.empty,
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: notifier.textColor,
                      ),
                      margin: const EdgeInsets.only(right: 5),
                      height: 10,
                      curve: Curves.easeIn,
                      width: one == 0 ? 20 : 10,
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      margin: const EdgeInsets.only(right: 5),
                      height: 10,
                      curve: Curves.easeIn,
                      width: one == 1 ? 20 : 10,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/Seat 2 Dark.svg',
                            width: 20,
                            height: 20,
                          ),
                          AppConstants.Width(width / 40),
                          Text(
                            'Sold',
                            style: TextStyle(color: notifier.textColor),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/Seat 1 Dark.svg',
                            width: 20,
                            height: 20,
                          ),
                          AppConstants.Width(width / 40),
                          Text(
                            'Available',
                            style: TextStyle(color: notifier.textColor),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/Seat 3 Dark.svg',
                            width: 20,
                            height: 20,
                          ),
                          AppConstants.Width(width / 40),
                          Text(
                            'Selected by you',
                            style: TextStyle(color: notifier.textColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Container(
                        height: height / 10,
                        width: width / 2.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: notifier.textColor,
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                "Total price",
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontSize: 14,
                                  // fontFamily: "Urbanist-Regular",
                                ),
                              ),
                            ),
                            AppConstants.Height(height / 60),
                            Text(
                              "$price1_",
                              style: TextStyle(
                                fontSize: 24,
                                fontFamily: "Ariom-Bold",
                                color: notifier.textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: height / 10,
                        width: width / 2.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: notifier.textColor,
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                "Seat(s)",
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontSize: 14,
                                  // fontFamily: "Urbanist-Regular",
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height / 17,
                              width: width / 2.5,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: selectedSeats1.length,
                                itemBuilder: (context, index) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 5,
                                        right: 5,
                                      ),
                                      child: Text(
                                        selectedSeats1[index].toString(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: "Ariom-Bold",
                                          color: notifier.textColor,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 10,
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Summary(),
              ),
            );
            setState(() {});
          },
          child: Container(
            height: height / 12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(45),
              color: Colors.red,
            ),
            child: const Center(
              child: Text(
                "Continue",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xffFFFFFF),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SeatNumber {
  final int rowI;
  final int colI;

  const SeatNumber({required this.rowI, required this.colI});

  @override
  bool operator ==(Object other) {
    return rowI == (other as SeatNumber).rowI && colI == (other).colI;
  }

  @override
  int get hashCode => rowI.hashCode;

  @override
  String toString() {
    return '[$rowI][$colI]';
  }
}
