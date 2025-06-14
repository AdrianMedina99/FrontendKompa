import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../config/AppConstants.dart';
import '../../config/dark_mode.dart';
import '../../providers/AuthProvider.dart';
import '../../providers/HomeProvider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../home/HiloScreen.dart';
import '../profile/OtherProfileScreen.dart';

class Event_detail extends StatefulWidget {
  //===========
  // Variables
  //===========
  final String eventId;

  const Event_detail({
    Key? key,
    required this.eventId,
  }) : super(key: key);

  @override
  State<Event_detail> createState() => _Event_detailState();
}

class _Event_detailState extends State<Event_detail> {
  //===========
  // Variables
  //===========
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

  ///Metodo para cargar los datos del evento
  Future<void> _loadEventData() async {
    final apiService = Provider.of<HomeProvider>(context, listen: false).apiService;

    try {
      final data = await apiService.getEventById(widget.eventId);
      setState(() {
        eventData = data;
      });

      if (eventData != null && eventData!['createFor'] != null) {
        final creatorId = eventData!['createFor'];
        try {
          creatorData = await apiService.getBusinessUser(creatorId);
        } catch (e) {
          try {
            creatorData = await apiService.getClientUser(creatorId);
          } catch (e) {
            print('No se pudo cargar la información del creador');
          }
        }
      }

      if (eventData != null && eventData!['categoryId'] != null) {
        try {
          categoryData = await apiService.getCategoryById(eventData!['categoryId']);
        } catch (e) {
          print('No se pudo cargar la información de la categoría');
        }
      }

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

  Future<void> _showReportDialog(BuildContext context) async {
    final authProvider = Provider.of<HomeProvider>(context, listen: false);
    final userProvider = Provider.of<AuthProvider>(context, listen: false);
    final apiService = authProvider.apiService;
    final loggedUserId = userProvider.userId;
    final reportedId = eventData?['id'];
    final descController = TextEditingController();
    bool isSubmitting = false;
    final notifier = Provider.of<ColorNotifire>(context, listen: false);

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: notifier.backGround,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              title: Text(
                'Reportar evento',
                style: TextStyle(
                  color: notifier.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              content: SizedBox(
                width: 340,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: 'EVENT',
                      items: [
                        DropdownMenuItem(value: 'EVENT', child: Text('Evento')),
                      ],
                      onChanged: null,
                      decoration: InputDecoration(
                        labelText: 'Tipo',
                        labelStyle: TextStyle(color: notifier.textColor),
                        filled: true,
                        fillColor: notifier.textFieldBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: TextStyle(color: notifier.textColor),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descController,
                      decoration: InputDecoration(
                        labelText: 'Descripción',
                        labelStyle: TextStyle(color: notifier.textColor),
                        filled: true,
                        fillColor: notifier.textFieldBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      style: TextStyle(color: notifier.textColor),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting ? null : () => Navigator.pop(context),
                  child: Text('Cancelar', style: TextStyle(color: notifier.buttonColor)),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          if (descController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('La descripción es obligatoria')),
                            );
                            return;
                          }
                          setStateDialog(() => isSubmitting = true);
                          try {
                            final now = DateTime.now();
                            final timestamp = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(now);
                            final reportData = {
                              'description': descController.text.trim(),
                              'type': 'EVENT',
                              'idReported': reportedId,
                              'idReporter': loggedUserId,
                              'timestamp': timestamp,
                              'status': 'PENDIENTE',
                              'idAdmin': null,
                              'respuesta': null,
                            };
                            await apiService.createReport(reportData);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Reporte enviado correctamente')),
                            );
                          } catch (e) {
                            setStateDialog(() => isSubmitting = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error al enviar reporte: $e')),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: notifier.buttonColor,
                    foregroundColor: notifier.buttonTextColor,
                  ),
                  child: isSubmitting
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text('Reportar', style: TextStyle(color: notifier.buttonTextColor)),
                ),
              ],
            );
          },
        );
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
      appBar: AppBar(
        backgroundColor: notifier.backGround,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            "assets/arrow-left.png",
            width: 28,
            height: 28,
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
          IconButton(
            icon: Icon(Icons.report, color: notifier.textColor, size: 30),
            tooltip: 'Reportar',
            iconSize: 30,
            onPressed: () {
              _showReportDialog(context);
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
                              GestureDetector(
                                onTap: () {
                                  if (creatorData != null && creatorData!['id'] != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OtherProfileScreen(userId: creatorData!['id']),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  creatorData?['nombre'] ?? 'Creador desconocido',
                                  style: TextStyle(
                                    color: notifier.textColor,
                                    fontSize: 16,
                                    fontFamily: "Ariom-Regular",
                                    decoration: TextDecoration.underline,
                                  ),
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
                          left: 16,
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

