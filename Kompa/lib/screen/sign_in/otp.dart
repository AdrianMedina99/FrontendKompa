// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:provider/provider.dart';
import '../../config/AppConstants.dart';
import '../../config/dark_mode.dart';

class Otp extends StatefulWidget {
  const Otp({super.key});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
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
          padding:  const EdgeInsets.only(left: 15),
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
      ),
      body: Padding(
        padding:  const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppConstants.Height(height / 30),
            Text(
              "OTP confirmation",
              style: TextStyle(
                color: notifier.textColor,
                fontFamily: "Ariom-Bold",
                fontSize: 22,
              ),
            ),
            AppConstants.Height(height / 50),
             const Text(
              "We sent you confirmation code to your phone number ",
              style: TextStyle(
                color: Color(0xff6C6D80),
                fontFamily: "Ariom-Regular",
                fontSize: 19,
              ),
            ),
            AppConstants.Height(height / 30),
            OtpTextField(
              textStyle: TextStyle(
                fontSize: 30,
                fontFamily: "Ariom-Bold",
                color: notifier.textColor,
              ),
              numberOfFields: 4,
              focusedBorderColor:  const Color(0xffD1E50C),
              showFieldAsBox: false,
              borderWidth: 2,
              keyboardType: TextInputType.number,
              clearText: true,
              enabledBorderColor: notifier.onBoardTextColor,
              fieldWidth: width / 7,
              margin:  const EdgeInsets.only(left: 15, right: 15),
              onCodeChanged: (String code) {},
              onSubmit: (String verificationCode) {},
            ),
            AppConstants.Height(height / 9),
            TweenAnimationBuilder<Duration>(
              duration:  const Duration(hours: 5),
              tween: Tween(
                begin:  const Duration(hours: 5),
                end: Duration.zero,
              ),
              onEnd: () {},
              builder: (BuildContext context, Duration value, Widget? child) {
                final seconds = value.inSeconds % 60;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            elevation: 0,
                            backgroundColor: notifier.backGround,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            title: Column(
                              children: [
                                Text(
                                  "Oh No!",
                                  style: TextStyle(
                                    color: notifier.textColor,
                                    fontSize: 27,
                                    fontFamily: "Ariom-Bold",
                                  ),
                                ),
                                AppConstants.Height(height / 40),
                                Text(
                                  "Your account will be locked for 5 mins",
                                  style: TextStyle(
                                    color: notifier.onBoardTextColor,
                                    fontSize: 17,
                                  ),
                                ),
                                AppConstants.Height(height / 40),
                                Container(
                                  height: height / 15,
                                  // width: width/3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(17),
                                    color:  const Color(0xffD1E50C),
                                  ),
                                  child: TweenAnimationBuilder<Duration>(
                                    duration:  const Duration(hours: 5),
                                    tween: Tween(
                                        begin:  const Duration(hours: 5),
                                        end: Duration.zero,),
                                    onEnd: () {},
                                    builder: (BuildContext context,
                                        Duration value, Widget? child) {
                                      final minutes = value.inMinutes % 30;
                                      final seconds = value.inSeconds % 60;
                                      return Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "${minutes}m ",
                                                      style:  const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 19,
                                                        fontFamily:
                                                            "Ariom-Bold",
                                                      ),
                                                    ),
                                                     const Text(
                                                      ": ",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 19,
                                                        fontFamily:
                                                            "Ariom-Bold",
                                                      ),
                                                    ),
                                                    Text(
                                                      "${seconds}s ",
                                                      style:  const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 19,
                                                        fontFamily:
                                                            "Ariom-Bold",
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "Resend code\t",
                        style: TextStyle(
                          fontSize: 15,
                          color: notifier.textColor,
                        ),
                      ),
                    ),
                    Text(
                      "(${seconds}s) ",
                      style: TextStyle(
                        color: notifier.textColor,
                        fontSize: 15,
                        fontFamily: "Ariom-Bold",
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
