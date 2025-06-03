import 'package:flutter/foundation.dart';
import '../service/apiService.dart';

class HiloProvider with ChangeNotifier {

  // ============================
  // Variables privadas y getters
  // ============================

  final ApiService _apiService;
  bool _isLoading = false;
  String? _error;
  List<dynamic> _hilos = [];
  String? _currentEventId;
  String? _userId;
  HiloProvider(this._apiService);

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<dynamic> get hilos => _hilos;
  String? get currentEventId => _currentEventId;


  ///Metodo para establecer el userId
  void setUserId(String userId) {
    _userId = userId;
  }

  ///Metodo para campos del hilo
  Future<void> loadHilos(String eventId) async {
    _isLoading = true;
    _error = null;
    _currentEventId = eventId;
    notifyListeners();

    try {
      final hilosData = await _apiService.getHilosByEventId(eventId);

      for (var hilo in hilosData) {
        await _enrichWithUserData(hilo);
        if (hilo['isParent'] == null) {
          await _loadRespuestasRecursivas(hilo);
        }
      }
      _hilos = hilosData;

    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Metodo para enriquecer los datos del hilo con información del usuario
  Map<String, dynamic> _enrichWithUserData(Map<String, dynamic> item) {
    if (item.containsKey('user') && item['user'] != null) {
      final user = item['user'];
      item['nombre'] = user['nombre'] ?? 'Usuario';
      item['photo'] = user['photo'] ?? '';
      item['userType'] = user['userType'];
      item['userId'] = user['userId'];
    } else {
      item['nombre'] = 'Usuario';
      item['photo'] = '';
    }
    return item;
  }

  /// Cargar respuestas de forma recursiva para un hilo
  Future<void> _loadRespuestasRecursivas(Map<String, dynamic> hilo) async {
    final respuestas = await _apiService.getRespuestasHilo(hilo['id']);

    for (var respuesta in respuestas) {
      await _enrichWithUserData(respuesta);
      await _loadRespuestasRecursivas(respuesta);
    }
    hilo['respuestas'] = respuestas;

  }

  /// Metodo para Crear un nuevo hilo principal
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

  /// Metodo para Crear una respuesta a un hilo
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

  ///Metodo para Eliminar un hilo
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

  ///Metodo para Limpiar errores
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
