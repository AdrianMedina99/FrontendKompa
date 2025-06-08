import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {
  final String baseUrl;
  String? _token;

  ApiService({required this.baseUrl});

  void setToken(String? token) {
    _token = token;
  }
  // Obtener headers con autenticación
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

  // Actualizar un usuario de negocio con foto
  Future<String> updateBusinessUserWithPhoto(String id, Map<String, dynamic> userData, File? photoFile) async {
    try {
      var request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/api/businessUsers/$id'));

      // Agregar token de autorización
      request.headers.addAll({
        'Authorization': 'Bearer $_token',
      });

      // Convertir userData a formato JSON y agregarlo como parte de la solicitud
      request.files.add(http.MultipartFile.fromString(
        'user',
        jsonEncode(userData),
        contentType: MediaType('application', 'json'),
      ));

      // Si hay una foto para subir, agregarla
      if (photoFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'photo',
          photoFile.path,
        ));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Error al actualizar usuario de negocio: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error en la solicitud: $e');
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

  // Actualizar un usuario cliente con foto
  Future<String> updateClientUserWithPhoto(String id, Map<String, dynamic> userData, File? photoFile) async {
    try {
      var request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/api/clientUsers/$id'));

      // Agregar token de autorización
      request.headers.addAll({
        'Authorization': 'Bearer $_token',
      });

      // Convertir userData a formato JSON y agregarlo como parte de la solicitud
      request.files.add(http.MultipartFile.fromString(
        'user',
        jsonEncode(userData),
        contentType:MediaType('application', 'json'),
      ));

      // Si hay una foto para subir, agregarla
      if (photoFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'photo',
          photoFile.path,
        ));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Error al actualizar usuario cliente: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error en la solicitud: $e');
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


  // Subir una imagen de evento
  Future<String> uploadEventImage(File imageFile) async {
    try {
      final List<int> imageBytes = await imageFile.readAsBytes();

      final String base64Image = base64Encode(imageBytes);

      final String fileName = 'event_${DateTime.now().millisecondsSinceEpoch}.png';

      final Map<String, dynamic> requestBody = {
        'fileName': fileName,
        'fileType': 'png',
        'content': base64Image,
        'name': 'Evento image'
      };

      final response = await http.post(
        Uri.parse('$baseUrl/api/media/upload'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Error al subir imagen: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al procesar la imagen: $e');
    }
  }

  // GESTIÓN DE HILOS

// Crear un nuevo hilo
  Future<Map<String, dynamic>> createHilo(Map<String, dynamic> hiloData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/hilos'),
      headers: _getHeaders(),
      body: jsonEncode(hiloData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al crear hilo: ${response.body}');
    }
  }

// Obtener un hilo por ID
  Future<Map<String, dynamic>> getHilo(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/hilos/$id'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener hilo: ${response.body}');
    }
  }

// Obtener todos los hilos
  Future<List<dynamic>> getAllHilos() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/hilos'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener hilos: ${response.body}');
    }
  }

// Obtener hilos por ID de evento
  Future<List<dynamic>> getHilosByEventId(String eventId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/hilos/event/$eventId'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener hilos del evento: ${response.body}');
    }
  }

// Obtener respuestas a un hilo
  Future<List<dynamic>> getRespuestasHilo(String hiloId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/hilos/$hiloId/respuestas'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener respuestas del hilo: ${response.body}');
    }
  }

// Actualizar un hilo
  Future<Map<String, dynamic>> updateHilo(String id, Map<String, dynamic> hiloData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/hilos/$id'),
      headers: _getHeaders(),
      body: jsonEncode(hiloData),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al actualizar hilo: ${response.body}');
    }
  }

// Eliminar un hilo
  Future<bool> deleteHilo(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/hilos/$id'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Error al eliminar hilo: ${response.body}');
    }
  }

