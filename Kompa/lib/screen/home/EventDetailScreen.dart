// ignore_for_file: file_names, camel_case_types
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../config/AppConstants.dart';
import '../../config/dark_mode.dart';
import '../../providers/HomeProvider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../home/HiloScreen.dart';

class Event_detail extends StatefulWidget {
  final String eventId;

  const Event_detail({
    Key? key,
    required this.eventId,
  }) : super(key: key);

  @override
  State<Event_detail> createState() => _Event_detailState();
}

class _Event_detailState extends State<Event_detail> {
  Map<String, dynamic>? eventData;
  Map<String, dynamic>? creatorData;
  Map<String, dynamic>? categoryData;
  bool isLoading = true;
  String? locationName;
  ColorNotifire notifier = ColorNotifire();

  @override
  void initState() {
    super.initState();
    _loadEventData();
  }

  Future<void> _loadEventData() async {
    final apiService = Provider.of<HomeProvider>(context, listen: false).apiService;

    try {
      // Cargar datos del evento
      final data = await apiService.getEventById(widget.eventId);
      setState(() {
        eventData = data;
      });

      // Cargar datos del creador
      if (eventData != null && eventData!['createFor'] != null) {
        final creatorId = eventData!['createFor'];
        try {
          // Intentar cargar como usuario de negocio
          creatorData = await apiService.getBusinessUser(creatorId);
        } catch (e) {
          try {
            // Si falla, intentar cargar como usuario cliente
            creatorData = await apiService.getClientUser(creatorId);
          } catch (e) {
            print('No se pudo cargar la información del creador');
          }
        }
      }

      // Cargar datos de la categoría
      if (eventData != null && eventData!['categoryId'] != null) {
        try {
          categoryData = await apiService.getCategoryById(eventData!['categoryId']);
        } catch (e) {
          print('No se pudo cargar la información de la categoría');
        }
      }

      // Obtener nombre de la ubicación basado en coordenadas
      if (eventData != null && eventData!['latitud'] != null && eventData!['longitud'] != null) {
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            eventData!['latitud'],
            eventData!['longitud'],
          );
          if (placemarks.isNotEmpty) {
            locationName = '${placemarks.first.locality}, ${placemarks.first.country}';
          }
        } catch (e) {
          locationName = 'Error al obtener ubicación';
        }
      }
    } catch (e) {
      print('Error al cargar datos del evento: $e');
    } finally {
      setState(() {
        isLoading = false;
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
        backgroundColor: notifier.backGround,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            "assets/arrow-left.png",
            width: 28, // Cambiado de 20 a 28
            height: 28, // Cambiado de 20 a 28
            color: notifier.textColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          categoryData?['title'] ?? "Categoría desconocida",
          style: TextStyle(
            color: notifier.textColor,
            fontSize: 22,
            fontFamily: "Ariom-Regular",
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Image.asset(
              "assets/Message.png",
              width: 32,
              height: 32,
              color: notifier.textColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Hilo(eventId: eventData!['id']),
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: notifier.buttonColor))
          : eventData == null
          ? Center(child: Text("No se encontró el evento", style: TextStyle(color: notifier.textColor)))
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height / 2.5,
              width: double.infinity,
              child: PageView.builder(
                itemCount: 2,
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: height / 2.5,
                    width: double.infinity,
                    child: PageView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: width / 40),
                          height: height / 2.5,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            image: DecorationImage(
                              image: NetworkImage(
                                  eventData!['photo'] ?? 'https://via.placeholder.com/150'
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width / 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppConstants.Height(height / 40),
                  Text(
                    eventData!['title'] ?? "Sin título",
                    style: TextStyle(
                      color: notifier.textColor,
                      fontSize: 32,
                      fontFamily: "Ariom-Bold",
                    ),
                  ),
                  AppConstants.Height(height / 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Hilo(eventId: eventData!['id']),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: notifier.buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Mira quién va >",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: "Ariom-Regular",
                      ),
                    ),
                  ),
                  AppConstants.Height(height / 40),
                  Container(
                    height: height / 11,
                    width: width / 1,
                    decoration: BoxDecoration(
                      color: notifier.containerColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width / 30),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: height / 38,
                            backgroundImage: creatorData != null &&
                                creatorData!['photo'] != null &&
                                creatorData!['photo'].toString().isNotEmpty
                                ? NetworkImage(creatorData!['photo'])
                                : const AssetImage('assets/Profile.png') as ImageProvider,
                          ),
                          AppConstants.Width(width / 30),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                creatorData?['nombre'] ?? 'Creador desconocido',
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontSize: 16,
                                  fontFamily: "Ariom-Regular",
                                ),
                              ),
                              Text(
                                "Event Organizer",
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontSize: 16,
                                  fontFamily: "Ariom-Regular",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppConstants.Height(height / 30),
                  Text(
                    "Descripción",
                    style: TextStyle(
                      color: notifier.textColor,
                      fontSize: 20,
                      fontFamily: "Ariom-Bold",
                    ),
                  ),
                  AppConstants.Height(height / 60),
                  Text(
                    eventData!['description'] ?? "Sin descripción disponible",
                    style: TextStyle(
                      color: notifier.onBoardTextColor,
                      fontSize: 16,
                      fontFamily: "Ariom-Regular",
                    ),
                  ),
                  AppConstants.Height(height / 60),
                  Row(
                    children: [
                      Container(
                        height: height / 19,
                        width: width / 9,
                        decoration: BoxDecoration(
                          color: notifier.containerColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Image.asset(
                            "assets/Clock.png",
                            height: height / 30,
                            color: notifier.textColor,
                          ),
                        ),
                      ),
                      AppConstants.Width(width / 30),
                      Text(
                        eventData!['startDate']?['seconds'] != null
                            ? DateFormat("dd-MM-yyyy 'a las' HH:mm").format(
                            DateTime.fromMillisecondsSinceEpoch(eventData!['startDate']['seconds'] * 1000)
                        )
                            : 'Fecha no disponible',
                        style: TextStyle(
                          color: notifier.textColor,
                          fontSize: 16,
                          fontFamily: "Ariom-Regular",
                        ),
                      ),
                    ],
                  ),
                  AppConstants.Height(height / 60),
                  Row(
                    children: [
                      Container(
                        height: height / 19,
                        width: width / 9,
                        decoration: BoxDecoration(
                          color: notifier.containerColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Image.asset(
                            "assets/location.png",
                            height: height / 30,
                            color: notifier.textColor,
                          ),
                        ),
                      ),
                      AppConstants.Width(width / 30),
                      Text(
                        locationName ?? eventData!['location'] ?? "Ubicación no disponible",
                        style: TextStyle(
                          color: notifier.textColor,
                          fontSize: 16,
                          fontFamily: "Ariom-Regular",
                        ),
                      ),
                    ],
                  ),
                  AppConstants.Height(height / 30),
                  Container(
                    height: height / 3,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: notifier.containerColor),
                    ),
                    child: eventData!['latitud'] != null && eventData!['longitud'] != null
                        ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(eventData!['latitud'], eventData!['longitud']),
                              zoom: 14,
                            ),
                            markers: {
                              Marker(
                                markerId: const MarkerId('eventLocation'),
                                position: LatLng(eventData!['latitud'], eventData!['longitud']),
                                infoWindow: InfoWindow(title: eventData!['title'] ?? 'Evento'),
                              ),
                            },
                            mapType: MapType.normal,
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: true,
                          ),
                        ),
                        Positioned(
                          right: 16,
                          bottom: 16,
                          child: FloatingActionButton(
                            mini: true,
                            backgroundColor: notifier.buttonColor,
                            onPressed: () {
                              final lat = eventData!['latitud'];
                              final lng = eventData!['longitud'];
                              final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
                              launchUrl(Uri.parse(url));
                            },
                            child: Icon(Icons.directions, color: Colors.black),
                          ),
                        ),
                      ],
                    )
                        : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "No hay coordenadas disponibles para mostrar el mapa",
                          style: TextStyle(
                            color: notifier.textColor,
                            fontFamily: "Ariom-Regular",
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
            AppConstants.Height(height / 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

