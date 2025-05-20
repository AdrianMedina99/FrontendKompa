// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../Config/common.dart';
import '../../dark_mode.dart';
import '../../providers/AuthProvider.dart';
import 'loginScreen.dart';

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

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  // Variable para el género seleccionado
  String? _selectedGender;

  // Map para almacenar errores de validación
  final Map<String, String?> _validationErrors = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // Libera los controladores
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    _dniController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _businessNameController.dispose();
    _descriptionController.dispose();
    _websiteController.dispose();
    _dateController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _registerUser(BuildContext context) async {
    // Validaciones para CLIENTE
    if (_tabController.index == 0) {
      if (_emailController.text.isEmpty ||
          _passwordController.text.isEmpty ||
          _repeatPasswordController.text.isEmpty ||
          _nameController.text.isEmpty ||
          _lastNameController.text.isEmpty ||
          _dateController.text.isEmpty || // Solo para cliente
          _dniController.text.isEmpty ||
          _phoneController.text.isEmpty ||
          _selectedGender == null ||
          _streetController.text.isEmpty ||
          _cityController.text.isEmpty ||
          _postalCodeController.text.isEmpty ||
          _stateController.text.isEmpty ||
          _countryController.text.isEmpty) {
        _showErrorDialog(context, "Por favor, complete todos los campos obligatorios.");
        return;
      }

      // Validación de formato de fecha
      try {
        DateFormat('dd/MM/yyyy').parse(_dateController.text);
      } catch (e) {
        _showErrorDialog(context, "Formato de fecha inválido. Use dd/MM/yyyy.");
        return;
      }
    }

    // Validaciones para NEGOCIO
    if (_tabController.index == 1) {
      if (_emailController.text.isEmpty ||
          _passwordController.text.isEmpty ||
          _repeatPasswordController.text.isEmpty ||
          _businessNameController.text.isEmpty ||
          _phoneController.text.isEmpty ||
          _websiteController.text.isEmpty ||
          _streetController.text.isEmpty ||
          _cityController.text.isEmpty ||
          _postalCodeController.text.isEmpty ||
          _stateController.text.isEmpty ||
          _countryController.text.isEmpty) {
        _showErrorDialog(context, "Por favor, complete todos los campos obligatorios.");
        return;
      }
    }

    // Validación de contraseñas iguales
    if (_passwordController.text != _repeatPasswordController.text) {
      _showErrorDialog(context, "Las contraseñas no coinciden.");
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final userType = _tabController.index == 0 ? "CLIENT" : "BUSINESS";

    // Construcción de datos
    final userData = _tabController.index == 0
        ? {
      'nombre': _nameController.text,
      'apellidos': _lastNameController.text,
      'dni': _dniController.text,
      'phone': _phoneController.text,
      'description': _descriptionController.text,
      'gender': _selectedGender,
      'birthDate': DateFormat('dd/MM/yyyy').parse(_dateController.text).toUtc().toIso8601String(),
    }
        : {
      'nombre': _businessNameController.text,
      'phone': _phoneController.text,
      'description': _descriptionController.text,
      'website': _websiteController.text,
    };

    final addressData = {
      'street': _streetController.text,
      'city': _cityController.text,
      'postalCode': _postalCodeController.text,
      'state': _stateController.text,
      'country': _countryController.text,
    };

    final success = await authProvider.registerUser(
      userType: userType,
      email: _emailController.text,
      password: _passwordController.text,
      userData: userData,
      addressData: addressData,
    );

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Welcome()),
      );
    } else {
      _showErrorDialog(context, authProvider.errorMessage ?? 'Error desconocido');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("Aceptar"),
          ),
        ],
      ),
    );
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

  // Método para validar campos en tiempo real
  void _validateField(String fieldName, String value) {
    setState(() {
      switch (fieldName) {
        case 'email':
          if (value.isEmpty) {
            _validationErrors['email'] = "El correo electrónico es obligatorio.";
          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            _validationErrors['email'] = "Ingrese un correo electrónico válido.";
          } else {
            _validationErrors['email'] = null;
          }
          break;
        case 'password':
          if (value.isEmpty) {
            _validationErrors['password'] = "La contraseña es obligatoria.";
          } else if (value.length < 6) {
            _validationErrors['password'] = "La contraseña debe tener al menos 6 caracteres.";
          } else {
            _validationErrors['password'] = null;
          }
          break;
        case 'repeatPassword':
          if (value.isEmpty) {
            _validationErrors['repeatPassword'] = "Debe repetir la contraseña.";
          } else if (value != _passwordController.text) {
            _validationErrors['repeatPassword'] = "Las contraseñas no coinciden.";
          } else {
            _validationErrors['repeatPassword'] = null;
          }
          break;
        case 'phone':
          if (value.isEmpty) {
            _validationErrors['phone'] = "El teléfono es obligatorio.";
          } else if (!RegExp(r'^\d{10,}$').hasMatch(value)) {
            _validationErrors['phone'] = "El teléfono debe contener al menos 10 dígitos.";
          } else {
            _validationErrors['phone'] = null;
          }
          break;
        default:
          break;
      }
    });
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
                  _buildValidatedTextField(
                    hintText: "Correo electrónico",
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    fieldName: 'email',
                  ),
                  AppConstants.Height(height / 50),
                  // Campo de contraseña
                  _buildValidatedTextField(
                    hintText: "Contraseña",
                    prefixIcon: Icons.lock_outline,
                    controller: _passwordController,
                    isPassword: true,
                    obscureText: _obscureTextClient,
                    fieldName: 'password',
                    onVisibilityToggle: () {
                      setState(() {
                        _obscureTextClient = !_obscureTextClient;
                      });
                    },
                  ),
                  AppConstants.Height(height / 50),
                  // Campo de repetir contraseña
                  _buildValidatedTextField(
                    hintText: "Repetir contraseña",
                    prefixIcon: Icons.lock_outline,
                    controller: _repeatPasswordController,
                    isPassword: true,
                    obscureText: _obscureTextClient, // Usa la misma lógica de visibilidad
                    fieldName: 'repeatPassword',
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
                    controller: _nameController,
                  ),
                  AppConstants.Height(height / 50),
                  // Apellidos
                  _buildTextField(
                    hintText: "Apellidos",
                    prefixIcon: Icons.person_outline,
                    controller: _lastNameController,
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
                    controller: _dniController,
                  ),
                  AppConstants.Height(height / 50),
                  // Teléfono
                  _buildValidatedTextField(
                    hintText: "Teléfono",
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    controller: _phoneController,
                    fieldName: 'phone',
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
                    controller: _streetController,
                  ),
                  AppConstants.Height(height / 50),
                  // Ciudad
                  _buildTextField(
                    hintText: "Ciudad",
                    prefixIcon: Icons.location_city_outlined,
                    controller: _cityController,
                  ),
                  AppConstants.Height(height / 50),
                  // Código Postal
                  _buildTextField(
                    hintText: "Código Postal",
                    prefixIcon: Icons.markunread_mailbox_outlined,
                    keyboardType: TextInputType.number,
                    controller: _postalCodeController,
                  ),
                  AppConstants.Height(height / 50),
                  // Provincia / Estado
                  _buildTextField(
                    hintText: "Provincia / Estado",
                    prefixIcon: Icons.map_outlined,
                    controller: _stateController,
                  ),
                  AppConstants.Height(height / 50),
                  // País
                  _buildTextField(
                    hintText: "País",
                    prefixIcon: Icons.public_outlined,
                    controller: _countryController,
                  ),

                  AppConstants.Height(height / 30),
                  // Botón de registro
                  GestureDetector(
                    onTap: () => _registerUser(context),
                    child: Container(
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
                  _buildValidatedTextField(
                    hintText: "Correo electrónico corporativo",
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController, // Conexión al controlador
                    fieldName: 'email',
                  ),
                  AppConstants.Height(height / 50),
                  // Campo de contraseña
                  _buildValidatedTextField(
                    hintText: "Contraseña",
                    prefixIcon: Icons.lock_outline,
                    controller: _passwordController, // Conexión al controlador
                    isPassword: true,
                    obscureText: _obscureTextBusiness,
                    fieldName: 'password',
                    onVisibilityToggle: () {
                      setState(() {
                        _obscureTextBusiness = !_obscureTextBusiness;
                      });
                    },
                  ),
                  AppConstants.Height(height / 50),
                  // Campo de repetir contraseña
                  _buildValidatedTextField(
                    hintText: "Repetir contraseña",
                    prefixIcon: Icons.lock_outline,
                    controller: _repeatPasswordController, // Conexión al controlador
                    isPassword: true,
                    obscureText: _obscureTextBusiness,
                    fieldName: 'repeatPassword',
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
                    controller: _businessNameController, // Conexión al controlador
                  ),
                  AppConstants.Height(height / 50),
                  // Teléfono
                  _buildValidatedTextField(
                    hintText: "Teléfono de contacto",
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    controller: _phoneController, // Conexión al controlador
                    fieldName: 'phone',
                  ),
                  AppConstants.Height(height / 50),
                  // Sitio web
                  _buildTextField(
                    hintText: "Sitio web",
                    prefixIcon: Icons.web_outlined,
                    keyboardType: TextInputType.url,
                    controller: _websiteController, // Conexión al controlador
                  ),
                  AppConstants.Height(height / 50),
                  // Descripción de la empresa
                  _buildTextField(
                    hintText: "Descripción de la empresa",
                    prefixIcon: Icons.description_outlined,
                    maxLines: 3,
                    controller: _descriptionController, // Conexión al controlador
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
                    controller: _streetController, // Conexión al controlador
                  ),
                  AppConstants.Height(height / 50),
                  // Ciudad
                  _buildTextField(
                    hintText: "Ciudad",
                    prefixIcon: Icons.location_city_outlined,
                    controller: _cityController, // Conexión al controlador
                  ),
                  AppConstants.Height(height / 50),
                  // Código Postal
                  _buildTextField(
                    hintText: "Código Postal",
                    prefixIcon: Icons.markunread_mailbox_outlined,
                    keyboardType: TextInputType.number,
                    controller: _postalCodeController, // Conexión al controlador
                  ),
                  AppConstants.Height(height / 50),
                  // Provincia / Estado
                  _buildTextField(
                    hintText: "Provincia / Estado",
                    prefixIcon: Icons.map_outlined,
                    controller: _stateController, // Conexión al controlador
                  ),
                  AppConstants.Height(height / 50),
                  // País
                  _buildTextField(
                    hintText: "País",
                    prefixIcon: Icons.public_outlined,
                    controller: _countryController, // Conexión al controlador
                  ),
                  AppConstants.Height(height / 30),
                  // Botón de registro
                  GestureDetector(
                    onTap: () => _registerUser(context),
                    child: Container(
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

  // Widget para construir campos de texto con validación
  Widget _buildValidatedTextField({
    required String hintText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool obscureText = false,
    Function? onVisibilityToggle,
    int maxLines = 1,
    required TextEditingController controller,
    required String fieldName,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
            onChanged: (value) => _validateField(fieldName, value),
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
                borderSide: BorderSide(
                  color: _validationErrors[fieldName] != null
                      ? Colors.red
                      : Colors.transparent,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: maxLines > 1 ? 15 : 0,
              ),
            ),
          ),
        ),
        if (_validationErrors[fieldName] != null)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              _validationErrors[fieldName]!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
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
          setState(() {
            _selectedGender = newValue;
          });
        },
      ),
    );
  }
}
