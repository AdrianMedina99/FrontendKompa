import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../config/AppConstants.dart';
import '../../config/dark_mode.dart';
import '../../providers/AuthProvider.dart';
import '../common/BottomScreen.dart';

class Edit_Profile extends StatefulWidget {
  //===========
  // Variables
  //===========
  final String userType;

  const Edit_Profile({super.key, required this.userType});

  @override
  State<Edit_Profile> createState() => _Edit_ProfileState();
}

class _Edit_ProfileState extends State<Edit_Profile> {
  //===========
  // Variables
  //===========
  ColorNotifire notifier = ColorNotifire();
  Map<String, dynamic>? userData;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  ///Metodo para cargar los datos del usuario
  Future<void> _loadUserData() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final data = await authProvider.getCurrentUserData();

      if (data.isNotEmpty) {
        setState(() {
          userData = data;
          _nameController.text = data['nombre'] ?? '';
          _lastNameController.text = data['apellidos'] ?? '';
          _phoneController.text = data['phone'] ?? '';
          _descriptionController.text = data['description'] ?? '';
          _dniController.text = data['dni'] ?? '';
          _selectedValue = data['gender'] ?? '';
          _dateController.text = _getFormattedBirthDate(data['birthDate']) ?? '';
          _websiteController.text = data['website'] ?? '';
        });
      }
    } catch (e) {
      print('Error al cargar los datos del usuario: $e');
    }
  }

  ///Metodo para formatear la fecha de nacimiento
  String? _getFormattedBirthDate(dynamic birthDate) {
    if (birthDate == null) return null;
    try {
      DateTime date;
      if (birthDate is Map && birthDate.containsKey('seconds')) {
        final seconds = birthDate['seconds'] as int;
        date = DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true).add(const Duration(hours: 2));
      } else if (birthDate is String) {
        date = DateTime.parse(birthDate).toLocal();
      } else {
        return null;
      }
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      print('Error al formatear birthDate: $e');
      return null;
    }
  }

