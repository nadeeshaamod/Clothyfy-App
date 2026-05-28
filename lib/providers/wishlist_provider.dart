// providers/wishlist_provider.dart
// Manages wishlist state using Provider

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class WishlistProvider with ChangeNotifier {
  final List<Product> _items = [];
  String? _userId;

  List<Product> get items => List.unmodifiable(_items);

  bool isWishlisted(String productId) => _items.any((p) => p.id == productId);

  void setUser(String? userId) {
    if (_userId == userId) return;
    _userId = userId;
    if (_userId == null) {
      _items.clear();
      notifyListeners();
    } else {
      _loadRemoteWishlist();
    }
  }

  Future<void> _loadRemoteWishlist() async {
    if (_userId == null) return;
    if (Firebase.apps.isEmpty) return;
    try {
      final doc = await FirebaseFirestore.instance.collection('wishlists').doc(_userId).get();
      if (doc.exists) {
        final data = doc.data();
        final list = (data?['items'] as List<dynamic>?) ?? <dynamic>[];
        _items
          ..clear()
          ..addAll(list.map((m) => Product.fromMap(Map<String, dynamic>.from(m as Map))));
        notifyListeners();
        // also persist locally
        unawaited(_saveLocalWishlist());
      }
    } catch (e) {
      // offline - load local cache
      // ignore: avoid_print
      print('Wishlist load error (remote): $e - loading local cache');
      await _loadLocalWishlist();
    }
  }

  void toggle(Product product) {
    final index = _items.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _items.removeAt(index);
    } else {
      _items.add(product);
    }
    notifyListeners();
    if (_userId != null && Firebase.apps.isNotEmpty) {
      _saveRemoteWishlist();
    }
    unawaited(_saveLocalWishlist());
  }

  Future<void> _saveRemoteWishlist() async {
    if (_userId == null) return;
    try {
      final items = _items.map((p) => p.toMap()).toList();
      await FirebaseFirestore.instance.collection('wishlists').doc(_userId).set({'items': items});
    } catch (e) {
      // ignore: avoid_print
      print('Wishlist save error: $e');
    }
  }

  Future<void> _saveLocalWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'clothyfy_wishlist_${_userId ?? 'guest'}';
      final raw = _items.map((p) => jsonEncode(p.toMap())).toList();
      await prefs.setStringList(key, raw);
    } catch (e) {
      // ignore: avoid_print
      print('Wishlist local save failed: $e');
    }
  }

  Future<void> _loadLocalWishlist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'clothyfy_wishlist_${_userId ?? 'guest'}';
      final raw = prefs.getStringList(key) ?? <String>[];
      _items
        ..clear()
        ..addAll(raw.map((s) => Product.fromMap(Map<String, dynamic>.from(jsonDecode(s) as Map))));
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print('Wishlist local load failed: $e');
    }
  }
}
