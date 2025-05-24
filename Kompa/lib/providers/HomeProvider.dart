import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../service/apiService.dart';
import 'dart:convert';

import 'AuthProvider.dart';

class HomeProvider with ChangeNotifier {
  // Variables
  final ApiService apiService;
  AuthProvider? _authProvider;

  List<Map<String, dynamic>> _nearbyEvents = [];
  List<Map<String, dynamic>> _trendingEvents = [];
  bool _isLoading = false;
  String? _currentCategoryId;
  Position? _lastKnownPosition;
  Map<String, List<Map<String, dynamic>>> _categoryCache = {};
  bool _allEventsLoaded = false;

  String? get currentCategoryId => _currentCategoryId;
  List<Map<String, dynamic>> get nearbyEvents => _nearbyEvents;
  List<Map<String, dynamic>> get trendingEvents => _trendingEvents;
  bool get isLoading => _isLoading;
  Position? get lastKnownPosition => _lastKnownPosition;

  HomeProvider({required this.apiService});

  ///Establecer la referencia al AuthProvider
  void setAuthProvider(AuthProvider authProvider) {
    _authProvider = authProvider;
  }

  ///Verificar tipo de usuario
  bool get isBusinessUser => _authProvider?.userType == 'BUSINESS';
  String? get currentUserId => _authProvider?.userId;

  /// Obtiene eventos cercanos basados en latitud y longitud.
  Future<void> fetchNearbyEvents(double lat, double lng) async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await apiService.getEventsNearby(lat, lng, maxResults: 2);
      _nearbyEvents = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      _nearbyEvents = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Obtiene eventos basados en latitud, longitud y opcionalmente una categoría.
  Future<void> fetchEvents
      (double lat, double lng, {String? categoryId, int maxResults = 10}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await apiService.getEventsNearby(lat, lng, maxResults: maxResults, categoryId: categoryId);
      _trendingEvents = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      _trendingEvents = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Obtiene la posición actual del usuario.
  Future<Position> getCurrentPosition() async {
    if (_lastKnownPosition != null) {
      return _lastKnownPosition!;
    }
    _lastKnownPosition = await Geolocator.getCurrentPosition();
    return _lastKnownPosition!;
  }

  /// Obtiene eventos populares basados en latitud y longitud.
  Future<void> fetchTrendingEvents(double lat, double lng, {int maxResults = 10}) async {
    return fetchEvents(lat, lng, maxResults: maxResults);
  }

  /// Obtiene eventos por categoría y los almacena en caché.
  Future<void> fetchEventsByCategory(double lat, double lng, String categoryId, {int maxResults = 10}) async {
    if (_categoryCache.containsKey(categoryId)) {
      _trendingEvents = _categoryCache[categoryId]!;
      notifyListeners();

      Future.delayed(const Duration(minutes: 5), () {
        _updateCategoryInBackground(lat, lng, categoryId, maxResults);
      });
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final data = await apiService.getEventsNearby(lat, lng, maxResults: maxResults, categoryId: categoryId);
      _trendingEvents = List<Map<String, dynamic>>.from(data);
      _categoryCache[categoryId] = _trendingEvents;
    } catch (e) {
      _trendingEvents = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Actualiza los datos de una categoría en segundo plano.
  void _updateCategoryInBackground(double lat, double lng, String categoryId, int maxResults) async {
    try {
      final data = await apiService.getEventsNearby(lat, lng, maxResults: maxResults, categoryId: categoryId);
      final newData = List<Map<String, dynamic>>.from(data);

      if (newData.length != _categoryCache[categoryId]!.length) {
        _categoryCache[categoryId] = newData;
        if (_currentCategoryId == categoryId) {
          _trendingEvents = newData;
          notifyListeners();
        }
      }
    } catch (e) {}
  }

  /// Obtiene todos los eventos y los almacena en caché.
  Future<void> fetchAllEvents(double lat, double lng) async {
    if (_nearbyEvents.length <= 1 || _trendingEvents.length <= 1) {
      _allEventsLoaded = false;
    }

    if (_allEventsLoaded && _nearbyEvents.isNotEmpty && _trendingEvents.isNotEmpty) {
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      if (isBusinessUser && currentUserId != null) {
        final businessEvents = await apiService.getEventsByBusinessId(currentUserId!);
        _nearbyEvents = List<Map<String, dynamic>>.from(businessEvents);
        _trendingEvents = _nearbyEvents;
      } else {
        final nearbyFuture = apiService.getEventsNearby(lat, lng, maxResults: 10);
        final trendingFuture = apiService.getEventsNearby(lat, lng, maxResults: 10);

        final results = await Future.wait([nearbyFuture, trendingFuture]);
        _nearbyEvents = List<Map<String, dynamic>>.from(results[0]);
        _trendingEvents = List<Map<String, dynamic>>.from(results[1]);
      }
      _allEventsLoaded = true;
    } catch (e) {
      _nearbyEvents = [];
      _trendingEvents = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Fuerza la actualización de todos los eventos.
  void refreshAllEvents() {
    _allEventsLoaded = false;
  }
}
