import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  String? _token;

  // Constructor con la URL base de la API
  ApiService({required this.baseUrl});

  // Establecer token para solicitudes autenticadas
  // En ApiService.dart
  void setToken(String? token) {
    _token = token;
  }
  // Método para obtener headers con autenticación
  Map<String, String> _getHeaders({bool needsAuth = true}) {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (needsAuth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return headers;
  }

  // AUTENTICACIÓN

  // Registro de usuario cliente
  Future<Map<String, dynamic>> registerClient({
    required String email,
    required String password,
    required Map<String, dynamic> userData,
    required Map<String, dynamic> addressData,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/register/client'),
      headers: _getHeaders(needsAuth: false),
      body: jsonEncode({
        'auth': {
          'email': email,
          'password': password
        },
        'user': userData,
        'address': addressData
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al registrar usuario: ${response.body}');
    }
  }

  // Registro de usuario negocio
  Future<Map<String, dynamic>> registerBusiness({
    required String email,
    required String password,
    required Map<String, dynamic> userData,
    required Map<String, dynamic> addressData,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/register/business'),
      headers: _getHeaders(needsAuth: false),
      body: jsonEncode({
        'auth': {
          'email': email,
          'password': password
        },
        'user': userData,
        'address': addressData
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al registrar negocio: ${response.body}');
    }
  }

  // Iniciar sesión
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: _getHeaders(needsAuth: false),
      body: jsonEncode({
        'email': email,
        'password': password,
        'rememberMe': rememberMe
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Guardamos el token automáticamente
      if (data.containsKey('token')) {
        setToken(data['token']);
      }
      return data;
    } else {
      throw Exception('Error al iniciar sesión: ${response.body}');
    }
  }

  // Validar token
  Future<Map<String, dynamic>> validateToken(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/auth/validate-token'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al validar token: ${response.body}');
    }
  }

  // GESTIÓN DE USUARIOS DE NEGOCIO

  // Obtener un usuario de negocio por ID
  Future<Map<String, dynamic>> getBusinessUser(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/businessUsers/$id'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener usuario de negocio: ${response.body}');
    }
  }

  // Obtener todos los usuarios de negocio
  Future<List<dynamic>> getAllBusinessUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/businessUsers'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener usuarios de negocio: ${response.body}');
    }
  }

  // Actualizar un usuario de negocio
  Future<String> updateBusinessUser(String id, Map<String, dynamic> userData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/businessUsers/$id'),
      headers: _getHeaders(),
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Error al actualizar usuario de negocio: ${response.body}');
    }
  }

  // Eliminar un usuario de negocio
  Future<String> deleteBusinessUser(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/businessUsers/$id'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Error al eliminar usuario de negocio: ${response.body}');
    }
  }

  // GESTIÓN DE USUARIOS CLIENTE

  // Obtener un usuario cliente por ID
  Future<Map<String, dynamic>> getClientUser(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/clientUsers/$id'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Datos del cliente obtenidos: $data");
      return data;
    } else {
      throw Exception('Error al obtener usuario cliente: ${response.body}');
    }
  }

  // Obtener todos los usuarios cliente
  Future<List<dynamic>> getAllClientUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/clientUsers'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener usuarios cliente: ${response.body}');
    }
  }

  // Actualizar un usuario cliente
  Future<String> updateClientUser(String id, Map<String, dynamic> userData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/clientUsers/$id'),
      headers: _getHeaders(),
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Error al actualizar usuario cliente: ${response.body}');
    }
  }

  // Eliminar un usuario cliente
  Future<String> deleteClientUser(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/clientUsers/$id'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Error al eliminar usuario cliente: ${response.body}');
    }
  }

  // Dentro de ApiService

// Obtener todas las categorías
  Future<List<dynamic>> getAllCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/categories'),
      headers: _getHeaders(),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener categorías: ${response.body}');
    }
  }

// Obtener una categoría por ID
  Future<Map<String, dynamic>> getCategoryById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/categories/$id'),
      headers: _getHeaders(),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener la categoría: ${response.body}');
    }
  }

// Crear una categoría
  Future<Map<String, dynamic>> createCategory(Map<String, dynamic> categoryData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/categories'),
      headers: _getHeaders(),
      body: jsonEncode(categoryData),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al crear la categoría: ${response.body}');
    }
  }

// Actualizar una categoría
  Future<Map<String, dynamic>> updateCategory(String id, Map<String, dynamic> categoryData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/categories/$id'),
      headers: _getHeaders(),
      body: jsonEncode(categoryData),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al actualizar la categoría: ${response.body}');
    }
  }

// Eliminar una categoría
  Future<void> deleteCategory(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/categories/$id'),
      headers: _getHeaders(),
    );
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar la categoría: ${response.body}');
    }
  }

  // Dentro de ApiService
// Gestión de eventos

// Obtener todos los eventos
  Future<List<dynamic>> getAllEvents() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/events'),
      headers: _getHeaders(),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener eventos: ${response.body}');
    }
  }

// Obtener un evento por ID
  Future<Map<String, dynamic>> getEventById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/events/$id'),
      headers: _getHeaders(),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener el evento: ${response.body}');
    }
  }

// Crear un evento
  Future<Map<String, dynamic>> createEvent(Map<String, dynamic> eventData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/events'),
      headers: _getHeaders(),
      body: jsonEncode(eventData),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al crear el evento: ${response.body}');
    }
  }

// Actualizar un evento
  Future<Map<String, dynamic>> updateEvent(String id, Map<String, dynamic> eventData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/events/$id'),
      headers: _getHeaders(),
      body: jsonEncode(eventData),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al actualizar el evento: ${response.body}');
    }
  }

// Eliminar un evento
  Future<void> deleteEvent(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/events/$id'),
      headers: _getHeaders(),
    );
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar el evento: ${response.body}');
    }
  }

// Obtener eventos cercanos a una ubicación
  Future<List<dynamic>> getEventsNearby(double lat, double lng, {int maxResults = 10, String? categoryId}) async {
    String url = '$baseUrl/api/events/nearby?lat=$lat&lng=$lng&maxResults=$maxResults';

    if (categoryId != null) {
      url += '&categoryId=$categoryId';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: _getHeaders(),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener eventos cercanos: ${response.body}');
    }
  }

//Obtener eventos por userID
  Future<List<dynamic>> getEventsByBusinessId(String businessId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/events/by-business?businessId=$businessId'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener eventos del negocio: ${response.body}');
    }
  }

}