// lib/providers/auth_provider.dart
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:kompa/service/apiService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../service/SharedPreferencesService.dart';

class AuthProvider with ChangeNotifier {
  // ============================
  // Variables privadas y getters
  // ============================

  /// Servicio de API para autenticación y datos de usuario.
  final ApiService _apiService;

  /// Indica si el usuario está autenticado.
  bool _isAuthenticated = false;

  /// Indica si hay una operación de carga en curso.
  bool _isLoading = false;

  /// Token JWT de autenticación.
  String? _token;

  /// Tipo de usuario ("CLIENT" o "BUSINESS").
  String? _userType;

  /// Email del usuario autenticado.
  String? _email;

  /// ID del usuario autenticado.
  String? _userId;

  /// Datos del usuario autenticado.
  Map<String, dynamic>? _userData;

  /// Último mensaje de error.
  String? _errorMessage;

  /// Indica si el usuario eligió "recordarme".
  bool _rememberMe = false;

///Getters para acceder a los servicios y variables privadas
  ApiService get apiService => _apiService;

  // Getters públicos
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get token => _token;
  String? get userType => _userType;
  String? get email => _email;
  String? get userId => _userId;
  Map<String, dynamic>? get userData => _userData;
  String? get errorMessage => _errorMessage;
  bool get rememberMe => _rememberMe;

  /// Constructor que inicializa el servicio de API.
  AuthProvider({required String apiBaseUrl}) : _apiService = ApiService(baseUrl: apiBaseUrl);

  // ============================
  // Sección: Autenticación
  // ============================

