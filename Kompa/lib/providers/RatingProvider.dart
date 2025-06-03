import 'package:flutter/material.dart';
import '../service/apiService.dart';

class RatingProvider extends ChangeNotifier {

  // ============================
  // Variables privadas y getters
  // ============================

  final ApiService _apiService;
  double _averageRating = 0.0;
  bool _isLoading = false;
  RatingProvider(this._apiService);
  double get averageRating => _averageRating;
  bool get isLoading => _isLoading;

  ///Metodo para cargar la valoración media de un usuario
  Future<void> loadUserRating(String? userId) async {
    if (userId == null) {
      _averageRating = 0.0;
      notifyListeners();
      return;
    }
    _isLoading = true;
    notifyListeners();

    try {
      final reviews = await _apiService.getValorationsByValorado(userId);

      if (reviews.isEmpty) {
        _averageRating = 0.0;
        _isLoading = false;
        notifyListeners();
        return;
      }

      double total = 0;
      int count = 0;

      for (var review in reviews) {
        if (review['rating'] != null) {
          total += (review['rating'] as num).toDouble();
          count++;
        }
      }
      _averageRating = count > 0 ? (total / count) : 0.0;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _averageRating = 0.0;
      _isLoading = false;
      notifyListeners();
    }
  }
}