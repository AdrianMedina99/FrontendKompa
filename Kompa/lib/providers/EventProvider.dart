import 'package:flutter/material.dart';
import '../service/apiService.dart';

class EventProvider with ChangeNotifier {
  final ApiService apiService;

  EventProvider({required this.apiService});

  Map<String, dynamic>? _eventData;
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get eventData => _eventData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Carga los datos de un evento por su ID y los guarda en eventData.
  Future<void> loadEventById(String eventId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final data = await apiService.getEventById(eventId);
      _eventData = data;
    } catch (e) {
      _error = e.toString();
      _eventData = null;
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Crea un nuevo evento usando los datos proporcionados.
  Future<Map<String, dynamic>> createEvent(Map<String, dynamic> eventData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await apiService.createEvent(eventData);
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Actualiza un evento existente por su ID con los datos proporcionados.
  Future<Map<String, dynamic>> updateEvent(String eventId, Map<String, dynamic> eventData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await apiService.updateEvent(eventId, eventData);
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Limpia los datos cargados del evento.
  void clearEventData() {
    _eventData = null;
    _error = null;
    notifyListeners();
  }
}
