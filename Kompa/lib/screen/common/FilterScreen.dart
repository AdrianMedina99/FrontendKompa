import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../../providers/CategoryProvider.dart';
import '../../providers/HomeProvider.dart';
import '../../config/dark_mode.dart';
import '../../config/AppConstants.dart';

class Filter extends StatefulWidget {
  const Filter({super.key});

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {

  //=================
  // Variables
  //=================
  ColorNotifire notifier = ColorNotifire();
  double _distance = 0;
  DateTime? _startDate;
  DateTime? _endDate;
  List<Map<String, dynamic>> _selectedCategories = [];
  Position? _currentPosition;
  int? _edad;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadCategories();
  }

  ///Metodo para obtener la ubicación actual del usuario
  Future<void> _getCurrentLocation() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition();
    } catch (e) {
      print("Error obteniendo ubicación: $e");
    }
  }

  ///Metodo para cargar las categorías desde el proveedor
  Future<void> _loadCategories() async {
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    await categoryProvider.fetchCategories();
  }

  ///Metodo para aplicar los filtros seleccionados
  void _applyFilters() {
    if (_startDate != null && _endDate != null && _endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("La fecha de fin no puede ser anterior a la fecha de inicio."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    Navigator.pop(context, {
      'distance': _distance,
      'startDate': _startDate,
      'endDate': _endDate,
      'categories': _selectedCategories.map((c) => c['id']).toList(),
      'position': _currentPosition,
      'edad': _edad,
    });
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    var height = MediaQuery.of(context).size.height;

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
          "Filter",
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Ariom-Bold",
            color: notifier.textColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppConstants.Height(height / 30),
              Text(
                "Date Range",
                style: TextStyle(
                  fontFamily: "Ariom-Bold",
                  fontSize: 20,
                  color: notifier.textColor,
                ),
              ),
              AppConstants.Height(height / 40),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _startDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _startDate = pickedDate;
                          });
                        }
                      },
                      child: Container(
                        height: height / 14,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: notifier.backGround,
                          border: Border.all(
                            color: notifier.textColor,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _startDate != null
                                ? DateFormat("dd-MM-yyyy").format(_startDate!)
                                : "Start Date",
                            style: TextStyle(
                              color: notifier.textColor,
                              fontSize: 17,
                              fontFamily: "Ariom-Bold",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _endDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _endDate = pickedDate;
                          });
                        }
                      },
                      child: Container(
                        height: height / 14,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: notifier.backGround,
                          border: Border.all(
                            color: notifier.textColor,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _endDate != null
                                ? DateFormat("dd-MM-yyyy").format(_endDate!)
                                : "End Date",
                            style: TextStyle(
                              color: notifier.textColor,
                              fontSize: 17,
                              fontFamily: "Ariom-Bold",
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              AppConstants.Height(height / 30),
              Text(
                "Distance (km)",
                style: TextStyle(
                  fontFamily: "Ariom-Bold",
                  fontSize: 20,
                  color: notifier.textColor,
                ),
              ),
              AppConstants.Height(height / 30),
              Slider(
                value: _distance,
                max: 100,
                divisions: 100,
                label: '${_distance.toInt()} km',
                thumbColor: notifier.textColor,
                activeColor: notifier.textColor,
                inactiveColor: const Color(0xffB6B6C0),
                onChanged: (value) {
                  setState(() {
                    _distance = value;
                  });
                },
              ),
              AppConstants.Height(height / 30),
              Text(
                "Category",
                style: TextStyle(
                  fontFamily: "Ariom-Bold",
                  fontSize: 20,
                  color: notifier.textColor,
                ),
              ),
              AppConstants.Height(height / 40),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: categoryProvider.categories.map((category) {
                  final isSelected = _selectedCategories.contains(category);
                  return InkWell(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedCategories.remove(category);
                        } else {
                          _selectedCategories.add(category);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: isSelected ? notifier.textColor : notifier.backGround,
                        border: Border.all(
                          color: isSelected ? notifier.textColor : Colors.black,
                        ),
                      ),
                      child: Text(
                        category['title'],
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected ? notifier.backGround : notifier.textColor,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              AppConstants.Height(height / 40),
              Text(
                "Edad mínima",
                style: TextStyle(
                  fontFamily: "Ariom-Bold",
                  fontSize: 20,
                  color: notifier.textColor,
                ),
              ),
              AppConstants.Height(height / 40),
              Container(
                height: height / 14,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: notifier.backGround,
                  border: Border.all(
                    color: notifier.textColor,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: notifier.textColor, fontSize: 17),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Edad mínima",
                      hintStyle: TextStyle(
                        color: notifier.hintTextColor,
                        fontSize: 17,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _edad = int.tryParse(value);
                      });
                    },
                  ),
                ),
              ),
              AppConstants.Height(height / 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: _applyFilters,
        child: Container(
          height: height / 11,
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            color: Color(0xffD1E50C),
          ),
          child: const Center(
            child: Text(
              "Apply",
              style: TextStyle(
                fontSize: 22,
                fontFamily: "Ariom-Bold",
                color: Color(0xff131313),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
