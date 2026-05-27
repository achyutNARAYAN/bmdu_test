import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LocalStorageService _storage = LocalStorageService();

  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  List<Product> _recentProducts = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Product> get products => _filteredProducts;
  List<Product> get recentProducts => _recentProducts;
  String get searchQuery => _searchQuery;
  bool get hasResults => _filteredProducts.isNotEmpty;

  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _apiService.fetchProducts();
      _filteredProducts = List.of(_products);
      await _loadRecentViews();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshProducts() async {
    await loadProducts();
  }

  void searchProducts(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredProducts = List.of(_products);
    } else {
      _filteredProducts = _products.where((product) {
        final normalized = query.toLowerCase();
        return product.title.toLowerCase().contains(normalized) ||
            product.category.toLowerCase().contains(normalized);
      }).toList();
    }
    notifyListeners();
  }

  Future<void> markProductViewed(Product product) async {
    _recentProducts.removeWhere((item) => item.id == product.id);
    _recentProducts.insert(0, product);
    if (_recentProducts.length > 5) {
      _recentProducts = _recentProducts.sublist(0, 5);
    }
    await _storage.saveRecentProductIds(_recentProducts.map((product) => product.id).toList());
    notifyListeners();
  }

  Future<void> _loadRecentViews() async {
    final ids = await _storage.getRecentProductIds();
    final recent = <Product>[];
    for (final id in ids) {
      final match = _products.firstWhere(
        (product) => product.id == id,
        orElse: () => Product(
          id: id,
          title: 'Unknown',
          price: 0,
          description: '',
          category: '',
          image: '',
          rating: Rating(rate: 0, count: 0),
        ),
      );
      if (match.image.isNotEmpty) {
        recent.add(match);
      }
    }
    _recentProducts = recent;
  }
}