// Crear un hilo como respuesta a otro
  Future<Map<String, dynamic>> crearRespuesta(String hiloParentId, String userId, String content, String eventId) async {
    final hiloData = {
      'userId': userId,
      'content': content,
      'isParent': hiloParentId,
      'eventId': eventId
    };

    return await createHilo(hiloData);
  }


  // GESTIÓN DE VALORACIONES

// Crear una nueva valoración
  Future<String> createValoration(Map<String, dynamic> valorationData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/valorations'),
      headers: _getHeaders(),
      body: jsonEncode(valorationData),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Error al crear la valoración: ${response.body}');
    }
  }

// Obtener una valoración por ID
  Future<Map<String, dynamic>> getValoration(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/valorations/$id'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener la valoración: ${response.body}');
    }
  }

// Obtener todas las valoraciones
  Future<List<dynamic>> getAllValorations() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/valorations'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener las valoraciones: ${response.body}');
    }
  }

// Obtener valoraciones por ID de valorado
  Future<List<dynamic>> getValorationsByValorado(String valoradoId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/valorations/byValorado/$valoradoId'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener las valoraciones: ${response.body}');
    }
  }

// Obtener valoraciones por ID de usuario cliente
  Future<List<dynamic>> getValorationsByClientUser(String clientUserId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/valorations/byClientUser/$clientUserId'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener las valoraciones: ${response.body}');
    }
  }

// Actualizar una valoración
  Future<String> updateValoration(String id, Map<String, dynamic> valorationData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/valorations/$id'),
      headers: _getHeaders(),
      body: jsonEncode(valorationData),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Error al actualizar la valoración: ${response.body}');
    }
  }

// Eliminar una valoración
  Future<String> deleteValoration(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/valorations/$id'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Error al eliminar la valoración: ${response.body}');
    }
  }

  // SERVICIOS DE FOLLOW

  Future<String> followUser(String userId, String followedUserId, String fromCollection, String toCollection) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/follow/follow?userId=$userId&followedUserId=$followedUserId&fromCollection=$fromCollection&toCollection=$toCollection'),
      headers: _getHeaders(),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Error al seguir usuario: ${response.body}');
    }
  }

  Future<String> unfollowUser(String userId, String followedUserId, String fromCollection, String toCollection) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/follow/unfollow?userId=$userId&followedUserId=$followedUserId&fromCollection=$fromCollection&toCollection=$toCollection'),
      headers: _getHeaders(),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Error al dejar de seguir usuario: ${response.body}');
    }
  }

  Future<List<String>> getFollowing(String userId, String collection) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/follow/following/$userId?collection=$collection'),
      headers: _getHeaders(),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data);
    } else {
      throw Exception('Error al obtener seguidos: ${response.body}');
    }
  }

  Future<List<String>> getFollowers(String userId, String collection) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/follow/followers/$userId?collection=$collection'),
      headers: _getHeaders(),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data);
    } else {
      throw Exception('Error al obtener seguidores: ${response.body}');
    }
  }

  // QUEDADAS

// Crear una quedada
  Future<String> crearQuedada(Map<String, dynamic> quedadaData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/quedadas'),
      headers: _getHeaders(),
      body: jsonEncode(quedadaData),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Error al crear quedada: ${response.body}');
    }
  }

// Obtener una quedada por ID
  Future<Map<String, dynamic>?> getQuedada(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/quedadas/$id'),
      headers: _getHeaders(),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Error al obtener quedada: ${response.body}');
    }
  }

// Listar quedadas por creador
  Future<List<dynamic>> getQuedadasPorCreador(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/quedadas/creador/$userId'),
      headers: _getHeaders(),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al listar quedadas: ${response.body}');
    }
  }

  // Listar quedadas donde el usuario es miembro (aceptado o pendiente)
  Future<List<dynamic>> getQuedadasPorMiembro(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/quedadas/miembro/$userId'),
      headers: _getHeaders(),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al listar quedadas como miembro: ${response.body}');
    }
  }

// Aceptar solicitud de quedada
  Future<void> aceptarSolicitudQuedada(String quedadaId, String userId, String solicitanteId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/quedadas/$quedadaId/aceptar?userId=$userId&solicitanteId=$solicitanteId'),
      headers: _getHeaders(),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al aceptar solicitud: ${response.body}');
    }
  }

