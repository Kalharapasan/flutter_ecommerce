import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_ecommerce/data/mock_data.dart';
import 'package:flutter_ecommerce/model/product.dart';


class ProductProvider extends ChangeNotifier {
  static const _key = 'db_products';

  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => List.unmodifiable(_products);
  bool get isLoading => _isLoading;

  List<String> get categories {
    final cats = _products.map((p) => p.category).toSet().toList()..sort();
    return ['All', ...cats];
  }

  ProductProvider() {
    _load();
  }


  Future<void> _load() async {
    _isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw != null) {
        // Existing data in storage – use it
        final List decoded = json.decode(raw) as List;
        _products =
            decoded.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        // First launch – seed from mock_data.dart and persist
        _products = List<Product>.from(mockProducts);
        await _save();
      }
    } catch (e) {
      debugPrint('ProductProvider _load error: $e');
      _products = List<Product>.from(mockProducts);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          _key, json.encode(_products.map((p) => p.toJson()).toList()));
    } catch (e) {
      debugPrint('ProductProvider _save error: $e');
    }
  }


  Future<void> addProduct(Product product) async {
    _products.add(product);
    notifyListeners();
    await _save();
  }


  Future<void> updateProduct(Product updated) async {
    final idx = _products.indexWhere((p) => p.id == updated.id);
    if (idx == -1) return;
    _products[idx] = updated;
    notifyListeners();
    await _save();
  }


  Future<void> deleteProduct(int id) async {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
    await _save();
  }


  List<Product> search(String query, {String category = 'All'}) {
    final q = query.toLowerCase();
    return _products.where((p) {
      final matchCat = category == 'All' || p.category == category;
      final matchQ = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q);
      return matchCat && matchQ;
    }).toList();
  }

  Product? getById(int id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  int nextId() {
    if (_products.isEmpty) return 1;
    return _products.map((p) => p.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  /// Resets catalogue back to the original mock_data seed.
  Future<void> resetToDefaults() async {
    _products = List<Product>.from(mockProducts);
    notifyListeners();
    await _save();
  }
}
