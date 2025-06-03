// ignore_for_file: file_names

import 'package:kompa/config/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/dark_mode.dart';
import '../../providers/AuthProvider.dart';
import '../../providers/CategoryProvider.dart';
import '../../providers/HomeProvider.dart';
import '../common/notification.dart';
import 'HomeCategoriesView.dart';
import 'AllScreen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:kompa/screen/common/SearchScreen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  //============
  // Variables
  //============
  String? _cityName;
  String? _userName;
  int currentIndex = 0;
  ColorNotifire notifier = ColorNotifire();
  late Future<void> _fetchFuture;
  bool _showedWelcomeMessage = false; 

  @override
  void initState() {
    super.initState();
    _getLocation();
    _fetchFuture = Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    Future.microtask(() async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.getCurrentUserData().then((userData) {
        setState(() {
          _userName = userData['nombre'] ?? "Usuario";
        });

        authProvider.updateUserDataState(userData);

        if (!_showedWelcomeMessage && mounted) {
          _showedWelcomeMessage = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Bienvenido, $_userName'),
                backgroundColor: const Color(0xff4CAF50),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
              ),
            );
          });
        }
      }).catchError((error) {
        setState(() {
          _userName = "Usuario";
        });
      });
    });
  }

  ///Metodo para obtener la ubicación del usuario
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
    //==========
    // Providers
    //===========
    final notifier = Provider.of<ColorNotifire>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    final userPhoto = authProvider.userData?['photo'];

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: notifier.backGround,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: notifier.backGround,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.transparent,
              foregroundImage: (userPhoto != null && userPhoto.isNotEmpty && userPhoto.startsWith('http'))
                  ? NetworkImage(userPhoto)
                  : const AssetImage('assets/Profile.png') as ImageProvider,
              child: (userPhoto == null || userPhoto.isEmpty)
                  ? const Icon(Icons.person, color: Colors.grey)
                  : null,
            ),
            AppConstants.Width(width / 50),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi, ${_userName ?? "Usuario"}",
                  style: TextStyle(
                    color: notifier.textColor,
                    fontSize: 20,
                    fontFamily: "Ariom-Bold",
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _cityName ?? "Ubicación desconocida",
                  style: TextStyle(
                    color: notifier.subtitleTextColor,
                    fontSize: 14,
                    fontFamily: "Ariom-Regular",
                  ),
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
              scale: 3,
              color: notifier.textColor,
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
              scale: 3,
              color: notifier.textColor,
            ),
          ),
          AppConstants.Width(width / 50),
        ],
      ),
      body: FutureBuilder(
        future: _fetchFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: notifier.buttonColor,
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error al cargar categorías",
                style: TextStyle(color: notifier.textColor),
              ),
            );
          }

          final categories = categoryProvider.categories;

          return DefaultTabController(
            length: categories.length + 1,
            child: Column(
              children: [
                AppConstants.Height(height / 40),
                TabBar(
                  padding: const EdgeInsets.only(bottom: 8),
                  physics: const BouncingScrollPhysics(),
                  labelColor: const Color(0xff131313),
                  labelStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Manrope_bold",
                    letterSpacing: 0.2,
                  ),
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.label,
                  unselectedLabelColor: const Color(0xff6C6D80),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xffD1E50C),
                  ),
                  tabs: [
                    Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Tab(
                        child: Text(
                          "All",
                          style: TextStyle(
                            fontFamily: "Ariom-Regular",
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    ...categories.map((category) {
                      return Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Tab(
                          child: Text(
                            category['title'],
                            style: const TextStyle(
                              fontFamily: "Ariom-Regular",
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      const All(),
                      ...categories.map((category) {
                        return Consumer<HomeProvider>(
                          builder: (context, homeProvider, child) {
                            if (homeProvider.isLoading) {
                              return ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: 5,
                                itemBuilder: (_, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16.0),
                                    child: Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: notifier.backGround.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                            return HomeCategoriesView(
                              categoryId: category['id'],
                              categoryTitle: category['title'],
                            );
                          },
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