// Rechazar solicitud de quedada
  Future<void> rechazarSolicitudQuedada(String quedadaId, String userId, String solicitanteId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/quedadas/$quedadaId/rechazar?userId=$userId&solicitanteId=$solicitanteId'),
      headers: _getHeaders(),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al rechazar solicitud: ${response.body}');
    }
  }

// Obtener solicitudes pendientes de una quedada
  Future<List<dynamic>> getSolicitudesPendientesPorQuedada(String quedadaId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/solicitudes_quedada?quedadaId=$quedadaId&estado=pendiente'),
      headers: _getHeaders(),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener solicitudes pendientes: ${response.body}');
    }
  }



// SOLICITUDES DE QUEDADA

// Solicitar unirse a una quedada
  Future<String> solicitarUnirseAQuedada(String quedadaId, String usuarioId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/solicitudes_quedada?quedadaId=$quedadaId&usuarioId=$usuarioId'),
      headers: _getHeaders(),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Error al solicitar unirse: ${response.body}');
    }
  }

// Actualizar estado de solicitud (aceptado, rechazado, etc)
  Future<void> actualizarEstadoSolicitud(String solicitudId, String estado) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/solicitudes_quedada/$solicitudId?estado=$estado'),
      headers: _getHeaders(),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar estado de solicitud: ${response.body}');
    }
  }

// CHAT DE QUEDADA

// Enviar mensaje al chat de una quedada
  Future<void> enviarMensajeChatQuedada(String quedadaId, Map<String, dynamic> mensajeData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/quedadas/$quedadaId/chat'),
      headers: _getHeaders(),
      body: jsonEncode(mensajeData),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al enviar mensaje: ${response.body}');
    }
  }

  // Obtener mensajes del chat de una quedada
  Future<List<dynamic>> getMensajesChatQuedada(String quedadaId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/quedadas/$quedadaId/chat'),
      headers: _getHeaders(),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener mensajes del chat: ${response.body}');
    }
  }

  // Listar miembros aceptados de una quedada
  Future<List<String>> getMiembrosAceptados(String quedadaId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/quedadas/$quedadaId/miembros-aceptados'),
      headers: _getHeaders(),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data);
    } else {
      throw Exception('Error al obtener miembros aceptados: ${response.body}');
    }
  }

  // Eliminar un miembro aceptado de una quedada
  Future<void> eliminarMiembroAceptado(String quedadaId, String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/quedadas/$quedadaId/eliminar-miembro?userId=$userId'),
      headers: _getHeaders(),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar miembro aceptado: ${response.body}');
    }
  }

// Eliminar una quedada
  Future<void> eliminarQuedada(String quedadaId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/quedadas/$quedadaId'),
      headers: _getHeaders(),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar quedada: ${response.body}');
    }
  }

  // Servicio para resetear quedadas pasadas
  Future<void> resetQuedadasPasadas() async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/quedadas/reset'),
      headers: _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al resetear quedadas pasadas: ${response.body}');
    }
  }

  Future<void> actualizarHoraYLugar(String quedadaId, DateTime? horaEncuentro, double? latitud, double? longitud) async {
    final timestamp = horaEncuentro?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch;

    final queryParams = {
      'horaEncuentro': timestamp.toString(),
      'latitud': (latitud ?? 0.0).toString(),
      'longitud': (longitud ?? 0.0).toString(),
    };

    final uri = Uri.parse('$baseUrl/api/quedadas/$quedadaId/actualizar-hora-lugar')
        .replace(queryParameters: queryParams);

    final response = await http.put(
      uri,
      headers: _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar hora y lugar: ${response.body}');
    }
  }

  // REPORTES

  Future<String> createReport(Map<String, dynamic> reportData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/reports'),
      headers: _getHeaders(),
      body: jsonEncode(reportData),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Error al crear el reporte: ${response.body}');
    }
  }

}

