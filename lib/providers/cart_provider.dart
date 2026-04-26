// providers/cart_provider.dart
// Manages cart state using Provider

import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0, (sum, item) => sum + item.totalPrice);

  double get tax => subtotal * 0.0825;

  double get total => subtotal + tax;

  bool get hasFreeShipping => subtotal >= 200;

  /// Add product to cart or increment quantity if already exists
  void addItem(Product product, String size, String color) {
    final existingIndex = _items.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedSize == size &&
          item.selectedColor == color,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(
        product: product,
        selectedSize: size,
        selectedColor: color,
      ));
    }
    notifyListeners();
  }

  /// Increase quantity of specific cart item
  void increaseQuantity(int index) {
    _items[index].quantity++;
    notifyListeners();
  }

  /// Decrease quantity or remove if quantity reaches 0
  void decreaseQuantity(int index) {
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  /// Remove item completely from cart
  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  /// Clear the entire cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
