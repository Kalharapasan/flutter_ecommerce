import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_ecommerce/model/cart_item.dart';
import 'package:flutter_ecommerce/model/product.dart';

class CartProvider extends ChangeNotifier {
  static const _key = 'db_cart';

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.length;
  double get totalPrice => _items.fold(0.0, (s, i) => s + i.subtotal);
  int get totalItems => _items.fold(0, (s, i) => s + i.quantity);


  void addToCart(Product product) {
    final existing = _items.firstWhere(
      (i) => i.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );
    if (existing.quantity > 0) {
      existing.quantity++;
    } else {
      _items.add(CartItem(product: product, quantity: 1));
    }
    _save();
    notifyListeners();
  }

  void removeFromCart(int productId) {
    _items.removeWhere((i) => i.product.id == productId);
    _save();
    notifyListeners();
  }

  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }
    final idx = _items.indexWhere((i) => i.product.id == productId);
    if (idx != -1) {
      _items[idx].quantity = quantity;
      _save();
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _save();
    notifyListeners();
  }

  bool isInCart(int productId) => _items.any((i) => i.product.id == productId);

  int getCartQuantity(int productId) {
    try {
      return _items.firstWhere((i) => i.product.id == productId).quantity;
    } catch (_) {
      return 0;
    }
  }


  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          _key, json.encode(_items.map((i) => i.toJson()).toList()));
    } catch (e) {
      debugPrint('CartProvider _save error: $e');
    }
  }

  Future<void> loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw != null) {
        final List decoded = json.decode(raw) as List;
        _items.clear();
        for (final e in decoded) {
          _items.add(CartItem.fromJson(e as Map<String, dynamic>));
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('CartProvider loadCart error: $e');
    }
  }
}
