import 'dart:async';

import 'package:kompa/config/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kompa/providers/HomeProvider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart'; // Asegurarse de importar intl
import 'package:geolocator/geolocator.dart';

import '../../config/dark_mode.dart';
import 'FilterScreen.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  //============
  // Variables
  //============
  ColorNotifire notifier = ColorNotifire();
  List<Map<String, dynamic>> allEvents = [];
  List<Map<String, dynamic>> filteredEvents = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAllEvents();
    searchController.addListener(_filterEvents);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  ///Metodo para cargar todos los eventos al iniciar la pantalla
  Future<void> _loadAllEvents() async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    try {
      final events = await homeProvider.apiService.getAllEvents();
      setState(() {
        allEvents = List<Map<String, dynamic>>.from(events);
        filteredEvents = allEvents;
      });
    } catch (e) {
      print("Error al cargar eventos: $e");
    }
  }

  ///Metodo para filtrar los eventos basados en la busqueda y los filtros aplicados
  void _filterEvents({Map<String, dynamic>? filters}) async {
    final query = searchController.text.toLowerCase();
    List<Map<String, dynamic>> filtered = allEvents;

    if (query.isNotEmpty) {
      filtered = filtered
          .where((event) =>
              event['title'] != null &&
              event['title'].toString().toLowerCase().contains(query))
          .toList();
    }

    if (filters != null) {
      // Distancia
      if (filters['distance'] != null && filters['distance'] > 0 && filters['position'] != null) {
        final double maxDistance = filters['distance'];
        final pos = filters['position'];
        filtered = filtered.where((event) {
          final eventLat = event['latitud'];
          final eventLng = event['longitud'];
          if (eventLat == null || eventLng == null) return false;
          final distance = Geolocator.distanceBetween(
                  pos.latitude, pos.longitude, eventLat, eventLng) /
              1000;
          return distance <= maxDistance;
        }).toList();
      }
      // Fechas
      if (filters['startDate'] != null && filters['endDate'] != null) {
        final DateTime start = filters['startDate'];
        final DateTime end = filters['endDate'];
        filtered = filtered.where((event) {
          final startDate = event['startDate'];
          if (startDate == null) return false;
          try {
            DateTime eventDate;
            if (startDate is Map && startDate['seconds'] != null) {
              eventDate = DateTime.fromMillisecondsSinceEpoch(startDate['seconds'] * 1000);
            } else if (startDate is String) {
              eventDate = DateTime.parse(startDate);
            } else {
              return false;
            }
            return !eventDate.isBefore(start) && !eventDate.isAfter(end);
          } catch (_) {
            return false;
          }
        }).toList();
      }
      // Categoría
      if (filters['categories'] != null && (filters['categories'] as List).isNotEmpty) {
        final List categories = filters['categories'];
        filtered = filtered.where((event) => categories.contains(event['categoryId'])).toList();
      }
      // Edad mínima
      if (filters['edad'] != null && filters['edad'] is int) {
        final int minEdad = filters['edad'];
        filtered = filtered.where((event) {
          final eventEdad = event['edad'];
          if (eventEdad == null) return false;
          return eventEdad >= minEdad;
        }).toList();
      }
    }

    setState(() {
      filteredEvents = filtered;
    });
  }

  ///Metodo para obtener la ciudad a partir de las coordenadas
  Future<void> getCityFromLatLng(double lat, double lng, Function(String) callback) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        callback(placemarks.first.locality ?? 'Ubicación desconocida');
      } else {
        callback('Ubicación desconocida');
      }
    } catch (e) {
      callback('Error obteniendo ubicación');
    }
  }

  ///Metodo para obtener la ciudad a partir de las coordenadas
  Future<String> getCityFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        return placemarks.first.locality ?? 'Ubicación desconocida';
      } else {
        return 'Ubicación desconocida';
      }
    } catch (e) {
      return 'Error obteniendo ubicación';
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
        centerTitle: true,
        backgroundColor: notifier.backGround,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
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
        title: Text(
          "Search",
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Ariom-Bold",
            color: notifier.textColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppConstants.Height(height / 40),
              Row(
                children: [
                  Container(
                    height: height / 14,
                    width: width / 1.30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: notifier.backGround,
                      border: Border.all(
                        color: notifier.textColor,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: TextField(
                        controller: searchController,
                        style: TextStyle(color: notifier.textColor),
                        decoration: InputDecoration(
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Image.asset(
                              "assets/Search.png",
                              scale: 3,
                              color: notifier.textColor,
                            ),
                          ),
                          hintText: "Buscar Eventos",
                          hintStyle: TextStyle(
                            color: notifier.textColor,
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.only(top: 20),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      final filters = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Filter(),
                        ),
                      );
                      if (filters != null && filters is Map<String, dynamic>) {
                        _filterEvents(filters: filters);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: height / 14,
                      width: width / 7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: notifier.textColor,
                      ),
                      child: Image.asset(
                        "assets/Filter.png",
                        scale: 2.5,
                        color: notifier.imageColor,
                      ),
                    ),
                  ),
                ],
              ),
              AppConstants.Height(height / 20),
              Text(
                "Eventos Encontrados",
                style: TextStyle(
                  color: notifier.textColor,
                  fontFamily: "Ariom-Bold",
                  fontSize: 32,
                ),
              ),
              AppConstants.Height(height / 40),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: filteredEvents.length,
                itemBuilder: (context, index) {

                  final event = filteredEvents[index];
                  String formattedTime = 'Fecha no disponible';

                  if (event['startDate'] != null) {
                    if (event['startDate'] is Map && event['startDate']['seconds'] != null) {
                      formattedTime = DateFormat("dd-MM-yyyy 'a las' HH:mm").format(
                          DateTime.fromMillisecondsSinceEpoch(event['startDate']['seconds'] * 1000));
                    } else if (event['startDate'] is String) {
                      try {
                        DateTime dt = DateTime.parse(event['startDate']);
                        formattedTime = DateFormat("dd-MM-yyyy 'a las' HH:mm").format(dt);
                      } catch (e) {
                        print('Error parsing date: $e');
                      }
                    }
                  }
                  final lat = event['latitud'];
                  final lng = event['longitud'];
                  Widget locationWidget;

                  if (event['location'] != null && !event['location'].toString().startsWith('(')) {
                    locationWidget = Text(event['location'], style: const TextStyle(fontSize: 13));
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

                  return Event1(
                    image: event['photo'] ?? '',
                    name: event['title'] ?? 'Sin título',
                    time: formattedTime,
                    locationWidget: locationWidget,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget Event1({
    required String image,
    required String name,
    required String time,
    required Widget locationWidget,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
          color: notifier.backGround,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: notifier.inv.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: SizedBox(
          width: double.maxFinite,
          height: 120,
          child: Row(
            children: [
              Container(
                height: 120,
                width: MediaQuery.of(context).size.width * 0.25,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: NetworkImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: "Ariom-Bold",
                        color: notifier.textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        color: notifier.subtitleTextColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 13,
                        color: notifier.subtitleTextColor,
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
}
