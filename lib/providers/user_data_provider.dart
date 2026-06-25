import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_ecommerce/data/mock_data.dart';


class Address {
  final String id;
  final String label;
  final String fullName;
  final String phone;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final bool isDefault;

  Address({
    required this.id,
    required this.label,
    required this.fullName,
    required this.phone,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    this.isDefault = false,
  });

  factory Address.fromJson(Map<String, dynamic> j) => Address(
        id: j['id'] as String,
        label: j['label'] as String,
        fullName: j['fullName'] as String,
        phone: j['phone'] as String,
        street: j['street'] as String,
        city: j['city'] as String,
        state: j['state'] as String,
        zipCode: j['zipCode'] as String,
        isDefault: j['isDefault'] == true || j['isDefault'] == 1,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'fullName': fullName,
        'phone': phone,
        'street': street,
        'city': city,
        'state': state,
        'zipCode': zipCode,
        'isDefault': isDefault,
      };

  Address copyWith({
    String? id,
    String? label,
    String? fullName,
    String? phone,
    String? street,
    String? city,
    String? state,
    String? zipCode,
    bool? isDefault,
  }) =>
      Address(
        id: id ?? this.id,
        label: label ?? this.label,
        fullName: fullName ?? this.fullName,
        phone: phone ?? this.phone,
        street: street ?? this.street,
        city: city ?? this.city,
        state: state ?? this.state,
        zipCode: zipCode ?? this.zipCode,
        isDefault: isDefault ?? this.isDefault,
      );
}

class OrderItem {
  final String orderNumber;
  final String date;
  final String status;
  final String amount;
  final String statusColor;
  final List<Map<String, dynamic>> items;
  final String? address;
  final String? paymentMethod;

  OrderItem({
    required this.orderNumber,
    required this.date,
    required this.status,
    required this.amount,
    required this.statusColor,
    this.items = const [],
    this.address,
    this.paymentMethod,
  });

  factory OrderItem.fromJson(Map<String, dynamic> j) => OrderItem(
        orderNumber: j['orderNumber'] as String,
        date: j['date'] as String,
        status: j['status'] as String,
        amount: j['amount'] as String,
        statusColor: j['statusColor'] as String,
        items: (j['items'] as List<dynamic>?)
                ?.map((e) => Map<String, dynamic>.from(e as Map))
                .toList() ??
            [],
        address: j['address'] as String?,
        paymentMethod: j['paymentMethod'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'orderNumber': orderNumber,
        'date': date,
        'status': status,
        'amount': amount,
        'statusColor': statusColor,
        'items': items,
        'address': address,
        'paymentMethod': paymentMethod,
      };

  OrderItem copyWith({String? status, String? statusColor}) => OrderItem(
        orderNumber: orderNumber,
        date: date,
        status: status ?? this.status,
        amount: amount,
        statusColor: statusColor ?? this.statusColor,
        items: items,
        address: address,
        paymentMethod: paymentMethod,
      );
}


class UserDataProvider extends ChangeNotifier {
  static const _keyProfile   = 'db_user_profile';
  static const _keyAddresses = 'db_addresses';
  static const _keyOrders    = 'db_orders';

  String _name  = '';
  String _email = '';
  String _phone = '';
  List<Address>   _addresses = [];
  List<OrderItem> _orders    = [];

  String get name  => _name;
  String get email => _email;
  String get phone => _phone;
  List<Address>   get addresses => List.unmodifiable(_addresses);
  List<OrderItem> get orders    => List.unmodifiable(_orders);

  Address? get defaultAddress {
    if (_addresses.isEmpty) return null;
    try {
      return _addresses.firstWhere((a) => a.isDefault);
    } catch (_) {
      return _addresses.first;
    }
  }

  UserDataProvider() {
    _load();
  }


  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();


      final profileRaw = prefs.getString(_keyProfile);
      if (profileRaw != null) {
        final m = json.decode(profileRaw) as Map<String, dynamic>;
        _name  = m['name']  as String? ?? '';
        _email = m['email'] as String? ?? '';
        _phone = m['phone'] as String? ?? '';
      } else {
        // Seed from mock_data.dart
        _name  = mockUserProfile['name']  as String;
        _email = mockUserProfile['email'] as String;
        _phone = mockUserProfile['phone'] as String? ?? '';
        await _saveProfile();
      }


      final addrRaw = prefs.getString(_keyAddresses);
      if (addrRaw != null) {
        final list = json.decode(addrRaw) as List;
        _addresses = list
            .map((e) => Address.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        // Seed from mock_data.dart
        _addresses = mockAddresses
            .map((e) => Address.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        await _saveAddresses();
      }

      final ordersRaw = prefs.getString(_keyOrders);
      if (ordersRaw != null) {
        final list = json.decode(ordersRaw) as List;
        _orders = list
            .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        // Seed from mock_data.dart
        _orders = mockOrders
            .map((e) => OrderItem.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        await _saveOrders();
      }

      notifyListeners();
    } catch (e) {
      debugPrint('UserDataProvider _load error: $e');
    }
  }

  Future<void> _saveProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          _keyProfile,
          json.encode({'name': _name, 'email': _email, 'phone': _phone}));
    } catch (e) {
      debugPrint('_saveProfile error: $e');
    }
  }

  Future<void> _saveAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          _keyAddresses,
          json.encode(_addresses.map((a) => a.toJson()).toList()));
    } catch (e) {
      debugPrint('_saveAddresses error: $e');
    }
  }

  Future<void> _saveOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          _keyOrders,
          json.encode(_orders.map((o) => o.toJson()).toList()));
    } catch (e) {
      debugPrint('_saveOrders error: $e');
    }
  }

  
  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    _name  = name;
    _email = email;
    _phone = phone;
    notifyListeners();
    await _saveProfile();
  }

  Future<void> addAddress(Address address) async {
    if (address.isDefault) {
      _addresses =
          _addresses.map((a) => a.copyWith(isDefault: false)).toList();
    }
    _addresses.add(address);
    notifyListeners();
    await _saveAddresses();
  }

  Future<void> updateAddress(Address address) async {
    final idx = _addresses.indexWhere((a) => a.id == address.id);
    if (idx == -1) return;
    if (address.isDefault) {
      _addresses =
          _addresses.map((a) => a.copyWith(isDefault: false)).toList();
    }
    _addresses[idx] = address;
    notifyListeners();
    await _saveAddresses();
  }

  Future<void> deleteAddress(String addressId) async {
    _addresses.removeWhere((a) => a.id == addressId);
    notifyListeners();
    await _saveAddresses();
  }

  Future<void> setDefaultAddress(String addressId) async {
    _addresses = _addresses
        .map((a) => a.copyWith(isDefault: a.id == addressId))
        .toList();
    notifyListeners();
    await _saveAddresses();
  }


  Future<void> addOrder(OrderItem order) async {
    _orders.insert(0, order);
    notifyListeners();
    await _saveOrders();
  }

  Future<void> updateOrderStatus(
      String orderNumber, String status, String statusColor) async {
    final idx = _orders.indexWhere((o) => o.orderNumber == orderNumber);
    if (idx != -1) {
      _orders[idx] =
          _orders[idx].copyWith(status: status, statusColor: statusColor);
      notifyListeners();
    }
    await _saveOrders();
  }
}
