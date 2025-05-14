// lib/providers/auth_provider.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kompa/service/apiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/SharedPreferencesService.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _token;
  String? _userType; // "client" o "business"
  String? _email;
  String? _userId;
  Map<String, dynamic>? _userData;
  String? _errorMessage;
  bool _rememberMe = false; // Variable para "recordar contraseña"

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get token => _token;
  String? get userType => _userType;
  String? get email => _email;
  String? get userId => _userId;
  Map<String, dynamic>? get userData => _userData;
  String? get errorMessage => _errorMessage;
  bool get rememberMe => _rememberMe;

  // Constructor
  AuthProvider({required String apiBaseUrl}) : _apiService = ApiService(baseUrl: apiBaseUrl);

  // Cargar datos del usuario actual
  Future<void> _loadUserData() async {
    if (_userId != null && _userType != null) {
      try {
        if (_userType == 'client') {
          _userData = await _apiService.getClientUser(_userId!);
        } else if (_userType == 'business') {
          _userData = await _apiService.getBusinessUser(_userId!);
        }
      } catch (e) {
        _errorMessage = 'Error al cargar datos de usuario: $e';
      }
    }
  }

  // Guardar datos de autenticación solo si rememberMe está activo
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

  // Iniciar sesión manual
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

      // Usar directamente el JWT token del backend
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

  // Registrar cliente
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
      // Preparar datos de usuario
      final userData = {
        'nombre': nombre,
        'apellidos': apellidos,
        'dni': dni,
        'phone': phone,
        'birthDate': birthDate.millisecondsSinceEpoch,
        'description': description ?? '',
        'gender': gender,
        'role': 'client'
      };

      // Preparar datos de dirección
      final addressData = {
        'street': street,
        'city': city,
        'postalCode': postalCode,
        'state': state,
        'country': country,
      };

      // Llamar al servicio API para registrar cliente
      final response = await _apiService.registerClient(
        email: email,
        password: password,
        userData: userData,
        addressData: addressData,
      );

      // Si el registro es exitoso, iniciar sesión automáticamente
      if (response.containsKey('success') && response['success'] == true) {
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

  // Registrar negocio
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
      // Preparar datos de usuario
      final userData = {
        'nombre': nombre,
        'phone': phone,
        'description': description,
        'website': website ?? '',
        'role': 'business'
      };

      // Preparar datos de dirección
      final addressData = {
        'street': street,
        'city': city,
        'postalCode': postalCode,
        'state': state,
        'country': country,
      };

      // Llamar al servicio API para registrar negocio
      final response = await _apiService.registerBusiness(
        email: email,
        password: password,
        userData: userData,
        addressData: addressData,
      );

      // Si el registro es exitoso, iniciar sesión automáticamente
      if (response.containsKey('success') && response['success'] == true) {
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

  // Cerrar sesión
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

  // Manejar estado de carga
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Método para configurar "recordarme"
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

  // Obtener datos del usuario actual según su tipo
  Future<Map<String, dynamic>> getCurrentUserData() async {
    try {
      if (_userId == null || _userType == null) {
        throw Exception('No hay sesión activa');
      }
      if (_userType == 'business') {
        return await _apiService.getBusinessUser(_userId!);
      } else if (_userType == 'client') {
        return await _apiService.getClientUser(_userId!);
      } else {
        throw Exception('Tipo de usuario desconocido');
      }
    } catch (e) {
      throw Exception('Error al obtener los datos del usuario: $e');
    }
  }

  // Actualizar datos del usuario según su tipo
  Future<String> updateUserData(Map<String, dynamic> userData) async {
    try {
      if (_userId == null || _userType == null) {
        throw Exception('No hay sesión activa');
      }
      if (_userType == 'business') {
        return await _apiService.updateBusinessUser(_userId!, userData);
      } else if (_userType == 'client') {
        return await _apiService.updateClientUser(_userId!, userData);
      } else {
        throw Exception('Tipo de usuario desconocido');
      }
    } catch (e) {
      throw Exception('Error al actualizar los datos del usuario: $e');
    }
  }

  // Intentar autologin al iniciar la app
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

  Future<bool> validateToken(String token) async {
    try {
      final response = await _apiService.validateToken(token);
      return response['valid'] == true || response.containsKey('uid');
    } catch (_) {
      return false;
    }
  }
}
