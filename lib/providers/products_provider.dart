// providers/products_provider.dart
// Loads products from Firestore and keeps the catalog in sync.

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../models/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _products = dummyProducts;
  bool _isLoading = false;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _productsSubscription;
  String? _lastError;

  List<Product> get products => List.unmodifiable(_products);
  bool get isLoading => _isLoading;
  String? get lastError => _lastError;

  Future<void> loadProducts() async {
    await _productsSubscription?.cancel();
    _productsSubscription = null;
    _isLoading = true;
    notifyListeners();

    if (Firebase.apps.isEmpty) {
      _products = dummyProducts;
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      await _seedProductsIfNeeded();
      _productsSubscription = FirebaseFirestore.instance
          .collection('products')
          .orderBy('name')
          .snapshots()
          .listen(
            (snapshot) {
              if (snapshot.docs.isEmpty) {
                _products = dummyProducts;
              } else {
                _products = snapshot.docs
                    .map((doc) => Product.fromMap(doc.data(), id: doc.id))
                    .toList();
              }
              _isLoading = false;
              _lastError = null;
              notifyListeners();
            },
            onError: (Object error) {
              _lastError = error.toString();
              _products = dummyProducts;
              _isLoading = false;
              notifyListeners();
            },
          );
    } catch (error) {
      _lastError = error.toString();
      _products = dummyProducts;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _seedProductsIfNeeded() async {
    final collection = FirebaseFirestore.instance.collection('products');
    final existing = await collection.limit(1).get();
    if (existing.docs.isNotEmpty) {
      return;
    }

    final batch = FirebaseFirestore.instance.batch();
    for (final product in dummyProducts) {
      batch.set(collection.doc(product.id), product.toMap());
    }
    await batch.commit();
  }

  Product? byId(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Product> byCategory(String category) {
    if (category == 'All') {
      return _products;
    }

    final filtered = _products.where((p) => p.category == category).toList();
    return filtered.isEmpty ? _products : filtered;
  }

  List<Product> get featuredProducts =>
      _products.length <= 8 ? _products : _products.sublist(0, 8);

  @override
  void dispose() {
    _productsSubscription?.cancel();
    super.dispose();
  }
}