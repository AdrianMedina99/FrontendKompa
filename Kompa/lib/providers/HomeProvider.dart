import 'package:flutter/material.dart';
import '../service/apiService.dart';
import 'dart:convert';

class HomeProvider with ChangeNotifier {
  final ApiService apiService;
  List<Map<String, dynamic>> _nearbyEvents = [];
  List<Map<String, dynamic>> _trendingEvents = [];
  bool _isLoading = false;

  HomeProvider({required this.apiService});

  List<Map<String, dynamic>> get nearbyEvents => _nearbyEvents;
  List<Map<String, dynamic>> get trendingEvents => _trendingEvents;
  bool get isLoading => _isLoading;

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

  Future<void> fetchTrendingEvents(double lat, double lng) async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await apiService.getEventsNearby(lat, lng, maxResults: 10);
      _trendingEvents = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      _trendingEvents = [];
    }
    _isLoading = false;
    notifyListeners();
  }
}