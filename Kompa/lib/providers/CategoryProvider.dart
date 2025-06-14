import 'package:flutter/material.dart';
import '../service/apiService.dart';

class CategoryProvider with ChangeNotifier {

  // ============================
  // Variables privadas y getters
  // ============================

  final ApiService apiService;
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = false;
  CategoryProvider({required this.apiService});
  List<Map<String, dynamic>> get categories => _categories;
  bool get isLoading => _isLoading;

  /// Metodo para listar las categorías
  Future<void> fetchCategories() async {
    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    try {
      final data = await apiService.getAllCategories();
      _categories = List<Map<String, dynamic>>.from(data.map((category) => {
        'id': category['id'],
        'svgContent': category['svgContent'],
        'title': category['title'],
      }));
    } catch (e) {
      _categories = [];
    }
    _isLoading = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
