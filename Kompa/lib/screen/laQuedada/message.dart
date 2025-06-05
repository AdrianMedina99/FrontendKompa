import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart';
import '../../config/dark_mode.dart';
import '../../providers/AuthProvider.dart';
import '../../providers/LaQuedadaProvider.dart';
import 'message_detail.dart';

class message extends StatefulWidget {
  final String userId;
  const message({super.key, required this.userId});

  @override
  State<message> createState() => _messageState();
}

class _messageState extends State<message> {
  ColorNotifire notifier = ColorNotifire();
  final Map<String, String> _cityCache = {};

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<LaQuedadaProvider>(context, listen: false)
          .fetchQuedadasPorMiembro(widget.userId);
    });
  }

  Future<String> _getCityName(double? lat, double? lng, String quedadaId) async {
    if (lat == null || lng == null) return "Ubicación no disponible";
    if (_cityCache.containsKey(quedadaId)) return _cityCache[quedadaId]!;
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      String city = placemarks.isNotEmpty
          ? (placemarks.first.locality ??
              placemarks.first.subAdministrativeArea ??
              placemarks.first.administrativeArea ??
              "Ubicación desconocida")
          : "Ubicación desconocida";
      _cityCache[quedadaId] = city;
      return city;
    } catch (_) {
      return "Ubicación desconocida";
    }
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    final quedadaProvider = Provider.of<LaQuedadaProvider>(context);

    final quedadas = quedadaProvider.quedadas;
    final loading = quedadaProvider.loading;
    final error = quedadaProvider.error;

    return Scaffold(
      backgroundColor: notifier.backGround,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: notifier.backGround,
        automaticallyImplyLeading: false,
        title: Text(
          "Tus Quedadas",
          style: TextStyle(
            fontSize: 20,
            color: notifier.textColor,
            fontFamily: "Ariom-Bold",
          ),
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator(color: notifier.buttonColor))
          : error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Error: $error",
                      style: TextStyle(color: notifier.textColor, fontSize: 16),
                    ),
                  ),
                )
              : quedadas.isEmpty
                  ? Center(
                      child: Text(
                        "No hay quedadas donde seas miembro",
                        style: TextStyle(
                          color: notifier.textColor,
                          fontSize: 18,
                          fontFamily: "Ariom-Bold",
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(18.0),
                      itemCount: quedadas.length,
                      itemBuilder: (context, index) {
                        final q = quedadas[index];
                        final quedadaId = q['id'] ?? '${q['titulo']}_${q['horaEncuentro']}';
                        return Container(
                          margin: const EdgeInsets.only(bottom: 18),
                          decoration: BoxDecoration(
                            color: notifier.containerColor,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: notifier.inv.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.group, color: notifier.buttonColor, size: 28),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        q['titulo'] ?? 'Sin título',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: notifier.textColor,
                                          fontFamily: "Ariom-Bold",
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Image.asset(
                                        "assets/arrow-right.png",
                                        color: notifier.buttonColor,
                                        width: 24,
                                        height: 24,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => MessageDetail(
                                              image: "assets/Avtar 1.png",
                                              name: q['titulo'] ?? "Quedada",
                                              quedadaId: q['id'],
                                              userId: widget.userId,
                                              creadoPor: q['creadoPor'],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                if (q['descripcion'] != null && q['descripcion'].toString().isNotEmpty)
                                  Text(
                                    q['descripcion'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: notifier.textColor,
                                    ),
                                  ),
                                if (q['descripcion'] == null || q['descripcion'].toString().isEmpty)
                                  Text(
                                    "Sin descripción",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: notifier.subtitleTextColor,
                                    ),
                                  ),
                                const SizedBox(height: 14),
                                Row(
                                  children: [
                                    Icon(Icons.access_time, color: notifier.buttonColor, size: 20),
                                    const SizedBox(width: 6),
                                    Text(
                                      _formatHoraEncuentro(q['horaEncuentro']),
                                      style: TextStyle(
                                        color: notifier.textColor,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(Icons.location_on, color: notifier.buttonColor, size: 20),
                                    const SizedBox(width: 6),
                                    FutureBuilder<String>(
                                      future: _getCityName(
                                        (q['latitud'] is num) ? q['latitud']?.toDouble() : null,
                                        (q['longitud'] is num) ? q['longitud']?.toDouble() : null,
                                        quedadaId,
                                      ),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return Text(
                                            "Cargando ubicación...",
                                            style: TextStyle(
                                              color: notifier.subtitleTextColor,
                                              fontSize: 15,
                                            ),
                                          );
                                        }
                                        return Text(
                                          snapshot.data ?? "Ubicación no disponible",
                                          style: TextStyle(
                                            color: notifier.textColor,
                                            fontSize: 15,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: notifier.buttonColor,
        child: Icon(Icons.add, color: notifier.buttonTextColor),
        onPressed: () => _showCrearQuedadaForm(context),
      ),
    );
  }

  void _showCrearQuedadaForm(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _tituloController = TextEditingController();
    final TextEditingController _descripcionController = TextEditingController();
    final TextEditingController _searchController = TextEditingController();

    DateTime? _horaEncuentro;
    double? _latitud;
    double? _longitud;
    Set<Marker> _markers = {};
    GoogleMapController? _mapController;
    String? _ubicacionError;

    Future<void> _searchLocation() async {
      final query = _searchController.text.trim();
      if (query.isEmpty) return;
      try {
        List<Location> locations = await locationFromAddress(query);
        if (locations.isNotEmpty) {
          final loc = locations.first;
          _latitud = loc.latitude;
          _longitud = loc.longitude;
          _markers = {
            Marker(
              markerId: MarkerId('searchedLocation'),
              position: LatLng(loc.latitude, loc.longitude),
            ),
          };
          _mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(LatLng(loc.latitude, loc.longitude), 15),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se encontró la ubicación')),
        );
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16, right: 16, top: 24,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Crear Quedada", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      TextFormField(
                        controller: _tituloController,
                        decoration: InputDecoration(labelText: "Título *"),
                        validator: (v) => v == null || v.isEmpty ? "Obligatorio" : null,
                      ),
                      TextFormField(
                        controller: _descripcionController,
                        decoration: InputDecoration(labelText: "Descripción"),
                      ),
                      SizedBox(height: 12),
                      ListTile(
                        title: Text(_horaEncuentro == null
                            ? "Selecciona fecha y hora de encuentro"
                            : "${_horaEncuentro!.day}/${_horaEncuentro!.month}/${_horaEncuentro!.year} ${_horaEncuentro!.hour.toString().padLeft(2, '0')}:${_horaEncuentro!.minute.toString().padLeft(2, '0')}"),
                        trailing: Icon(Icons.calendar_today),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          );
                          if (date != null) {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (time != null) {
                              setModalState(() {
                                _horaEncuentro = DateTime(
                                  date.year, date.month, date.day, time.hour, time.minute,
                                );
                              });
                            }
                          }
                        },
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: 'Buscar calle o pueblo',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () async {
                              await _searchLocation();
                              setModalState(() {});
                            },
                          ),
                        ),
                        onSubmitted: (_) async {
                          await _searchLocation();
                          setModalState(() {});
                        },
                      ),
                      SizedBox(height: 10),

                      // MAPA
                      SizedBox(
                        height: 180,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(_latitud ?? 40.416775, _longitud ?? -3.703790),
                              zoom: 13,
                            ),
                            onTap: (pos) {
                              setModalState(() {
                                _latitud = pos.latitude;
                                _longitud = pos.longitude;
                                _markers = {
                                  Marker(markerId: MarkerId("quedada"), position: pos)
                                };
                                _ubicacionError = null;
                              });
                            },
                            markers: _markers,
                            myLocationEnabled: true,
                            onMapCreated: (controller) {
                              _mapController = controller;
                            },
                          ),
                        ),
                      ),

                      if (_ubicacionError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(_ubicacionError!, style: TextStyle(color: Colors.red)),
                        ),

                      SizedBox(height: 18),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 44),
                        ),
                        child: Text("Crear quedada"),
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          if (_horaEncuentro == null) {
                            setModalState(() => _ubicacionError = "Selecciona fecha y hora");
                            return;
                          }
                          if (_latitud == null || _longitud == null) {
                            setModalState(() => _ubicacionError = "Selecciona ubicación en el mapa");
                            return;
                          }
                          final auth = Provider.of<AuthProvider>(context, listen: false);
                          final quedadaProvider = Provider.of<LaQuedadaProvider>(context, listen: false);
                          final String creadopor = auth.userId!;
                          final String horaEncuentroStr = _horaEncuentro!.toUtc().toIso8601String();
                          final data = {
                            "titulo": _tituloController.text.trim(),
                            "descripcion": _descripcionController.text.trim(),
                            "creadoPor": creadopor,
                            "latitud": _latitud,
                            "longitud": _longitud,
                            "horaEncuentro": horaEncuentroStr,
                          };
                          try {
                            await quedadaProvider.apiService.crearQuedada(data);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Quedada creada correctamente")),
                            );
                          } catch (e) {
                            setModalState(() => _ubicacionError = "Error: $e");
                          }
                        },
                      ),
                      SizedBox(height: 18),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _formatHoraEncuentro(dynamic horaEncuentro) {
    if (horaEncuentro == null) return "Sin hora";
    try {
      if (horaEncuentro is Map && horaEncuentro.containsKey('seconds')) {
        final date = DateTime.fromMillisecondsSinceEpoch(horaEncuentro['seconds'] * 1000);
        return "${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
      } else if (horaEncuentro is String && horaEncuentro.isNotEmpty) {
        final date = DateTime.parse(horaEncuentro);
        return "${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
      }
    } catch (_) {}
    return "Sin hora";
  }
}

