// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorNotifire with ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  ColorNotifire() {
    _loadTheme();
  }

  void isavalable(bool value) async {
    _isDark = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }


  get backGround => isDark ? const Color(0xff131313): const Color(0xffFFFFFF);
  get inv => isDark ? const Color(0xffFFFFFF) : const Color(0xff131313);
  get textColor1 => isDark ? const Color(0xffD1E50C): const Color(0xff131313);
  get textColor => isDark ? const Color(0xffFFFFFF): const Color(0xff131313);
  get subtitleTextColor => isDark ? const Color(0xffB6B6C0): const Color(0xff131313);
  get onBoard => isDark ? const Color(0xff9DAC09): const Color(0xff6C6D80);
  get onBoardTextColor => isDark ? const Color(0xffB6B6C0): const Color(0xff6C6D80);
  get welcomeTextColor => isDark ? const Color(0xff131313): const Color(0xffD1E50C);
  get confirmButton => isDark?const Color(0xffD1E50C):const Color(0xffFFFFFF);
  get imageColor => isDark?const Color(0xff131313):const Color(0xffD1E50C);
  get category => isDark?const Color(0xffD1E50C):const Color(0xff131313);
  get containerColor => isDark ? const Color(0xff1E1E1E) : const Color(0xffF5F5F5);
  get textFieldBackground => isDark ? const Color(0xff1E1E1E) : Colors.white;


  get shadowColor => const Color(0xFF000000).withAlpha(26);

  get hintTextColor => isDark ? const Color(0xffB6B6C0) : Colors.black54;
  get iconColor => isDark ? const Color(0xffB6B6C0) : Colors.black54;
  get svgColor => const Color(0xFF000000);
  get buttonColor => const Color(0xffD1E50C);
  get buttonTextColor => const Color(0xff131313);


}