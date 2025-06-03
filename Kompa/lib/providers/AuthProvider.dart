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

  final ApiService _apiService;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _token;
  String? _userType;
  String? _email;
  String? _userId;
  Map<String, dynamic>? _userData;
  String? _errorMessage;
  bool _rememberMe = false;
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

      if (!response.containsKey('token') || response['token'] == null) {
        _errorMessage = 'Error: No se recibió un token de autenticación';
        return false;
      }

      _token = response['token'];
      _userId = response['uid'];
      _userType = response['userType'];
      _email = response['email'] ?? email;
      _isAuthenticated = true;

      if (response.containsKey('refreshToken')) {
        await SharedPreferencesService.saveString('refreshToken', response['refreshToken']);
      }

      _apiService.setToken(_token);

      if (_userId != null && _userType != null) {
        await _loadUserData();
      }

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
      final isValid = await validateToken(token);

      if (isValid) {
        _token = token;
        _isAuthenticated = true;

        _userId = await SharedPreferencesService.getString('userId');
        _userType = await SharedPreferencesService.getString('userType');
        _email = await SharedPreferencesService.getString('email');
        _userData = await SharedPreferencesService.getMap('userData');
        _rememberMe = rememberMe;

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

  /// Registra un nuevo cliente
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
    required String city,
    required String state,
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
        'city': city,
        'state': state,
      };

      final response = await _apiService.registerClient(
        email: email,
        password: password,
        userData: userData,
        addressData: addressData,
      );

      if (response.containsKey('success') && response['success'] == true) {
        return await login(email: email, password: password);
      } else if (response.containsKey('laQuedada') &&
          response['laQuedada'].toString().toLowerCase().contains('registrado correctamente')) {
        return await login(email: email, password: password);
      } else {
        _errorMessage = 'Error en el registro: ${response['laQuedada'] ?? 'Desconocido'}';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error al registrar cliente: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Registra un nuevo negocio
  Future<bool> registerBusiness({
    required String email,
    required String password,
    required String nombre,
    required String phone,
    required String description,
    String? website,
    required String city,
    required String state,
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
        'city': city,
        'state': state,
      };

      final response = await _apiService.registerBusiness(
        email: email,
        password: password,
        userData: userData,
        addressData: addressData,
      );

      if (response.containsKey('success') && response['success'] == true) {
        return await login(email: email, password: password);
      } else if (response.containsKey('laQuedada') &&
          response['laQuedada'].toString().toLowerCase().contains('registrado correctamente')) {
        return await login(email: email, password: password);
      } else {
        _errorMessage = 'Error en el registro: ${response['laQuedada'] ?? 'Desconocido'}';
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
        city: addressData['city'],
        state: addressData['state'],
      );
    } else if (userType == "BUSINESS") {
      return await registerBusiness(
        email: email,
        password: password,
        nombre: userData['nombre'],
        phone: userData['phone'],
        description: userData['description'],
        website: userData['website'],
        city: addressData['city'],
        state: addressData['state'],
      );
    }
    return false;
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

      await _loadUserData();

      return result;
    } catch (e) {
      throw Exception('Error al actualizar los datos del usuario: $e');
    }
  }

}