/// Controladores de texto para los campos del formulario
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    _dniController.dispose();
    _dateController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      try {
        final String extension = pickedFile.path.split('.').last.toLowerCase();
        final List<String> formatosPermitidos = ['png', 'svg', 'jpg', 'jpeg', 'gif', 'webp'];

        if (!formatosPermitidos.contains(extension)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Formato no soportado.")),
          );
          return;
        }

        final File file = File(pickedFile.path);
        final int fileSize = await file.length();

        final int estimatedBase64Size = (fileSize * 1.33).toInt();
        final int maxSize = 2 * 1024 * 1024;

        if (estimatedBase64Size > maxSize) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("La imagen es demasiado grande incluso después de codificarla."),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }

        setState(() {
          _profileImage = file;
        });

      } catch (e) {
        print("Error al procesar imagen: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: notifier.backGround,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
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
        title: Text(
          "Editar perfil",
          style: TextStyle(
            color: notifier.textColor,
            fontSize: 22,
            fontFamily: "Ariom-Bold",
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: _buildProfileImage(),
            ),
            SizedBox(height: height / 40),
            widget.userType == "CLIENT"
                ? _buildClientFields(height, width)
                : _buildBusinessFields(height, width),
          ],
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () async {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);

          try {
            /// Validaciones de los campos

            if (_nameController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("El campo nombre es obligatorio"),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              return;
            }

            if (_phoneController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("El campo teléfono es obligatorio"),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              return;
            }

            if (!RegExp(r'^[0-9]{9,}$').hasMatch(_phoneController.text)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("El teléfono debe contener al menos 9 dígitos"),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              return;
            }

            if (widget.userType == "CLIENT") {
              if (_dateController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("La fecha de nacimiento es obligatoria"),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }

              if (_dniController.text.isNotEmpty &&
                  !RegExp(r'^[0-9]{8}[A-Za-z]$').hasMatch(_dniController.text)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("El formato del DNI no es válido"),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }
            }

            if (widget.userType == "BUSINESS" && _websiteController.text.isNotEmpty) {
              final urlPattern = RegExp(
                r'^(http|https)://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)?$',
                caseSensitive: false,
              );
              if (!urlPattern.hasMatch(_websiteController.text)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("La URL del sitio web no es válida"),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }
            }

            Map<String, dynamic> updatedData;

            if (widget.userType == "CLIENT") {
              final parsedDate = DateFormat('dd/MM/yyyy').parse(_dateController.text);
              final dateOnly = DateTime.utc(parsedDate.year, parsedDate.month, parsedDate.day);
              final formattedDate = dateOnly.toIso8601String();

              updatedData = {
                ...userData!,
                'nombre': _nameController.text,
                'apellidos': _lastNameController.text,
                'phone': int.tryParse(_phoneController.text) ?? _phoneController.text,
                'description': _descriptionController.text,
                'dni': _dniController.text,
                'gender': _selectedValue,
                'birthDate': formattedDate,
              };
            } else if (widget.userType == "BUSINESS") {
              updatedData = {
                ...userData!,
                'nombre': _nameController.text,
                'phone': int.tryParse(_phoneController.text) ?? _phoneController.text,
                'description': _descriptionController.text,
                'website': _websiteController.text,
              };
            } else {
              throw Exception("Tipo de usuario desconocido");
            }

            await authProvider.updateUserWithPhoto(updatedData, _profileImage);
            await authProvider.getCurrentUserData();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Datos actualizados correctamente")),
            );

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const BottomBarScreen()),
                  (route) => false,
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error al actualizar los datos: $e")),
            );
          }
        },

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
              "Guardar Cambios",
              style: TextStyle(
                color: Color(0xff131313),
                fontSize: 18,
                fontFamily: "Ariom-Bold",
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClientFields(double height, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          "Nombre",
          userData?['nombre'] ?? "Su nombre",
          SvgPicture.asset(
            "assets/Name.svg",
            color: notifier.textColor,
            height: 24,
            width: 24,
          ),
          controller: _nameController,
        ),
        AppConstants.Height(height / 30),
        _buildTextField(
          "Apellidos",
          userData?['apellidos'] ?? "Sus apellidos",
          SvgPicture.asset(
            "assets/Name.svg",
            color: notifier.textColor,
            height: 24,
            width: 24,
          ),
          controller: _lastNameController,
        ),
        AppConstants.Height(height / 30),
        _buildTextField(
          "Telefono",
          userData?['phone'] ?? "Su teléfono",
          SvgPicture.asset(
            "assets/Call.svg",
            color: notifier.textColor,
            height: 24,
            width: 24,
          ),
          controller: _phoneController,
        ),
        AppConstants.Height(height / 30),
        _buildTextField(
          "Descripción",
          userData?['description'] ?? "Ingrese una breve descripción",
          SvgPicture.asset(
            "assets/Description.svg",
            color: notifier.textColor,
            height: 24,
            width: 24,
          ),
          controller: _descriptionController,
        ),
        AppConstants.Height(height / 30),
        _buildTextField(
          "DNI",
          userData?['dni'] ?? "Su DNI",
          SvgPicture.asset(
            "assets/DNI.svg",
            color: notifier.textColor,
            height: 24,
            width: 24,
          ),
          controller: _dniController,
        ),
        AppConstants.Height(height / 30),
        _buildTextField(
          "Fecha de nacimiento",
          _getFormattedBirthDate(userData?['birthDate']) ?? "Seleccione su fecha de nacimiento",
          SvgPicture.asset(
            "assets/Calendar.svg",
            color: notifier.textColor,
            height: 24,
            width: 24,
          ),
          controller: _dateController,
          isReadOnly: true,
          onTap: () => _selectDate(context),
        ),
        AppConstants.Height(height / 30),
        Text(
          "Género",
          style: TextStyle(
            color: notifier.textColor,
            fontSize: 20,
            fontFamily: "Ariom-Bold",
          ),
        ),
        AppConstants.Height(height / 30),
        _buildDropdownField(
          items: const ["Masculino", "Femenino", "Otro", "Prefiero no decirlo"],
          hintText: "Selecciona tu género",
        ),
      ],
    );
  }

  Widget _buildBusinessFields(double height, double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          "Nombre de la empresa",
          userData?['nombre'] ?? "Su empresa",
          SvgPicture.asset(
            "assets/Business.svg",
            color: notifier.textColor,
            height: 24,
            width: 24,
          ),
          controller: _nameController,
        ),
        AppConstants.Height(height / 30),
        _buildTextField(
          "Teléfono",
          userData?['phone'] ?? "Su teléfono",
          SvgPicture.asset(
            "assets/Call.svg",
            color: notifier.textColor,
            height: 24,
            width: 24,
          ),
          controller: _phoneController,
        ),
        AppConstants.Height(height / 30),
        _buildTextField(
          "Sitio web",
          userData?['website'] ?? "Su sitio web",
          SvgPicture.asset(
            "assets/Web.svg",
            color: notifier.textColor,
            height: 24,
            width: 24,
          ),
          controller: _websiteController,
        ),
        AppConstants.Height(height / 30),
        _buildTextField(
          "Descripción",
          userData?['description'] ?? "Descripción de la empresa",
          SvgPicture.asset(
            "assets/Description.svg",
            color: notifier.textColor,
            height: 24,
            width: 24,
          ),
          controller: _descriptionController,
        ),
      ],
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 7,
          width: MediaQuery.of(context).size.width / 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: _profileImage != null
                ? Image.file(
              _profileImage!,
              fit: BoxFit.cover,
            )
                : (userData != null && userData!['photo'] != null && userData!['photo'].toString().isNotEmpty)
                ? Image.network(
              userData!['photo'],
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                    color: notifier.buttonColor,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => Image.asset(
                "assets/Profile.png",
                fit: BoxFit.cover,
              ),
            )
                : Image.asset(
              "assets/Profile.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: _pickImage,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xffD1E50C),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.camera_alt,
                color: notifier.textColor,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String hint, Widget icon, {bool isNumber = false, int maxLines = 1, TextEditingController? controller, bool isReadOnly = false, VoidCallback? onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: notifier.textColor,
            fontSize: 20,
            fontFamily: "Ariom-Bold",
          ),
        ),
        AppConstants.Height(10),
        Container(
          alignment: Alignment.center,
          height: maxLines > 1 ? null : MediaQuery.of(context).size.height / 13,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: notifier.textColor,
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 8.0, bottom: 2),
                child: icon,
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  readOnly: isReadOnly,
                  onTap: onTap,
                  keyboardType: isNumber ? TextInputType.number : TextInputType.text,
                  maxLines: maxLines,
                  style: TextStyle(
                    color: notifier.textColor,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: notifier.textColor,
                      fontSize: 14,
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.only(left: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String? _selectedValue;
  Widget _buildDropdownField({required List<String> items, required String hintText}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: notifier.textColor,
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedValue != '' ? _selectedValue : null,
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
        hint: Text(
          hintText,
          style: TextStyle(
            color: notifier.textColor,
            fontFamily: "Ariom-Regular",
          ),
        ),
        dropdownColor: notifier.backGround,
        style: TextStyle(
          color: notifier.textColor,
          fontFamily: "Ariom-Regular",
        ),
        icon: Icon(
          Icons.arrow_drop_down,
          color: notifier.textColor,
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
            _selectedValue = newValue;
          });
        },
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)),
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
}
