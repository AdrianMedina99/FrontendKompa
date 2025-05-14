// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../Config/common.dart';
import '../../dark_mode.dart';

class Sign_up extends StatefulWidget {
  const Sign_up({super.key});

  @override
  State<Sign_up> createState() => _Sign_upState();
}

class _Sign_upState extends State<Sign_up> with SingleTickerProviderStateMixin {
  ColorNotifire notifier = ColorNotifire();
  late TabController _tabController;
  
  // Variables para controlar la visibilidad de las contraseñas
  bool _obscureTextClient = true;
  bool _obscureTextBusiness = true;
  
  // Controlador para la fecha de nacimiento
  final TextEditingController _dateController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // Función para mostrar el selector de fecha
  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)), // ~18 años
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xffD1E50C),
              onPrimary: Colors.black,
              surface: notifier.backGround,
              onSurface: notifier.textColor,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          "Registrarse",
          style: TextStyle(
            fontSize: 20,
            fontFamily: "Ariom-Bold",
            color: notifier.textColor,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xffD1E50C),
          unselectedLabelColor: notifier.textColor,
          indicatorColor: const Color(0xffD1E50C),
          tabs: const [
            Tab(text: "Cliente"),
            Tab(text: "Negocio"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Formulario para clientes
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Información de acceso",
                    style: TextStyle(
                      color: notifier.textColor,
                      fontFamily: "Ariom-Bold",
                      fontSize: 18,
                    ),
                  ),
                  AppConstants.Height(height / 50),
                  // Campo de correo electrónico
                  _buildTextField(
                    hintText: "Correo electrónico",
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  AppConstants.Height(height / 50),
                  // Campo de contraseña
                  _buildTextField(
                    hintText: "Contraseña",
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    obscureText: _obscureTextClient,
                    onVisibilityToggle: () {
                      setState(() {
                        _obscureTextClient = !_obscureTextClient;
                      });
                    },
                  ),
                  
                  AppConstants.Height(height / 30),
                  Text(
                    "Datos personales",
                    style: TextStyle(
                      color: notifier.textColor,
                      fontFamily: "Ariom-Bold",
                      fontSize: 18,
                    ),
                  ),
                  AppConstants.Height(height / 50),
                  // Nombre
                  _buildTextField(
                    hintText: "Nombre",
                    prefixIcon: Icons.person_outline,
                  ),
                  AppConstants.Height(height / 50),
                  // Apellidos
                  _buildTextField(
                    hintText: "Apellidos",
                    prefixIcon: Icons.person_outline,
                  ),
                  AppConstants.Height(height / 50),
                  // Fecha de nacimiento
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: _buildTextField(
                        hintText: "Fecha de nacimiento",
                        prefixIcon: Icons.calendar_today_outlined,
                        controller: _dateController,
                      ),
                    ),
                  ),
                  AppConstants.Height(height / 50),
                  // DNI
                  _buildTextField(
                    hintText: "DNI",
                    prefixIcon: Icons.credit_card_outlined,
                  ),
                  AppConstants.Height(height / 50),
                  // Teléfono
                  _buildTextField(
                    hintText: "Teléfono",
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  
                  // Selector de género
                  AppConstants.Height(height / 50),
                  Text(
                    "Género",
                    style: TextStyle(
                      color: notifier.textColor,
                      fontFamily: "Ariom-Regular",
                      fontSize: 16,
                    ),
                  ),
                  AppConstants.Height(height / 70),
                  _buildDropdownField(
                    items: const ["Masculino", "Femenino", "Otro", "Prefiero no decirlo"],
                    hintText: "Selecciona tu género",
                  ),
                  
                  AppConstants.Height(height / 50),
                  // Descripción
                  _buildTextField(
                    hintText: "Descripción (opcional)",
                    prefixIcon: Icons.description_outlined,
                    maxLines: 3,
                  ),
                  
                  AppConstants.Height(height / 30),
                  Text(
                    "Dirección",
                    style: TextStyle(
                      color: notifier.textColor,
                      fontFamily: "Ariom-Bold",
                      fontSize: 18,
                    ),
                  ),
                  AppConstants.Height(height / 50),
                  // Calle
                  _buildTextField(
                    hintText: "Calle y número",
                    prefixIcon: Icons.home_outlined,
                  ),
                  AppConstants.Height(height / 50),
                  // Ciudad
                  _buildTextField(
                    hintText: "Ciudad",
                    prefixIcon: Icons.location_city_outlined,
                  ),
                  AppConstants.Height(height / 50),
                  // Código Postal
                  _buildTextField(
                    hintText: "Código Postal",
                    prefixIcon: Icons.markunread_mailbox_outlined,
                    keyboardType: TextInputType.number,
                  ),
                  AppConstants.Height(height / 50),
                  // Provincia / Estado
                  _buildTextField(
                    hintText: "Provincia / Estado",
                    prefixIcon: Icons.map_outlined,
                  ),
                  AppConstants.Height(height / 50),
                  // País
                  _buildTextField(
                    hintText: "País",
                    prefixIcon: Icons.public_outlined,
                  ),
                  
                  AppConstants.Height(height / 30),
                  // Botón de registro
                  Container(
                    height: height / 13,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xffD1E50C),
                    ),
                    child: const Center(
                      child: Text(
                        "Registrarse",
                        style: TextStyle(
                          color: Color(0xff131313),
                          fontSize: 22,
                          fontFamily: "Ariom-Bold",
                        ),
                      ),
                    ),
                  ),
                  AppConstants.Height(height / 20),
                ],
              ),
            ),
          ),
          
          // Formulario para negocios
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Información de acceso",
                    style: TextStyle(
                      color: notifier.textColor,
                      fontFamily: "Ariom-Bold",
                      fontSize: 18,
                    ),
                  ),
                  AppConstants.Height(height / 50),
                  // Campo de correo electrónico
                  _buildTextField(
                    hintText: "Correo electrónico corporativo",
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  AppConstants.Height(height / 50),
                  // Campo de contraseña
                  _buildTextField(
                    hintText: "Contraseña",
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    obscureText: _obscureTextBusiness,
                    onVisibilityToggle: () {
                      setState(() {
                        _obscureTextBusiness = !_obscureTextBusiness;
                      });
                    },
                  ),
                  
                  AppConstants.Height(height / 30),
                  Text(
                    "Datos del negocio",
                    style: TextStyle(
                      color: notifier.textColor,
                      fontFamily: "Ariom-Bold",
                      fontSize: 18,
                    ),
                  ),
                  AppConstants.Height(height / 50),
                  // Nombre de la empresa
                  _buildTextField(
                    hintText: "Nombre de la empresa",
                    prefixIcon: Icons.business_outlined,
                  ),
                  AppConstants.Height(height / 50),
                  // Teléfono
                  _buildTextField(
                    hintText: "Teléfono de contacto",
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  AppConstants.Height(height / 50),
                  // Sitio web
                  _buildTextField(
                    hintText: "Sitio web",
                    prefixIcon: Icons.web_outlined,
                    keyboardType: TextInputType.url,
                  ),
                  AppConstants.Height(height / 50),
                  // Descripción de la empresa
                  _buildTextField(
                    hintText: "Descripción de la empresa",
                    prefixIcon: Icons.description_outlined,
                    maxLines: 3,
                  ),
                  
                  AppConstants.Height(height / 30),
                  Text(
                    "Dirección",
                    style: TextStyle(
                      color: notifier.textColor,
                      fontFamily: "Ariom-Bold",
                      fontSize: 18,
                    ),
                  ),
                  AppConstants.Height(height / 50),
                  // Calle
                  _buildTextField(
                    hintText: "Calle y número",
                    prefixIcon: Icons.home_outlined,
                  ),
                  AppConstants.Height(height / 50),
                  // Ciudad
                  _buildTextField(
                    hintText: "Ciudad",
                    prefixIcon: Icons.location_city_outlined,
                  ),
                  AppConstants.Height(height / 50),
                  // Código Postal
                  _buildTextField(
                    hintText: "Código Postal",
                    prefixIcon: Icons.markunread_mailbox_outlined,
                    keyboardType: TextInputType.number,
                  ),
                  AppConstants.Height(height / 50),
                  // Provincia / Estado
                  _buildTextField(
                    hintText: "Provincia / Estado",
                    prefixIcon: Icons.map_outlined,
                  ),
                  AppConstants.Height(height / 50),
                  // País
                  _buildTextField(
                    hintText: "País",
                    prefixIcon: Icons.public_outlined,
                  ),
                  
                  AppConstants.Height(height / 30),
                  // Botón de registro
                  Container(
                    height: height / 13,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xffD1E50C),
                    ),
                    child: const Center(
                      child: Text(
                        "Registrar negocio",
                        style: TextStyle(
                          color: Color(0xff131313),
                          fontSize: 22,
                          fontFamily: "Ariom-Bold",
                        ),
                      ),
                    ),
                  ),
                  AppConstants.Height(height / 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Widget para construir los campos de texto
  Widget _buildTextField({
    required String hintText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool obscureText = false,
    Function? onVisibilityToggle,
    int maxLines = 1,
    TextEditingController? controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: notifier.containerColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: isPassword ? obscureText : false,
        maxLines: maxLines,
        style: TextStyle(
          color: notifier.textColor,
          fontFamily: "Ariom-Regular",
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: notifier.subtitleTextColor,
            fontFamily: "Ariom-Regular",
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: notifier.subtitleTextColor,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: notifier.subtitleTextColor,
                  ),
                  onPressed: () {
                    if (onVisibilityToggle != null) {
                      onVisibilityToggle();
                    }
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: maxLines > 1 ? 15 : 0,
          ),
        ),
      ),
    );
  }
  
  // Widget para construir campos de selección desplegable
  Widget _buildDropdownField({
    required List<String> items,
    required String hintText,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: notifier.containerColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        hint: Text(
          hintText,
          style: TextStyle(
            color: notifier.subtitleTextColor,
            fontFamily: "Ariom-Regular",
          ),
        ),
        dropdownColor: notifier.containerColor,
        style: TextStyle(
          color: notifier.textColor,
          fontFamily: "Ariom-Regular",
        ),
        icon: Icon(
          Icons.arrow_drop_down,
          color: notifier.subtitleTextColor,
        ),
        isExpanded: true,
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          // Sin funcionalidad
        },
      ),
    );
  }
}
