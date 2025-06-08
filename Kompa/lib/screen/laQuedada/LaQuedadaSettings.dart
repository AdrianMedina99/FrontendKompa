// ignore_for_file: file_names, camel_case_types

import 'package:kompa/config/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/AuthProvider.dart';
import '../../providers/LaQuedadaProvider.dart';
import '../../config/dark_mode.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import '../common/BottomScreen.dart';
import 'dart:async'; // Agregado para Timer

class LaQuedadaSettings extends StatefulWidget {
  final String name;
  final String quedadaId;

  const LaQuedadaSettings({
    super.key,
    required this.name,
    required this.quedadaId,
  });

  @override
  State<LaQuedadaSettings> createState() => _LaQuedadaSettingsState();
}

class _LaQuedadaSettingsState extends State<LaQuedadaSettings> {
  ColorNotifire notifier = ColorNotifire();
  DateTime? _horaEncuentro;
  double? _latitud;
  double? _longitud;
  Set<Marker> _markers = {};
  GoogleMapController? _mapController;
  bool _isEditable = false;
  bool _mapReady = false;
  TextEditingController _searchController = TextEditingController();
  String? _ubicacionError;
  String? _ubicacionNombre;
  Timer? _resetTimer;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final provider = Provider.of<LaQuedadaProvider>(context, listen: false);
      await provider.fetchQuedada(widget.quedadaId);
      provider.fetchSolicitudesPendientes(widget.quedadaId);
      provider.fetchMiembrosAceptados(widget.quedadaId);
      _resetTimer = Timer.periodic(Duration(minutes: 10), (_) {
        _checkAndResetQuedada();
      });
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final provider = Provider.of<LaQuedadaProvider>(context, listen: false);
        final quedada = provider.quedada;
        final hora = _parseHoraEncuentro(quedada?['horaEncuentro']);
        final latitud = quedada?['latitud'];
        final longitud = quedada?['longitud'];
        setState(() {
          _horaEncuentro = hora;
          _latitud = (latitud is num) ? latitud.toDouble() : null;
          _longitud = (longitud is num) ? longitud.toDouble() : null;
          if (_latitud != null && _longitud != null) {
            _markers = {
              Marker(markerId: MarkerId("quedada"), position: LatLng(_latitud!, _longitud!))
            };
          }
        });
        await _obtenerNombreUbicacion();
        setState(() {
          _mapReady = true;
        });
      });
    });
  }

  Future<void> _checkAndResetQuedada() async {
    if (_horaEncuentro != null && DateTime.now().isAfter(_horaEncuentro!.add(Duration(hours: 2)))) {
      try {
        await Provider.of<LaQuedadaProvider>(context, listen: false)
            .apiService
            .resetQuedada(widget.quedadaId);
        await Provider.of<LaQuedadaProvider>(context, listen: false)
            .fetchQuedada(widget.quedadaId);
      } catch (e) {
        // Manejo de error opcional
        print("Error en reset automático: $e");
      }
    }
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  DateTime? _parseHoraEncuentro(dynamic horaEncuentro) {
    if (horaEncuentro == null) return null;
    if (horaEncuentro is Map && horaEncuentro.containsKey('seconds')) {
      int seconds = horaEncuentro['seconds'];
      int nanos = horaEncuentro['nanos'] ?? 0;
      return DateTime.fromMillisecondsSinceEpoch(seconds * 1000 + (nanos ~/ 1000000));
    }
    return null;
  }
  
  Future<void> _actualizarHoraYLugar() async {
    final provider = Provider.of<LaQuedadaProvider>(context, listen: false);
    final horaEncuentroMillis = _horaEncuentro?.millisecondsSinceEpoch;
    await provider.apiService.actualizarHoraYLugar(
      widget.quedadaId,
      horaEncuentroMillis != null ? DateTime.fromMillisecondsSinceEpoch(horaEncuentroMillis) : null,      _latitud,
      _longitud,
    );
  }

  Future<void> _selectHoraEncuentro() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _horaEncuentro ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_horaEncuentro ?? DateTime.now()),
      );
      if (pickedTime != null) {
        setState(() {
          _horaEncuentro = DateTime(
            pickedDate.year, pickedDate.month, pickedDate.day,
            pickedTime.hour, pickedTime.minute,
          );
        });
        await _actualizarHoraYLugar();
      }
    }
  }

  Future<void> _searchLocation() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        setState(() {
          _latitud = loc.latitude;
          _longitud = loc.longitude;
          _markers = {
            Marker(
              markerId: MarkerId('searchedLocation'),
              position: LatLng(loc.latitude, loc.longitude),
            ),
          };
          _ubicacionError = null; // Limpiar error aquí
        });
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(loc.latitude, loc.longitude), 15),
        );
        await _obtenerNombreUbicacion();
        await _actualizarHoraYLugar();
      } else {
        setState(() {
          _ubicacionError = 'No se encontró la ubicación';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se encontró la ubicación')),
        );
      }
    } catch (e) {
      setState(() {
        _ubicacionError = 'No se encontró la ubicación';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se encontró la ubicación')),
      );
    }
  }

  Future<void> _obtenerNombreUbicacion() async {
    if (_latitud != null && _longitud != null) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          _latitud!,
          _longitud!,
        );
        if (placemarks.isNotEmpty) {
          setState(() {
            _ubicacionNombre = '${placemarks.first.locality ?? ''}, ${placemarks.first.country ?? ''}';
            if (placemarks.first.thoroughfare?.isNotEmpty ?? false) {
              _ubicacionNombre = '${placemarks.first.thoroughfare}, $_ubicacionNombre';
            }
            _ubicacionError = null; // Limpiar error si se obtiene nombre
          });
        } else {
          setState(() {
            _ubicacionNombre = null;
            _ubicacionError = 'No se encontró la ubicación';
          });
        }
      } catch (e) {
        setState(() {
          _ubicacionNombre = null;
          _ubicacionError = 'No se encontró la ubicación';
        });
      }
    }
  }

  Future<void> _confirmarEliminarMiembro(BuildContext context, Map<String, dynamic> miembro) async {
    final nombre = miembro['nombre'] ?? '';
    final apellidos = miembro['apellidos'] ?? '';
    final usuarioId = miembro['usuarioId'];
    final notifier = Provider.of<ColorNotifire>(context, listen: false);
    final provider = Provider.of<LaQuedadaProvider>(context, listen: false);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: notifier.backGround,
        title: Text(
          "Confirmar eliminación",
          style: TextStyle(color: notifier.textColor, fontFamily: "Ariom-Bold"),
        ),
        content: Text(
          "¿Estás seguro que quieres eliminar a $nombre $apellidos?",
          style: TextStyle(color: notifier.textColor),
        ),
        actions: [
          TextButton(
            child: Text("Cancelar", style: TextStyle(color: notifier.buttonColor)),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          TextButton(
            child: Text("Eliminar", style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await provider.eliminarMiembroAceptado(widget.quedadaId, usuarioId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Miembro eliminado")),
      );
    }
  }

  Future<void> _eliminarQuedada() async {
    final provider = Provider.of<LaQuedadaProvider>(context, listen: false);
    final notifier = Provider.of<ColorNotifire>(context, listen: false);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: notifier.backGround,
        title: Text(
          "Eliminar quedada",
          style: TextStyle(color: notifier.textColor, fontFamily: "Ariom-Bold"),
        ),
        content: Text(
          "¿Estás seguro de que quieres eliminar esta quedada? Esta acción no se puede deshacer.",
          style: TextStyle(color: notifier.textColor),
        ),
        actions: [
          TextButton(
            child: Text("Cancelar", style: TextStyle(color: notifier.buttonColor)),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          TextButton(
            child: Text("Eliminar", style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );
    if (confirm == true) {
      try {
        await provider.apiService.eliminarQuedada(widget.quedadaId);
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => BottomBarScreen()),
            (route) => false,
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al eliminar la quedada: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    final quedadaProvider = Provider.of<LaQuedadaProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final quedada = quedadaProvider.quedada;
    final isCreador = authProvider.userId == quedada?['creadoPor'];

    // Usar _parseHoraEncuentro y valores directos para mostrar
    final hora = _parseHoraEncuentro(quedada?['horaEncuentro']);
    final latitud = quedada?['latitud'];
    final longitud = quedada?['longitud'];

    return Scaffold(
      backgroundColor: notifier.backGround,
      appBar: AppBar(
        backgroundColor: notifier.backGround,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            "assets/arrow-left.png",
            scale: 3,
            color: notifier.textColor,
          ),
        ),
        actions: [
          if (isCreador) ...[
            IconButton(
              icon: Icon(
                _isEditable ? Icons.check : Icons.edit,
                color: notifier.buttonColor,
              ),
              onPressed: () {
                setState(() {
                  _isEditable = !_isEditable;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              tooltip: "Eliminar quedada",
              onPressed: _eliminarQuedada,
            ),
          ],
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppConstants.Height(MediaQuery.of(context).size.height / 30),
              Center(
                child: Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: 20,
                    color: notifier.textColor,
                    fontFamily: "Ariom-Bold",
                  ),
                ),
              ),
              AppConstants.Height(MediaQuery.of(context).size.height / 20),
              if (quedadaProvider.loadingSolicitudes)
                Center(child: CircularProgressIndicator(color: notifier.buttonColor)),
              if (!quedadaProvider.loadingSolicitudes &&
                  quedadaProvider.solicitudesPendientes.isNotEmpty)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: notifier.containerColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: notifier.inv.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Solicitudes pendientes",
                        style: TextStyle(
                          color: notifier.textColor,
                          fontSize: 18,
                          fontFamily: "Ariom-Bold",
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...quedadaProvider.solicitudesPendientes.map((solicitud) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Icon(Icons.person, color: notifier.buttonColor),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                solicitud['nombreSolicitante'] ?? "Usuario",
                                style: TextStyle(
                                  color: notifier.textColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            if (isCreador) ...[
                              ElevatedButton(
                                onPressed: () async {
                                  final auth = Provider.of<AuthProvider>(context, listen: false);
                                  await quedadaProvider.aceptarSolicitud(
                                    widget.quedadaId,
                                    auth.userId!,
                                    solicitud['usuarioSolicitanteId'],
                                    solicitud['id'],
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text("Aceptar", style: TextStyle(color: Colors.white)),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () async {
                                  await quedadaProvider.rechazarSolicitud(solicitud['id']);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text("Rechazar", style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              if (!quedadaProvider.loadingSolicitudes &&
                  quedadaProvider.solicitudesPendientes.isEmpty)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: notifier.containerColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "No hay solicitudes pendientes",
                    style: TextStyle(
                      color: notifier.subtitleTextColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              AppConstants.Height(MediaQuery.of(context).size.height / 30),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: notifier.containerColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Image.asset(
                          "assets/Clock.png",
                          height: 24,
                          color: notifier.textColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          hora != null
                              ? DateFormat("dd-MM-yyyy 'a las' HH:mm").format(hora)
                              : "Sin hora",
                          style: TextStyle(
                            color: notifier.textColor,
                            fontSize: 16,
                            fontFamily: "Ariom-Regular",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                trailing: _isEditable
                    ? Icon(Icons.edit, color: notifier.buttonColor)
                    : null,
                onTap: _isEditable ? _selectHoraEncuentro : null,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.zero,
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: notifier.containerColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Image.asset(
                          "assets/location.png",
                          height: 24,
                          color: notifier.textColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _ubicacionNombre != null
                              ? _ubicacionNombre!
                              : (_latitud != null && _longitud != null)
                                  ? 'Lat: $_latitud, Lng: $_longitud'
                                  : 'Ubicación no establecida',
                          style: TextStyle(
                            color: notifier.textColor,
                            fontSize: 16,
                            fontFamily: "Ariom-Regular",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 180,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _mapReady
                      ? Stack(
                          children: [
                            GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(_latitud ?? 40.416775, _longitud ?? -3.703790),
                                zoom: 13,
                              ),
                              onTap: _isEditable
                                  ? (pos) async {
                                      setState(() {
                                        _latitud = pos.latitude;
                                        _longitud = pos.longitude;
                                        _markers = {
                                          Marker(markerId: MarkerId("quedada"), position: pos)
                                        };
                                        _ubicacionError = null;
                                      });
                                      await _obtenerNombreUbicacion();
                                    }
                                  : null,
                              markers: _markers,
                              myLocationEnabled: true,
                              onMapCreated: (controller) {
                                _mapController = controller;
                                if (_latitud != null && _longitud != null) {
                                  _mapController?.moveCamera(
                                    CameraUpdate.newLatLngZoom(
                                      LatLng(_latitud!, _longitud!), 13),
                                  );
                                }
                              },
                            ),
                            if (_latitud != null && _longitud != null && !_isEditable)
                              Positioned(
                                left: 16,
                                bottom: 16,
                                child: FloatingActionButton(
                                  mini: true,
                                  backgroundColor: notifier.buttonColor,
                                  onPressed: () {
                                    final url = 'https://www.google.com/maps/search/?api=1&query=$_latitud,$_longitud';
                                    launchUrl(Uri.parse(url));
                                  },
                                  child: Icon(Icons.directions, color: Colors.black),
                                ),
                              ),
                          ],
                        )
                      : Center(child: CircularProgressIndicator(color: notifier.buttonColor)),
                ),
              ),
              if (_ubicacionError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _ubicacionError!,
                    style: TextStyle(
                      color: Colors.red,
                      fontFamily: "Roboto",
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              if (_isEditable)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _actualizarHoraYLugar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Fecha y lugar actualizados")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: notifier.buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      "Actualizar fecha y lugar",
                      style: TextStyle(
                        color: notifier.buttonTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              Text(
                "Miembros aceptados",
                style: TextStyle(
                  color: notifier.textColor,
                  fontSize: 18,
                  fontFamily: "Ariom-Bold",
                ),
              ),
              const SizedBox(height: 10),
              if (quedadaProvider.loadingMiembrosAceptados)
                Center(child: CircularProgressIndicator(color: notifier.buttonColor)),
              if (!quedadaProvider.loadingMiembrosAceptados && quedadaProvider.miembrosAceptados.isEmpty)
                Text(
                  "No hay miembros aceptados",
                  style: TextStyle(
                    color: notifier.subtitleTextColor,
                    fontSize: 16,
                  ),
                ),
              if (!quedadaProvider.loadingMiembrosAceptados && quedadaProvider.miembrosAceptados.isNotEmpty)
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: quedadaProvider.miembrosAceptados.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (ctx, i) {
                    final miembro = quedadaProvider.miembrosAceptados[i];
                    final nombre = miembro['nombre'] ?? '';
                    final apellidos = miembro['apellidos'] ?? '';
                    final usuarioId = miembro['usuarioId'];
                    final creadorId = quedadaProvider.quedada?['creadoPor'];
                    final photo = miembro['photo'];

                    return Container(
                      decoration: BoxDecoration(
                        color: notifier.containerColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: photo != null && photo.toString().isNotEmpty
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(photo),
                                radius: 20,
                              )
                            : Icon(Icons.person, color: notifier.buttonColor),
                        title: Text(
                          "$nombre $apellidos",
                          style: TextStyle(
                            color: notifier.textColor,
                            fontSize: 16,
                          ),
                        ),
                        trailing: (isCreador && usuarioId != null && usuarioId != creadorId)
                            ? IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _confirmarEliminarMiembro(context, miembro),
                              )
                            : null,
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
