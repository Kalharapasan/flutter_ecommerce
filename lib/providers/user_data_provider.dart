import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Address {
  final String id;
  final String label; // Home, Work, etc.
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

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] as String,
      label: json['label'] as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String,
      street: json['street'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zipCode'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

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
  }) {
    return Address(
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

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      orderNumber: json['orderNumber'] as String,
      date: json['date'] as String,
      status: json['status'] as String,
      amount: json['amount'] as String,
      statusColor: json['statusColor'] as String,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
      address: json['address'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
    );
  }

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
}

class UserDataProvider extends ChangeNotifier {
  String _name = 'Pasan Kalhara';
  String _email = 'kalhara@gmail.com';
  String _phone = '';
  List<Address> _addresses = [];
  List<OrderItem> _orders = [];

  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  List<Address> get addresses => _addresses;
  List<OrderItem> get orders => _orders;
  Address? get defaultAddress =>
      _addresses.firstWhere((a) => a.isDefault, orElse: () => _addresses.isEmpty ? Address(id: '', label: '', fullName: '', phone: '', street: '', city: '', state: '', zipCode: '') : _addresses.first);

  UserDataProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _name = prefs.getString('user_name') ?? 'Pasan Kalhara';
      _email = prefs.getString('user_email') ?? 'kalhara@gmail.com';
      _phone = prefs.getString('user_phone') ?? '';

      final addressesJson = prefs.getString('user_addresses');
      if (addressesJson != null) {
        final List<dynamic> decoded = json.decode(addressesJson);
        _addresses = decoded.map((e) => Address.fromJson(e as Map<String, dynamic>)).toList();
      }

      final ordersJson = prefs.getString('user_orders');
      if (ordersJson != null) {
        final List<dynamic> decoded = json.decode(ordersJson);
        _orders = decoded.map((e) => OrderItem.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        // Seed default orders on first run
        _orders = [
          OrderItem(
            orderNumber: '#ORD-001234',
            date: 'Dec 20, 2024',
            status: 'Delivered',
            amount: '\$149.99',
            statusColor: 'success',
            paymentMethod: 'Credit Card',
            address: '123 Main St, Colombo, WP 10000',
            items: [
              {'name': 'Premium Wireless Headphones', 'qty': 1, 'price': '\$149.99'},
            ],
          ),
          OrderItem(
            orderNumber: '#ORD-001233',
            date: 'Dec 15, 2024',
            status: 'Delivered',
            amount: '\$89.99',
            statusColor: 'success',
            paymentMethod: 'PayPal',
            address: '123 Main St, Colombo, WP 10000',
            items: [
              {'name': 'Bluetooth Speaker', 'qty': 1, 'price': '\$89.99'},
            ],
          ),
          OrderItem(
            orderNumber: '#ORD-001232',
            date: 'Dec 10, 2024',
            status: 'In Transit',
            amount: '\$45.99',
            statusColor: 'warning',
            paymentMethod: 'Credit Card',
            address: '456 Office Park, Colombo, WP 10200',
            items: [
              {'name': 'Portable Phone Charger', 'qty': 1, 'price': '\$45.99'},
            ],
          ),
        ];
        await _saveOrders();
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  Future<void> updateProfile({required String name, required String email, required String phone}) async {
    _name = name;
    _email = email;
    _phone = phone;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', name);
      await prefs.setString('user_email', email);
      await prefs.setString('user_phone', phone);
    } catch (e) {
      debugPrint('Error saving profile: $e');
    }
  }

  Future<void> addAddress(Address address) async {
    if (address.isDefault) {
      _addresses = _addresses.map((a) => a.copyWith(isDefault: false)).toList();
    }
    _addresses.add(address);
    notifyListeners();
    await _saveAddresses();
  }

  Future<void> updateAddress(Address address) async {
    final index = _addresses.indexWhere((a) => a.id == address.id);
    if (index == -1) return;
    if (address.isDefault) {
      _addresses = _addresses.map((a) => a.copyWith(isDefault: false)).toList();
    }
    _addresses[index] = address;
    notifyListeners();
    await _saveAddresses();
  }

  Future<void> deleteAddress(String addressId) async {
    _addresses.removeWhere((a) => a.id == addressId);
    notifyListeners();
    await _saveAddresses();
  }

  Future<void> setDefaultAddress(String addressId) async {
    _addresses = _addresses.map((a) => a.copyWith(isDefault: a.id == addressId)).toList();
    notifyListeners();
    await _saveAddresses();
  }

  Future<void> _saveAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = json.encode(_addresses.map((a) => a.toJson()).toList());
      await prefs.setString('user_addresses', encoded);
    } catch (e) {
      debugPrint('Error saving addresses: $e');
    }
  }

  Future<void> _saveOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = json.encode(_orders.map((o) => o.toJson()).toList());
      await prefs.setString('user_orders', encoded);
    } catch (e) {
      debugPrint('Error saving orders: $e');
    }
  }
}
