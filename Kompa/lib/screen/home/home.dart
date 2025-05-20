// ignore_for_file: file_names

import 'package:kompa/Config/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../dark_mode.dart';
import '../../providers/AuthProvider.dart';
import 'all.dart';
import 'concert.dart';
import 'notification.dart';
import 'search.dart';
import 'sport.dart';
import 'theatre.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  String? _cityName;
  String? _userName;
  int currentIndex = 0;
  ColorNotifire notifier = ColorNotifire();

  @override
  void initState() {
    super.initState();
    _getLocation();
    Future.microtask(() async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.getCurrentUserData().then((userData) {
        setState(() {
          _userName = userData['nombre'] ?? "Usuario";
        });
      }).catchError((error) {
        setState(() {
          _userName = "Usuario";
        });
      });
    });
  }

  Future<void> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _cityName = "Ubicación desactivada";
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _cityName = "Permiso denegado";
        });
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _cityName = "Permiso denegado permanentemente";
      });
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        setState(() {
          _cityName = placemarks.first.locality ?? "Ubicación desconocida";
        });
      }
    } catch (e) {
      setState(() {
        _cityName = "Error obteniendo ubicación";
      });
    }
  }

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
        leading:  const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Row(
            children: [
              CircleAvatar(
                foregroundImage: AssetImage("assets/Profile.jpeg"),
              ),
            ],
          ),
        ),
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hola, ${_userName ?? "Usuario"}",
                  style: TextStyle(
                    color: notifier.textColor,
                    fontFamily: "Ariom-Bold",
                    fontSize: 20,
                  ),
                ),
                Row(
                  children: [
                    Image.asset(
                      "assets/location.png",
                      scale: 3,color: notifier.textColor,
                    ),
                    AppConstants.Width(width / 50),
                    Text(
                      _cityName ?? "Cargando...",
                      style: TextStyle(
                        color: notifier.subtitleTextColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const notification(),
                ),
              );
            },
            child: Image.asset(
              "assets/notification.png",
              scale: 3,color: notifier.textColor,
            ),
          ),
          AppConstants.Width(width / 50),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Search(),
                ),
              );
            },
            child: Image.asset(
              "assets/Search.png",
              scale: 3,color: notifier.textColor,
            ),
          ),
          AppConstants.Width(width / 50),
        ],
      ),
      body: DefaultTabController(
        length: 4,
        initialIndex: 0,
        child: Column(
          children: [
            AppConstants.Height(height / 40),
            TabBar(
              padding: const EdgeInsets.only(bottom: 8),
              physics:  const BouncingScrollPhysics(),
              labelColor:  const Color(0xff131313),
              labelStyle:  const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: "Manrope_bold",
                letterSpacing: 0.2,
              ),
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.label,
              unselectedLabelColor:  const Color(0xff6C6D80),
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:  const Color(0xffD1E50C),
              ),
              tabs: [
                Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child:  const Tab(
                    child: Text(
                      "All",
                      style: TextStyle(
                        fontFamily: "Ariom-Regular",
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:  const Tab(
                    child: Text(
                      "Concert",
                      style: TextStyle(
                        fontFamily: "Ariom-Regular",
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:  const Tab(
                    child: Text(
                      "Sport",
                      style: TextStyle(
                        fontFamily: "Ariom-Regular",
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:  const Tab(
                    child: Text(
                      "Theatre",
                      style: TextStyle(
                        fontFamily: "Ariom-Regular",
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  All(),
                  Concert(),
                  Sport(),
                  Theatre(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
