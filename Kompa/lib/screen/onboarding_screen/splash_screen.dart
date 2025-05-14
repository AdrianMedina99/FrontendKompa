import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../dark_mode.dart';
import '../sign_in/loginScreen.dart';

class Splash_screen extends StatefulWidget {
  const Splash_screen({super.key});

  @override
  State<Splash_screen> createState() => _Splash_screenState();
}

class _Splash_screenState extends State<Splash_screen> {
  ColorNotifire notifier = ColorNotifire();

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() {
    Future.delayed(
      const Duration(seconds: 3),
          () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Welcome()),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: notifier.backGround,
      body: Center(
        child: Container(
          height: height / 3,
          width: width / 1.2,
          child: Image.asset(
            "assets/kompaLogo.png",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
