// ignore_for_file: file_names, non_constant_identifier_names
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/AppConstants.dart';
import '../../config/dark_mode.dart';
import '../../providers/AuthProvider.dart';
import '../../providers/HomeProvider.dart';
import 'EventDetailScreen.dart';
import 'package:geocoding/geocoding.dart';


class All extends StatefulWidget {
  const All({super.key});

  @override
  State<All> createState() => _AllState();
}

class _AllState extends State<All> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  ColorNotifire notifier = ColorNotifire();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      value: 1.0,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchEvents();
      });
    }
  }

  Future<void> _fetchEvents() async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    try {
      final position = homeProvider.lastKnownPosition ??
          await homeProvider.getCurrentPosition();

      await homeProvider.fetchAllEvents(position.latitude, position.longitude);
    } catch (e) {
      // Manejo de errores
    }
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    final homeProvider = Provider.of<HomeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    homeProvider.setAuthProvider(authProvider);

    final nearbyEvents = homeProvider.nearbyEvents;
    final trendingEvents = homeProvider.trendingEvents;
    final isBusinessUser = homeProvider.isBusinessUser;

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: notifier.backGround,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppConstants.Height(height / 30),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: nearbyEvents.take(2).map((event) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Event_detail(eventId: event['id']),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        height: height / 3,
                        width: width / 1.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          image: DecorationImage(
                            image: event['photo'] != null && event['photo'].toString().isNotEmpty
                                ? NetworkImage(event['photo'])
                                : const AssetImage('assets/Splash 3.png') as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.5),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child:
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event['title'] ?? 'Sin título',
                                    style: const TextStyle(
                                      fontFamily: "Ariom-Bold",
                                      fontSize: 26,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/Clock.png',
                                        width: 18,
                                        height: 18,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        event['startDate']?['seconds'] != null
                                            ? DateFormat("dd-MM-yyyy 'a las' HH:mm").format(
                                            DateTime.fromMillisecondsSinceEpoch(event['startDate']['seconds'] * 1000))
                                            : 'Fecha no disponible',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/location.png',
                                        width: 18,
                                        height: 18,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 6),
                                      FutureBuilder<String>(
                                        future: event['location'] != null && !event['location'].toString().startsWith('(')
                                            ? Future.value(event['location'])
                                            : (event['latitud'] != null && event['longitud'] != null
                                            ? getCityFromCoordinates(event['latitud'], event['longitud'])
                                            : Future.value('Ubicación no disponible')),
                                        builder: (context, snapshot) {
                                          return Text(
                                            snapshot.data ?? 'Ubicación no disponible',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              AppConstants.Height(height / 30),
              Row(
                children: [
                  Text(
                    isBusinessUser ? "Mis eventos" : "Eventos cercanos",
                    style: TextStyle(
                      fontSize: 28,
                      color: notifier.textColor,
                      fontFamily: "Ariom-Bold",
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              AppConstants.Height(height / 40),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: trendingEvents.length,
                itemBuilder: (_, index) {
                  final event = trendingEvents[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Event_detail(eventId: event['id']),
                        ),
                      );
                    },
                    child: trendingEventCard(
                      image: event['photo'],
                      name: event['title'],
                      time: event['startDate']?['seconds'] != null
                          ? DateTime.fromMillisecondsSinceEpoch(event['startDate']['seconds'] * 1000).toIso8601String()
                          : null,
                      location: event['location'],
                      lat: event['latitud'],
                      lng: event['longitud'],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget trendingEventCard({
    required String? image,
    required String? name,
    required String? time,
    required String? location,
    double? lat,
    double? lng,
  }) {
    String formattedTime = 'Fecha no disponible';
    if (time != null) {
      try {
        DateTime dateTime = DateTime.parse(time);
        formattedTime = DateFormat("dd-MM-yyyy 'a las' HH:mm").format(dateTime);
      } catch (_) {}
    }

    Widget locationWidget;
    if (location != null && !location.startsWith('(')) {
      locationWidget = Text(location, style: const TextStyle(fontSize: 13));
    } else if (lat != null && lng != null) {
      locationWidget = FutureBuilder<String>(
        future: getCityFromCoordinates(lat, lng),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Cargando ciudad...', style: TextStyle(fontSize: 13));
          }
          return Text(snapshot.data ?? 'Ubicación no disponible', style: const TextStyle(fontSize: 13));
        },
      );
    } else {
      locationWidget = const Text('Ubicación no disponible', style: TextStyle(fontSize: 13));
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: notifier.backGround,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: notifier.inv.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(image ?? 'https://via.placeholder.com/150'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name ?? 'Sin título',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: notifier.inv,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formattedTime,
                      style: TextStyle(
                        fontSize: 14,
                        color: notifier.inv,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 13,
                        color: notifier.inv,
                      ),
                      child: locationWidget,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getCityFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        return placemarks.first.locality ?? 'Ciudad desconocida';
      }
    } catch (_) {}
    return 'Ciudad desconocida';
  }

}

