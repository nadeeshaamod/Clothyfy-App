// providers/orders_provider.dart
// Stores order history in Firestore and keeps the active user's orders synced.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

class OrdersProvider with ChangeNotifier {
  final List<AppOrder> _orders = [];
  bool _isLoading = false;
  String? _lastError;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _ordersSubscription;

  List<AppOrder> get orders => List.unmodifiable(_orders);
  bool get isLoading => _isLoading;
  String? get lastError => _lastError;

  Future<void> loadOrdersForUser(String userId) async {
    await _ordersSubscription?.cancel();
    _ordersSubscription = null;
    _isLoading = true;
    notifyListeners();

    if (Firebase.apps.isEmpty) {
      _orders.clear();
      _lastError = 'Firebase is not initialized.';
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      _ordersSubscription = FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .listen(
            (snapshot) {
              _orders
                ..clear()
                ..addAll(
                  snapshot.docs
                      .map((doc) => AppOrder.fromMap(doc.data(), id: doc.id))
                      .toList()
                    ..sort((left, right) => right.createdAt.compareTo(left.createdAt)),
                );
              _isLoading = false;
              _lastError = null;
              notifyListeners();
            },
            onError: (Object error) {
              _lastError = error.toString();
              _orders.clear();
              _isLoading = false;
              notifyListeners();
            },
          );
    } catch (error) {
      _lastError = error.toString();
      _orders.clear();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> placeOrder({
    required AppUser user,
    required List<CartItem> cartItems,
    required String paymentMethod,
    required String address,
    required String city,
    required String zip,
    required double subtotal,
    required double shipping,
    required double tax,
    required double total,
  }) async {
    _lastError = null;
    if (Firebase.apps.isEmpty) {
      _lastError = 'Firebase is not initialized.';
      notifyListeners();
      return false;
    }

    final order = AppOrder.fromCart(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      userId: user.uid,
      customerName: user.name,
      email: user.email,
      address: address,
      city: city,
      zip: zip,
      paymentMethod: paymentMethod,
      cartItems: cartItems,
      subtotal: subtotal,
      shipping: shipping,
      tax: tax,
      total: total,
      createdAt: DateTime.now(),
    );

    try {
      final doc = await FirebaseFirestore.instance
          .collection('orders')
          .add(order.toMap());
      _orders.insert(0, order.copyWith(id: doc.id));
      notifyListeners();
      return true;
    } catch (error) {
      _lastError = error.toString();
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _ordersSubscription?.cancel();
    super.dispose();
  }
}

extension AppOrderCopy on AppOrder {
  AppOrder copyWith({String? id}) {
    return AppOrder(
      id: id ?? this.id,
      userId: userId,
      customerName: customerName,
      email: email,
      address: address,
      city: city,
      zip: zip,
      paymentMethod: paymentMethod,
      items: items,
      subtotal: subtotal,
      shipping: shipping,
      tax: tax,
      total: total,
      createdAt: createdAt,
      status: status,
    );
  }
}