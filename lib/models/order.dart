// models/order.dart
// Represents an order stored in Firestore or local persistence

import 'cart_item.dart';

class OrderItem {
  final String productId;
  final String name;
  final String imageUrl;
  final String selectedSize;
  final String selectedColor;
  final int quantity;
  final double price;

  const OrderItem({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.selectedSize,
    required this.selectedColor,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromCartItem(CartItem item) {
    return OrderItem(
      productId: item.product.id,
      name: item.product.name,
      imageUrl: item.product.imageUrl,
      selectedSize: item.selectedSize,
      selectedColor: item.selectedColor,
      quantity: item.quantity,
      price: item.product.price,
    );
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      imageUrl: map['imageUrl']?.toString() ?? '',
      selectedSize: map['selectedSize']?.toString() ?? '',
      selectedColor: map['selectedColor']?.toString() ?? '',
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      price: (map['price'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'imageUrl': imageUrl,
      'selectedSize': selectedSize,
      'selectedColor': selectedColor,
      'quantity': quantity,
      'price': price,
    };
  }
}

class AppOrder {
  final String id;
  final String userId;
  final String customerName;
  final String email;
  final String address;
  final String city;
  final String zip;
  final String paymentMethod;
  final List<OrderItem> items;
  final double subtotal;
  final double shipping;
  final double tax;
  final double total;
  final DateTime createdAt;
  final String status;

  const AppOrder({
    required this.id,
    required this.userId,
    required this.customerName,
    required this.email,
    required this.address,
    required this.city,
    required this.zip,
    required this.paymentMethod,
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.total,
    required this.createdAt,
    required this.status,
  });

  factory AppOrder.fromMap(Map<String, dynamic> map, {String? id}) {
    return AppOrder(
      id: id ?? map['id']?.toString() ?? '',
      userId: map['userId']?.toString() ?? '',
      customerName: map['customerName']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      address: map['address']?.toString() ?? '',
      city: map['city']?.toString() ?? '',
      zip: map['zip']?.toString() ?? '',
      paymentMethod: map['paymentMethod']?.toString() ?? '',
      items: (map['items'] as List<dynamic>? ?? const [])
          .map((item) => OrderItem.fromMap(Map<String, dynamic>.from(item)))
          .toList(),
      subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0,
      shipping: (map['shipping'] as num?)?.toDouble() ?? 0,
      tax: (map['tax'] as num?)?.toDouble() ?? 0,
      total: (map['total'] as num?)?.toDouble() ?? 0,
      createdAt: DateTime.tryParse(map['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      status: map['status']?.toString() ?? 'Processing',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'customerName': customerName,
      'email': email,
      'address': address,
      'city': city,
      'zip': zip,
      'paymentMethod': paymentMethod,
      'items': items.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'shipping': shipping,
      'tax': tax,
      'total': total,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }

  factory AppOrder.fromCart({
    required String id,
    required String userId,
    required String customerName,
    required String email,
    required String address,
    required String city,
    required String zip,
    required String paymentMethod,
    required List<CartItem> cartItems,
    required double subtotal,
    required double shipping,
    required double tax,
    required double total,
    required DateTime createdAt,
  }) {
    return AppOrder(
      id: id,
      userId: userId,
      customerName: customerName,
      email: email,
      address: address,
      city: city,
      zip: zip,
      paymentMethod: paymentMethod,
      items: cartItems.map(OrderItem.fromCartItem).toList(),
      subtotal: subtotal,
      shipping: shipping,
      tax: tax,
      total: total,
      createdAt: createdAt,
      status: 'Processing',
    );
  }
}