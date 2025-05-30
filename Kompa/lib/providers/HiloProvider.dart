import 'package:flutter/foundation.dart';
import '../service/apiService.dart';

class HiloProvider with ChangeNotifier {
  final ApiService _apiService;
  bool _isLoading = false;
  String? _error;
  List<dynamic> _hilos = [];
  String? _currentEventId;
  String? _userId;

  HiloProvider(this._apiService);

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<dynamic> get hilos => _hilos;
  String? get currentEventId => _currentEventId;

  void setUserId(String userId) {
    _userId = userId;
  }

  // En Kompa/lib/providers/HiloProvider.dart

  Future<void> loadHilos(String eventId) async {
    print("📋 DEBUG loadHilos: Cargando hilos para evento $eventId");
    _isLoading = true;
    _error = null;
    _currentEventId = eventId;
    notifyListeners();

    try {
      final hilosData = await _apiService.getHilosByEventId(eventId);
      if (hilosData.isNotEmpty) {
        print("DEBUG: Primer hilo recibido: ${hilosData[0]}");
      }

      for (var hilo in hilosData) {
        print("📋 DEBUG loadHilos: Procesando hilo ${hilo['id']}, userId: ${hilo['userId']}");
        await _enrichWithUserData(hilo);
        if (hilo['isParent'] == null) {
          await _loadRespuestasRecursivas(hilo);
        }
      }

      _hilos = hilosData;
      
      // Verificar si hay datos para debugging
      if (_hilos.isNotEmpty) {
        print("📋 DEBUG loadHilos: Primer hilo después de procesar:");
        print("📋 DEBUG - ID: ${_hilos[0]['id']}");
        print("📋 DEBUG - Content: ${_hilos[0]['content']}");
        print("📋 DEBUG - Nombre: ${_hilos[0]['nombre'] ?? 'NO EXISTE NOMBRE'}");
        print("📋 DEBUG - Photo: ${_hilos[0]['photo'] ?? 'NO EXISTE PHOTO'}");
        
        if (_hilos[0]['respuestas'] != null && _hilos[0]['respuestas'].isNotEmpty) {
          print("📋 DEBUG - Primera respuesta:");
          print("📋 DEBUG -- Nombre: ${_hilos[0]['respuestas'][0]['nombre'] ?? 'NO EXISTE NOMBRE'}");
          print("📋 DEBUG -- Photo: ${_hilos[0]['respuestas'][0]['photo'] ?? 'NO EXISTE PHOTO'}");
        }
      }
      
    } catch (e) {
      print("❌ ERROR loadHilos: $e");
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // En HiloProvider.dart
  Map<String, dynamic> _enrichWithUserData(Map<String, dynamic> item) {
    // Si el campo 'user' existe, extrae los datos de ahí
    if (item.containsKey('user') && item['user'] != null) {
      final user = item['user'];
      item['nombre'] = user['nombre'] ?? 'Usuario';
      item['photo'] = user['photo'] ?? '';
      item['userType'] = user['userType'];
      item['userId'] = user['userId'];
    } else {
      // Si no existe, puedes dejar los valores por defecto o intentar obtenerlos de otra forma
      item['nombre'] = 'Usuario';
      item['photo'] = '';
    }
    return item;
  }

  // Modifica también _loadRespuestasRecursivas para enriquecer cada respuesta
  Future<void> _loadRespuestasRecursivas(Map<String, dynamic> hilo) async {
    print("🔄 DEBUG _loadRespuestasRecursivas: Cargando respuestas para hilo ${hilo['id']}");
    final respuestas = await _apiService.getRespuestasHilo(hilo['id']);
    print("🔄 DEBUG _loadRespuestasRecursivas: ${respuestas.length} respuestas encontradas");
    
    for (var respuesta in respuestas) {
      print("🔄 DEBUG _loadRespuestasRecursivas: Procesando respuesta ${respuesta['id']}, userId: ${respuesta['userId']}");
      await _enrichWithUserData(respuesta);
      await _loadRespuestasRecursivas(respuesta);
    }
    
    hilo['respuestas'] = respuestas;
    
    if (respuestas.isNotEmpty) {
      print("🔄 DEBUG _loadRespuestasRecursivas: Primera respuesta después de procesar:");
      print("🔄 DEBUG - nombre: ${respuestas[0]['nombre'] ?? 'NO EXISTE NOMBRE'}");
      print("🔄 DEBUG - photo: ${respuestas[0]['photo'] ?? 'NO EXISTE PHOTO'}");
    }
  }

  // Crear un nuevo hilo principal
  Future<bool> createHilo(String content) async {
    if (_currentEventId == null || _userId == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final hiloData = {
        'userId': _userId,
        'content': content,
        'eventId': _currentEventId,
      };

      await _apiService.createHilo(hiloData);
      await loadHilos(_currentEventId!);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Crear una respuesta a un hilo
  Future<bool> createRespuesta(String content, String hiloParentId) async {
    if (_currentEventId == null || _userId == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.crearRespuesta(hiloParentId, _userId!, content, _currentEventId!);
      await loadHilos(_currentEventId!);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Eliminar un hilo
  Future<bool> deleteHilo(String hiloId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.deleteHilo(hiloId);
      if (_currentEventId != null) {
        await loadHilos(_currentEventId!);
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Limpiar errores
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
