// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../config/dark_mode.dart';
import '../../providers/AuthProvider.dart';
import '../../providers/HomeProvider.dart';

class EventForm extends StatefulWidget {
  final String categoryId;
  final String categoryTitle;

  const EventForm({
    Key? key,
    required this.categoryId,
    required this.categoryTitle,
  }) : super(key: key);

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  late ColorNotifire notifier;

  // Controladores para los campos del formulario
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _searchLocationController = TextEditingController();

  // Variables para manejar fechas
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(hours: 2));

  // Variables para ubicación
  double? _latitude;
  double? _longitude;
  String _addressText = "Selecciona una ubicación en el mapa";
  String? _address;
  double? _currentLat;
  double? _currentLng;
  Set<Marker> _markers = {};
  GoogleMapController? _mapController;

  // Manejo de errores y estado de carga
  bool _isLoading = false;
  String _errorMessage = '';

  // Imagen del evento
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Obtener una ubicación inicial para centrar el mapa
    _initializeLocation();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _capacityController.dispose();
    _languageController.dispose();
    _edadController.dispose();
    _searchLocationController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  // Método para inicializar la ubicación para el mapa
  Future<void> _initializeLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Verificar permisos de ubicación
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Permiso de ubicación denegado';
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        throw 'Los permisos de ubicación están permanentemente denegados';
      }

      // Obtener la posición actual solo para inicializar el mapa
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
      
      setState(() {
        _currentLat = position.latitude;
        _currentLng = position.longitude;
      });

    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _currentLat = 40.416775;
        _currentLng = -3.703790;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Método para buscar una ubicación por texto
  Future<void> _searchLocation() async {
    final searchText = _searchLocationController.text.trim();
    if (searchText.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      List<Location> locations = await locationFromAddress(searchText);
      if (locations.isNotEmpty) {
        final location = locations.first;
        
        // Actualizar la ubicación en el mapa
        final newLatLng = LatLng(location.latitude, location.longitude);
        _mapController?.animateCamera(CameraUpdate.newLatLngZoom(newLatLng, 14));
        
        // Actualizar marcador y guardar coordenadas
        setState(() {
          _latitude = location.latitude;
          _longitude = location.longitude;
          _markers.clear();
          _markers.add(Marker(
            markerId: const MarkerId('searchedLocation'),
            position: newLatLng,
          ));
        });
        
        // Obtener la dirección completa para mostrarla
        await _getAddressFromLatLng(location.latitude, location.longitude);
      } else {
        setState(() {
          _errorMessage = 'No se encontró la ubicación';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al buscar la ubicación: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: isStartDate ? DateTime.now() : _startDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      final TimeOfDay? timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
            isStartDate ? _startDate : _endDate),
      );

      if (timePicked != null) {
        setState(() {
          final newDateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            timePicked.hour,
            timePicked.minute,
          );

          if (isStartDate) {
            _startDate = newDateTime;
            // Si la fecha de fin es anterior a la nueva fecha de inicio, actualizamos la fecha de fin
            if (_endDate.isBefore(_startDate)) {
              _endDate = _startDate.add(const Duration(hours: 2));
            }
          } else {
            _endDate = newDateTime;
          }
        });
      }
    }
  }

  Widget _buildLocationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ubicación del evento",
          style: TextStyle(
            color: notifier.textColor,
            fontFamily: "Ariom-Bold",
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        
        // Añadimos el campo para buscar ubicaciones
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _searchLocationController,
                style: TextStyle(color: notifier.textColor),
                decoration: InputDecoration(
                  hintText: "Buscar ubicación (ej: Sevilla, España)",
                  hintStyle: TextStyle(color: notifier.hintTextColor),
                  filled: true,
                  fillColor: notifier.textFieldBackground,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: notifier.textColor.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: notifier.buttonColor),
                  ),
                ),
                onEditingComplete: _searchLocation,
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: notifier.buttonColor,
                foregroundColor: notifier.buttonTextColor,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12),
              ),
              onPressed: _searchLocation,
              child: const Icon(Icons.search),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: notifier.textColor),
          ),
          child: Stack(
            children: [
              // Mapa donde el usuario puede elegir ubicación
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(_currentLat ?? 40.416775, _currentLng ?? -3.703790),
                    zoom: 14,
                  ),
                  onTap: (LatLng position) {
                    setState(() {
                      _latitude = position.latitude;
                      _longitude = position.longitude;
                      _markers.clear();
                      _markers.add(Marker(
                        markerId: const MarkerId('selectedLocation'),
                        position: position,
                      ));
                    });
                    _getAddressFromLatLng(position.latitude, position.longitude);
                  },
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onMapCreated: (controller) {
                    // Guardamos el controlador para poder manipular el mapa después
                    _mapController = controller;
                  },
                ),
              ),
              // Instrucción para el usuario
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "Toca el mapa para elegir ubicación",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _address ?? "Toca el mapa para seleccionar ubicación",
          style: TextStyle(color: notifier.inv, fontSize: 14),
        ),
      ],
    );
  }

  // Método para obtener la dirección a partir de coordenadas
  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          _address = "${place.street}, ${place.locality}, ${place.country}";
          _addressText = _address ?? "Dirección seleccionada";
        });
      }
    } catch (e) {
      setState(() {
        _address = "No se pudo obtener la dirección";
        _addressText = _address ?? "Error al obtener dirección";
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_imageFile == null) {
      setState(() {
        _errorMessage = 'Por favor, selecciona una imagen para el evento';
      });
      return;
    }

    if (_latitude == null || _longitude == null) {
      setState(() {
        _errorMessage = 'Por favor, selecciona una ubicación para el evento tocando el mapa';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Obtener datos del usuario actual
      final userData = await authProvider.getCurrentUserData();

      // Subir la imagen primero y obtener la URL
      final String photoUrl = await homeProvider.apiService.uploadEventImage(_imageFile!);

      // Crear el objeto de evento
      final eventData = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'photo': photoUrl,
        'startDate': _startDate.toIso8601String(),
        'endDate': _endDate.toIso8601String(),
        'capacity': int.tryParse(_capacityController.text) ?? 0,
        'language': _languageController.text,
        'ageRestriction': _edadController.text,
        'latitud': _latitude,
        'longitud': _longitude,
        'location': _addressText,
        'categoryId': widget.categoryId,
        'businessId': userData['id'],  // El ID del creador se asigna automáticamente
      };

      // Enviar los datos al servidor
      await homeProvider.apiService.createEvent(eventData);

      // Navegar hacia atrás con un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evento creado exitosamente')),
      );
      Navigator.pop(context);

    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al crear el evento: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context);
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: notifier.backGround,
      appBar: AppBar(
        backgroundColor: notifier.backGround,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: notifier.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Crear Evento en ${widget.categoryTitle}",
          style: TextStyle(
            color: notifier.textColor,
            fontSize: 18,
            fontFamily: "Ariom-Bold",
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: notifier.buttonColor))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Selector de imagen
              InkWell(
                onTap: _selectImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: notifier.containerColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: notifier.textColor.withOpacity(0.3)),
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      _imageFile!,
                      fit: BoxFit.cover,
                    ),
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 50,
                        color: notifier.textColor,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Agregar imagen del evento",
                        style: TextStyle(
                          color: notifier.textColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Campo de título
              Text(
                "Título del evento",
                style: TextStyle(
                  color: notifier.textColor,
                  fontFamily: "Ariom-Bold",
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                style: TextStyle(color: notifier.textColor),
                decoration: InputDecoration(
                  hintText: "Ingresa el título del evento",
                  hintStyle: TextStyle(color: notifier.hintTextColor),
                  filled: true,
                  fillColor: notifier.textFieldBackground,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: notifier.textColor.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: notifier.buttonColor),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un título';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Campo de descripción
              Text(
                "Descripción",
                style: TextStyle(
                  color: notifier.textColor,
                  fontFamily: "Ariom-Bold",
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                style: TextStyle(color: notifier.textColor),
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Describe tu evento...",
                  hintStyle: TextStyle(color: notifier.hintTextColor),
                  filled: true,
                  fillColor: notifier.textFieldBackground,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: notifier.textColor.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: notifier.buttonColor),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una descripción';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Selector de fecha de inicio
              Text(
                "Fecha y hora de inicio",
                style: TextStyle(
                  color: notifier.textColor,
                  fontFamily: "Ariom-Bold",
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _selectDate(context, true),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: notifier.textFieldBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: notifier.textColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: notifier.iconColor,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat("dd/MM/yyyy HH:mm").format(_startDate),
                        style: TextStyle(color: notifier.textColor),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Selector de fecha de fin
              Text(
                "Fecha y hora de finalización",
                style: TextStyle(
                  color: notifier.textColor,
                  fontFamily: "Ariom-Bold",
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _selectDate(context, false),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: notifier.textFieldBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: notifier.textColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: notifier.iconColor,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat("dd/MM/yyyy HH:mm").format(_endDate),
                        style: TextStyle(color: notifier.textColor),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Campo de capacidad
              Text(
                "Capacidad",
                style: TextStyle(
                  color: notifier.textColor,
                  fontFamily: "Ariom-Bold",
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _capacityController,
                style: TextStyle(color: notifier.textColor),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Número de asistentes",
                  hintStyle: TextStyle(color: notifier.hintTextColor),
                  filled: true,
                  fillColor: notifier.textFieldBackground,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: notifier.textColor.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: notifier.buttonColor),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Campo de idioma
              Text(
                "Idioma",
                style: TextStyle(
                  color: notifier.textColor,
                  fontFamily: "Ariom-Bold",
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _languageController,
                style: TextStyle(color: notifier.textColor),
                decoration: InputDecoration(
                  hintText: "Idioma del evento",
                  hintStyle: TextStyle(color: notifier.hintTextColor),
                  filled: true,
                  fillColor: notifier.textFieldBackground,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: notifier.textColor.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: notifier.buttonColor),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Campo de restricción de edad
              Text(
                "Restricción de edad",
                style: TextStyle(
                  color: notifier.textColor,
                  fontFamily: "Ariom-Bold",
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _edadController,
                style: TextStyle(color: notifier.textColor),
                decoration: InputDecoration(
                  hintText: "Ej: +18, Todas las edades",
                  hintStyle: TextStyle(color: notifier.hintTextColor),
                  filled: true,
                  fillColor: notifier.textFieldBackground,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: notifier.textColor.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: notifier.buttonColor),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Selector de ubicación en el mapa
              _buildLocationSelector(),

              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),

              SizedBox(height: height / 20),

              // Botón de envío
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: notifier.buttonColor,
                    foregroundColor: notifier.buttonTextColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isLoading ? null : _submitForm,
                  child: Text(
                    _isLoading ? "Creando evento..." : "Crear evento",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
