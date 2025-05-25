// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorNotifire with ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  final Color _white = const Color(0xffFFFFFF);
  final Color _black = const Color(0xff131313);
  final Color _darkGray = const Color(0xff1E1E1E);
  final Color _lightGray = const Color(0xffF5F5F5);
  final Color _mediumGray = const Color(0xffB6B6C0);
  final Color _accentGreen = const Color(0xffD1E50C);
  final Color _lightGreen = const Color(0xFFA7B709);
  final Color _darkGreen = const Color(0xff9DAC09);
  final Color _darkBlueGray = const Color(0xff6C6D80);
  final Color _transparentBlack = Colors.black54;
  
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

  get backGround => isDark ? _black : _white;
  get inv => isDark ? _white : _black;
  get textColor1 => isDark ? _accentGreen : _black;
  get textColor => isDark ? _white : _black;
  get subtitleTextColor => isDark ? _mediumGray : _black;
  get onBoard => isDark ? _darkGreen : _darkBlueGray;
  get onBoardTextColor => isDark ? _mediumGray : _darkBlueGray;
  get welcomeTextColor => isDark ? _black : _accentGreen;
  get confirmButton => isDark ? _accentGreen : _white;
  get imageColor => isDark ? _black : _accentGreen;
  get category => isDark ? _accentGreen : _black;
  get containerColor => isDark ? _darkGray : _lightGray;
  get textFieldBackground => isDark ? _darkGray : _white;
  
  get shadowColor => const Color(0xFF000000).withAlpha(26);
  
  get hintTextColor => isDark ? _mediumGray : _transparentBlack;
  get iconColor => isDark ? _mediumGray : _transparentBlack;
  get svgColor => const Color(0xFF000000);
  get buttonColor => isDark ? _accentGreen : _lightGreen;
  get buttonTextColor => _black;
}
