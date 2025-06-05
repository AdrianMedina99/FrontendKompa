// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/dark_mode.dart';
import '../Home/HomeScreen.dart';
import '../category/CategoryScreen.dart';
import '../laQuedada/MisQuedadas.dart';
import '../profile/ProfileScreen.dart';
import '../../providers/AuthProvider.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int currentIndex = 0;
  ColorNotifire notifier = ColorNotifire();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    final isBusiness = (authProvider.userType == "BUSINESS" || authProvider.userType == "business");
    final userId = Provider.of<AuthProvider>(context, listen: false).userId;

    // Definir las pantallas y los items según el tipo de usuario
    final List<Widget> myChildren = isBusiness
        ? [
            const Home(),
            const CategoryScreen(),
            const profile(),
          ]
        : [
            const Home(),
            const CategoryScreen(),
            MisQuedadas(userId: userId ?? ''),
            const profile(),
          ];

    final List<BottomNavigationBarItem> items = isBusiness
        ? [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Image.asset(
                  "assets/Home Bottom.png",
                  color: notifier.onBoard,
                  height: height / 30,
                ),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Image.asset(
                  "assets/Home Bottom.png",
                  height: height / 30,
                  color: notifier.isDark
                      ? const Color(0xff131313)
                      : const Color(0xffD1E50C),
                ),
              ),
              label: "Inicio",
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Image.asset(
                  "assets/category.png",
                  color: notifier.onBoard,
                  height: height / 27,
                ),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Image.asset(
                  "assets/category.png",
                  height: height / 27,
                  color: notifier.isDark
                      ? const Color(0xff131313)
                      : const Color(0xffD1E50C),
                ),
              ),
              label: "Categorias",
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Image.asset(
                  "assets/Profile Bottom.png",
                  color: notifier.onBoard,
                  height: height / 30,
                ),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Image.asset(
                  "assets/Profile Bottom.png",
                  height: height / 30,
                  color: notifier.isDark
                      ? const Color(0xff131313)
                      : const Color(0xffD1E50C),
                ),
              ),
              label: "Perfil",
            ),
          ]
        : [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Image.asset(
                  "assets/Home Bottom.png",
                  color: notifier.onBoard,
                  height: height / 30,
                ),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Image.asset(
                  "assets/Home Bottom.png",
                  height: height / 30,
                  color: notifier.isDark
                      ? const Color(0xff131313)
                      : const Color(0xffD1E50C),
                ),
              ),
              label: "Inicio",
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Image.asset(
                  "assets/category.png",
                  color: notifier.onBoard,
                  height: height / 27,
                ),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Image.asset(
                  "assets/category.png",
                  height: height / 27,
                  color: notifier.isDark
                      ? const Color(0xff131313)
                      : const Color(0xffD1E50C),
                ),
              ),
              label: "Categorias",
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Image.asset(
                  "assets/Message.png",
                  color: notifier.onBoard,
                  height: height / 30,
                ),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Image.asset(
                  "assets/Message.png",
                  color: notifier.isDark
                      ? const Color(0xff131313)
                      : const Color(0xffD1E50C),
                  height: height / 30,
                ),
              ),
              label: "Quedadas",
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Image.asset(
                  "assets/Profile Bottom.png",
                  color: notifier.onBoard,
                  height: height / 30,
                ),
              ),
              activeIcon: Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Image.asset(
                  "assets/Profile Bottom.png",
                  height: height / 30,
                  color: notifier.isDark
                      ? const Color(0xff131313)
                      : const Color(0xffD1E50C),
                ),
              ),
              label: "Perfil",
            ),
          ];

    // Ajustar el currentIndex si es necesario
    int effectiveIndex = currentIndex;
    if (isBusiness && currentIndex > 2) {
      effectiveIndex = 0;
    }

    return Scaffold(
      backgroundColor: notifier.backGround,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(25),
        ),
        child: BottomNavigationBar(
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedItemColor: notifier.isDark
              ? const Color(0xff131313)
              : const Color(0xffD1E50C),
          unselectedItemColor: notifier.isDark
              ? const Color(0xff9DAC09)
              : const Color(0xff6C6D80),
          backgroundColor: notifier.textColor1,
          type: BottomNavigationBarType.fixed,
          currentIndex: effectiveIndex,
          elevation: 0,
          onTap: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: items,
        ),
      ),
      body: myChildren[effectiveIndex],
    );
  }
}
