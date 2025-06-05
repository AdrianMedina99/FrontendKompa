// ignore_for_file: file_names, use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';

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

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(hours: 2));

  double? _latitude;
  double? _longitude;
  Set<Marker> _markers = {};
  GoogleMapController? _mapController;
  String? _ubicacionError;

  bool _isLoading = false;
  String _errorMessage = '';

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _capacityController.dispose();
    _languageController.dispose();
    _edadController.dispose();
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _searchLocation() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        setState(() {
          _latitude = loc.latitude;
          _longitude = loc.longitude;
          _markers = {
            Marker(
              markerId: MarkerId('searchedLocation'),
              position: LatLng(loc.latitude, loc.longitude),
            ),
          };
        });
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
        _ubicacionError = 'Por favor, selecciona una ubicación para el evento tocando el mapa';
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

      final userId = authProvider.userId;

      final String photoUrl = await homeProvider.apiService.uploadEventImage(_imageFile!);

      final dateFormatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
      final String formattedStartDate = dateFormatter.format(_startDate.toUtc());
      final String formattedEndDate = dateFormatter.format(_endDate.toUtc());

      final eventData = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'photo': photoUrl,
        'startDate': formattedStartDate,
        'endDate': formattedEndDate,
        'capacity': int.tryParse(_capacityController.text) ?? 0,
        'language': _languageController.text,
        'ageRestriction': _edadController.text,
        'latitud': _latitude,
        'longitud': _longitude,
        'location': 'Ubicación seleccionada',
        'categoryId': widget.categoryId,
        'createFor': userId,
      };

      await homeProvider.apiService.createEvent(eventData);

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

              Text(
                "Ubicación del evento",
                style: TextStyle(
                  color: notifier.textColor,
                  fontFamily: "Ariom-Bold",
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _searchController,
                style: TextStyle(
                  color: notifier.textColor,
                  fontFamily: "Roboto",
                ),
                decoration: InputDecoration(
                  labelText: 'Buscar calle o pueblo',
                  labelStyle: TextStyle(
                    color: notifier.textColor,
                    fontFamily: "Roboto",
                  ),
                  filled: true,
                  fillColor: notifier.textFieldBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: notifier.buttonColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: notifier.buttonColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: notifier.buttonColor, width: 2),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search, color: notifier.buttonColor),
                    onPressed: () async {
                      await _searchLocation();
                    },
                  ),
                ),
                onSubmitted: (_) async {
                  await _searchLocation();
                },
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 180,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(_latitude ?? 40.416775, _longitude ?? -3.703790),
                      zoom: 13,
                    ),
                    onTap: (pos) {
                      setState(() {
                        _latitude = pos.latitude;
                        _longitude = pos.longitude;
                        _markers = {
                          Marker(markerId: MarkerId("evento"), position: pos)
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
                  child: Text(
                    _ubicacionError!,
                    style: TextStyle(
                      color: Colors.red,
                      fontFamily: "Roboto",
                    ),
                  ),
                ),
              const SizedBox(height: 18),

              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              SizedBox(height: height / 20),
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
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;
                          if (_latitude == null || _longitude == null) {
                            setState(() => _ubicacionError = "Selecciona ubicación en el mapa");
                            return;
                          }
                          await _submitForm();
                        },
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
