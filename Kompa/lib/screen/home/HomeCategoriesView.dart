// ignore_for_file: file_names

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../Config/common.dart';
import '../../dark_mode.dart';
import '../../providers/HomeProvider.dart';
import '../../providers/AuthProvider.dart';
import 'package:geocoding/geocoding.dart';

import 'Event_detail.dart';

class HomeCategoriesView extends StatefulWidget {
  final String categoryId;
  final String categoryTitle;

  const HomeCategoriesView({
    Key? key,
    required this.categoryId,
    required this.categoryTitle,
  }) : super(key: key);

  @override
  State<HomeCategoriesView> createState() => _HomeCategoriesViewState();
}

class _HomeCategoriesViewState extends State<HomeCategoriesView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  ColorNotifire notifier = ColorNotifire();
  bool _initialized = false;
  final List<Map<String, dynamic>> _filteredEvents = [];

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
  void dispose() {
    _controller.dispose();
    super.dispose();
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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    homeProvider.setAuthProvider(authProvider);

    try {
      if (homeProvider.isBusinessUser && homeProvider.currentUserId != null) {
        final businessEvents = await homeProvider.apiService.getEventsByBusinessId(homeProvider.currentUserId!);
        final filtered = businessEvents.where((event) => event['categoryId'] == widget.categoryId).toList();
        homeProvider.trendingEvents.clear();
        homeProvider.trendingEvents.addAll(List<Map<String, dynamic>>.from(filtered));
        homeProvider.notifyListeners();
      } else {
        final position = homeProvider.lastKnownPosition ??
            await homeProvider.getCurrentPosition();

        await homeProvider.fetchEventsByCategory(
            position.latitude,
            position.longitude,
            widget.categoryId
        );
      }
    } catch (e) {
      // Manejo de errores
    }
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    final homeProvider = Provider.of<HomeProvider>(context);
    final trendingEvents = homeProvider.trendingEvents;

    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: notifier.backGround,
      body: homeProvider.isLoading
          ? Center(child: CircularProgressIndicator(color: notifier.buttonColor))
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppConstants.Height(height / 30),
              Text(
                "Eventos de ${widget.categoryTitle}",
                style: TextStyle(
                  fontSize: 28,
                  color: notifier.textColor,
                  fontFamily: "Ariom-Bold",
                ),
              ),
              AppConstants.Height(height / 30),
              if (trendingEvents.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: height / 4),
                    child: Text(
                      "No hay eventos disponibles en esta categoría",
                      style: TextStyle(
                        color: notifier.textColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: trendingEvents.length,
                  itemBuilder: (_, index) {
                    final event = trendingEvents[index];
                    return eventCard(
                      image: event['photo'],
                      name: event['title'],
                      time: event['startDate']?['seconds'] != null
                          ? DateTime.fromMillisecondsSinceEpoch(
                          event['startDate']['seconds'] * 1000)
                          .toIso8601String()
                          : null,
                      location: event['location'],
                      lat: event['latitud'],
                      lng: event['longitud'],
                    );
                  },
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget eventCard({
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
      locationWidget = const Text('Ubicación no disponible', style: const TextStyle(fontSize: 13));
    }

    return InkWell(
      onTap: () {
        final event = _filteredEvents.firstWhere(
              (e) => e['title'] == name && e['photo'] == image,
          orElse: () => {},
        );

        if (event.isNotEmpty && event['id'] != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Event_detail(eventId: event['id']),
            ),
          );
        }
      },
      child: Padding(
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
                      image: image != null && image.isNotEmpty
                          ? NetworkImage(image)
                          : const NetworkImage('https://via.placeholder.com/150'),
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