  /// Inicia sesión manualmente con email y contraseña.
  /// Guarda el token y los datos si "recordarme" está activo.
  Future<bool> login({required String email, required String password, bool rememberMe = false}) async {
    _setLoading(true);
    _errorMessage = null;
    _rememberMe = rememberMe;

    try {
      final response = await _apiService.login(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );

      print("Respuesta de login: $response");

      // Verificar que el campo token exista
      if (!response.containsKey('token') || response['token'] == null) {
        _errorMessage = 'Error: No se recibió un token de autenticación';
        return false;
      }

      // Usar el JWT token
      _token = response['token'];
      _userId = response['uid'];
      _userType = response['userType'];
      _email = response['email'] ?? email;
      _isAuthenticated = true;

      // Guardar el refreshToken si está disponible
      if (response.containsKey('refreshToken')) {
        await SharedPreferencesService.saveString('refreshToken', response['refreshToken']);
      }

      // Configurar token en ApiService
      _apiService.setToken(_token);

      // Cargar datos del usuario
      if (_userId != null && _userType != null) {
        await _loadUserData();
      }

      // Guardar datos de autenticación
      await _saveAuthData();

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error al iniciar sesión: $e';
      print("Error completo: $e");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Intenta el inicio de sesión automático usando el token guardado.
  /// Valida el token con la API y restaura el estado si es válido.
  Future<bool> tryAutoLogin() async {
    final token = await SharedPreferencesService.getString('token');
    final rememberMe = await SharedPreferencesService.getBool('rememberMe') ?? false;

    if (token == null || !rememberMe) {
      return false;
    }

    try {
      // Validar el token con la API
      final isValid = await validateToken(token);

      if (isValid) {
        _token = token;
        _isAuthenticated = true;

        // Usar SharedPreferences para obtener los datos guardados
        _userId = await SharedPreferencesService.getString('userId');
        _userType = await SharedPreferencesService.getString('userType');
        _email = await SharedPreferencesService.getString('email');
        _userData = await SharedPreferencesService.getMap('userData');
        _rememberMe = rememberMe;

        // Configurar el token en ApiService
        _apiService.setToken(token);

        notifyListeners();
        return true;
      } else {
        await logout();
        return false;
      }
    } catch (e) {
      print("Error en autoLogin: $e");
      return false;
    }
  }

  /// Valida el token JWT con la API.
  Future<bool> validateToken(String token) async {
    try {
      final response = await _apiService.validateToken(token);
      return response['valid'] == true || response.containsKey('uid');
    } catch (_) {
      return false;
    }
  }

  /// Cierra la sesión del usuario y limpia los datos persistentes.
  Future<void> logout() async {
    _isAuthenticated = false;
    _token = null;
    _userType = null;
    _userId = null;
    _userData = null;

    _apiService.setToken(null);

    final prefs = await SharedPreferences.getInstance();
    if (!_rememberMe) {
      await prefs.clear();
    } else {
      await prefs.remove('token');
    }

    notifyListeners();
  }

  /// Configura el estado de "recordarme" y guarda o elimina datos según corresponda.
  Future<void> setRememberMe(bool value) async {
    _rememberMe = value;
    await SharedPreferencesService.saveBool('rememberMe', value);

    if (value && _isAuthenticated && _token != null) {
      await _saveAuthData();
    } else if (!value) {
      await SharedPreferencesService.remove('token');
      await SharedPreferencesService.remove('userId');
      await SharedPreferencesService.remove('userType');
      await SharedPreferencesService.remove('email');
      await SharedPreferencesService.remove('userData');
    }

    notifyListeners();
  }

  // ============================
  // Sección: Registro de usuarios
  // ============================

  /// Registra un nuevo cliente y realiza login automático si tiene éxito.
  Future<bool> registerClient({
    required String email,
    required String password,
    required String nombre,
    required String apellidos,
    required String dni,
    required String phone,
    required DateTime birthDate,
    String? description,
    required String gender,
    required String street,
    required String city,
    required String postalCode,
    required String state,
    required String country,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final userData = {
        'nombre': nombre,
        'apellidos': apellidos,
        'dni': dni,
        'phone': phone,
        'birthDate': birthDate.toUtc().toIso8601String(),
        'description': description ?? '',
        'gender': gender,
        'role': 'CLIENT',
      };

      final addressData = {
        'street': street,
        'city': city,
        'postalCode': postalCode,
        'state': state,
        'country': country,
      };

      final response = await _apiService.registerClient(
        email: email,
        password: password,
        userData: userData,
        addressData: addressData,
      );

      if (response.containsKey('success') && response['success'] == true) {
        return await login(email: email, password: password);
      } else if (response.containsKey('message') &&
          response['message'].toString().toLowerCase().contains('registrado correctamente')) {
        // Considera esto como éxito también
        return await login(email: email, password: password);
      } else {
        _errorMessage = 'Error en el registro: ${response['message'] ?? 'Desconocido'}';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error al registrar cliente: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Registra un nuevo negocio y realiza login automático si tiene éxito.
  Future<bool> registerBusiness({
    required String email,
    required String password,
    required String nombre,
    required String phone,
    required String description,
    String? website,
    required String street,
    required String city,
    required String postalCode,
    required String state,
    required String country,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final userData = {
        'nombre': nombre,
        'phone': phone,
        'description': description,
        'website': website ?? '',
        'role': 'BUSINESS',
      };

      final addressData = {
        'street': street,
        'city': city,
        'postalCode': postalCode,
        'state': state,
        'country': country,
      };

      final response = await _apiService.registerBusiness(
        email: email,
        password: password,
        userData: userData,
        addressData: addressData,
      );

      if (response.containsKey('success') && response['success'] == true) {
        return await login(email: email, password: password);
      } else if (response.containsKey('message') &&
          response['message'].toString().toLowerCase().contains('registrado correctamente')) {
        // Considera esto como éxito también
        return await login(email: email, password: password);
      } else {
        _errorMessage = 'Error en el registro: ${response['message'] ?? 'Desconocido'}';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error al registrar negocio: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Registra un usuario genérico (cliente o negocio) según el tipo.
  Future<bool> registerUser({
    required String userType,
    required String email,
    required String password,
    required Map<String, dynamic> userData,
    required Map<String, dynamic> addressData,
  }) async {
    if (userType == "CLIENT") {
      var birthDateValue = userData['birthDate'];
      DateTime birthDate;
      if (birthDateValue is int) {
        birthDate = DateTime.fromMillisecondsSinceEpoch(birthDateValue);
      } else if (birthDateValue is String) {
        birthDate = DateTime.parse(birthDateValue);
      } else {
        throw Exception('Formato de fecha no soportado');
      }
      return await registerClient(
        email: email,
        password: password,
        nombre: userData['nombre'],
        apellidos: userData['apellidos'],
        dni: userData['dni'],
        phone: userData['phone'],
        birthDate: birthDate,
        description: userData['description'],
        gender: userData['gender'],
        street: addressData['street'],
        city: addressData['city'],
        postalCode: addressData['postalCode'],
        state: addressData['state'],
        country: addressData['country'],
      );
    } else if (userType == "BUSINESS") {
      return await registerBusiness(
        email: email,
        password: password,
        nombre: userData['nombre'],
        phone: userData['phone'],
        description: userData['description'],
        website: userData['website'],
        street: addressData['street'],
        city: addressData['city'],
        postalCode: addressData['postalCode'],
        state: addressData['state'],
        country: addressData['country'],
      );
    }
    return false;
  }

  Future<void> registerWithGoogle() async {
    try {
      // Inicializar GoogleSignIn
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // El usuario canceló el inicio de sesión
        return;
      }

      // Obtener autenticación de Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Obtener el idToken
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception("No se pudo obtener el idToken de Google.");
      }

      // Enviar el idToken al backend
      final response = await http.post(
        Uri.parse('https://tu-backend.com/api/auth/register/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['message'] == 'Usuario ya registrado') {
          // Usuario ya registrado, proceder con el flujo normal
          print("Usuario ya registrado: ${data['uid']}");
        } else {
          // Nuevo usuario registrado
          print("Usuario registrado correctamente: ${data['uid']}");
        }
      } else {
        throw Exception("Error al registrar con Google: ${response.body}");
      }
    } catch (e) {
      print("Error en Google Sign-In: $e");
    }
  }

  // ============================
  // Sección: Gestión de usuario
  // ============================

  /// Obtiene los datos del usuario actual según su tipo.
  Future<Map<String, dynamic>> getCurrentUserData() async {
    try {
      if (_userId == null || _userType == null) {
        throw Exception('No hay sesión activa');
      }
      if (_userType == 'BUSINESS') {
        return await _apiService.getBusinessUser(_userId!);
      } else if (_userType == 'CLIENT') {
        final clientData = await _apiService.getClientUser(_userId!);
        // Concatenar nombre y apellidos
        if (clientData.containsKey('nombre') && clientData.containsKey('apellidos')) {
          clientData['nombreCompleto'] = '${clientData['nombre']} ${clientData['apellidos']}';
        }
        return clientData;
      } else {
        throw Exception('Tipo de usuario desconocido');
      }
    } catch (e) {
      throw Exception('Error al obtener los datos del usuario: $e');
    }
  }

  /// Carga los datos del usuario actual y los almacena en [_userData].
  Future<void> _loadUserData() async {
    if (_userId != null && _userType != null) {
      try {
        if (_userType == 'CLIENT') {
          _userData = await _apiService.getClientUser(_userId!);
        } else if (_userType == 'BUSINESS') {
          _userData = await _apiService.getBusinessUser(_userId!);
        }
        notifyListeners();
      } catch (e) {
        _errorMessage = 'Error al cargar datos de usuario: $e';
      }
    }
  }

  /// Actualiza los datos del usuario actual según su tipo.
  Future<String> updateUserData(Map<String, dynamic> userData) async {
    try {
      if (_userId == null || _userType == null) {
        throw Exception('No hay sesión activa');
      }
      if (_userType == 'BUSINESS') {
        return await _apiService.updateBusinessUser(_userId!, userData);
      } else if (_userType == 'CLIENT') {
        return await _apiService.updateClientUser(_userId!, userData);
      } else {
        throw Exception('Tipo de usuario desconocido');
      }
    } catch (e) {
      throw Exception('Error al actualizar los datos del usuario: $e');
    }
  }

  // ============================
  // Sección: Persistencia de datos
  // ============================

  /// Guarda los datos de autenticación y usuario en almacenamiento persistente si "recordarme" está activo.
  Future<void> _saveAuthData() async {
    if (_rememberMe) {
      if (_token != null) await SharedPreferencesService.saveString('token', _token!);
      if (_userId != null) await SharedPreferencesService.saveString('userId', _userId!);
      if (_userType != null) await SharedPreferencesService.saveString('userType', _userType!);
      if (_email != null) await SharedPreferencesService.saveString('email', _email!);
      await SharedPreferencesService.saveBool('rememberMe', _rememberMe);

      if (_userData != null) {
        await SharedPreferencesService.saveMap('userData', _userData!);
      }
    }
  }

  // ============================
  // Sección: Utilidades internas
  // ============================

  /// Cambia el estado de carga y notifica a los listeners.
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }


  Future<void> updateUserDataState(Map<String, dynamic> userData) async {
    _userData = userData;
    notifyListeners();
  }

  Future<String> updateUserWithPhoto(Map<String, dynamic> userData, File? photoFile) async {
    try {
      if (_userId == null || _userType == null) {
        throw Exception('No hay sesión activa');
      }

      String result;
      if (_userType == 'BUSINESS') {
        result = await _apiService.updateBusinessUserWithPhoto(_userId!, userData, photoFile);
      } else if (_userType == 'CLIENT') {
        result = await _apiService.updateClientUserWithPhoto(_userId!, userData, photoFile);
      } else {
        throw Exception('Tipo de usuario desconocido');
      }

      // Actualizar datos locales
      await _loadUserData();

      return result;
    } catch (e) {
      throw Exception('Error al actualizar los datos del usuario: $e');
    }
  }

}
