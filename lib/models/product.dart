// models/product.dart
// Represents a product in the fashion store

class Product {
  final String id;
  final String name;
  final String brand;
  final String category;
  final double price;
  final String imageUrl;
  final String description;
  final List<String> sizes;
  final List<String> colors;
  final double rating;
  final bool isNew;
  final String? badge;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.sizes,
    required this.colors,
    this.rating = 4.5,
    this.isNew = false,
    this.badge,
  });

  factory Product.fromMap(Map<String, dynamic> map, {String? id}) {
    return Product(
      id: id ?? map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      brand: map['brand']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0,
      imageUrl: map['imageUrl']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      sizes: List<String>.from(map['sizes'] ?? const <String>[]),
      colors: List<String>.from(map['colors'] ?? const <String>[]),
      rating: (map['rating'] as num?)?.toDouble() ?? 4.5,
      isNew: map['isNew'] as bool? ?? false,
      badge: map['badge']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'category': category,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
      'sizes': sizes,
      'colors': colors,
      'rating': rating,
      'isNew': isNew,
      'badge': badge,
    };
  }
}

// Dummy product data for Phase 1 (no Firebase yet)
final List<Product> dummyProducts = [
  const Product(
    id: '1',
    name: 'URBAN SCULPT OVERSIZED HOODIE',
    brand: 'SUSTAINABLE SERIES',
    category: 'Streetwear',
    price: 145.00,
    imageUrl:
        'https://images.unsplash.com/photo-1666443762372-c86511e64151?q=80&w=627&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    description:
        'The Urban Sculpt Hoodie is an exploration of architectural silhouettes in soft-touch French Terry. Designed for the Gen-Z pioneer who demands comfort without sacrificing the high-fashion editorial aesthetic. Every stitch is a statement in intentionality.',
    sizes: ['XS', 'S', 'M', 'L'],
    colors: ['Raw Cream', 'Onyx Black', 'Olive'],
    rating: 4.8,
  ),
  const Product(
    id: '2',
    name: 'UTILITY CARGO VEST',
    brand: 'ARKIV STUDIO',
    category: 'Streetwear',
    price: 185.00,
    imageUrl:
        'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=600&q=80',
    description:
        'A utilitarian vest reimagined for the urban explorer. Multiple pockets, adjustable straps, and premium hardware.',
    sizes: ['S', 'M', 'L', 'XL'],
    colors: ['Olive', 'Black', 'Sand'],
    rating: 4.7,
  ),
  const Product(
    id: '3',
    name: 'CHUNKY SOLE BOOT',
    brand: 'MODERN WALK',
    category: 'Footwear',
    price: 240.00,
    imageUrl:
        'https://media.istockphoto.com/id/1310636407/photo/black-stylish-shoes-on-a-black-and-white-background.jpg?s=612x612&w=0&k=20&c=J2qjj-D-ecYAnTEMkCo9k9vY_ZXk_CFKONl6CrXkp5w=',
    description:
        'Statement boots with chunky platform sole. Snake-embossed leather upper with contrast stitching.',
    sizes: ['36', '37', '38', '39', '40', '41'],
    colors: ['Bronze', 'Black'],
    rating: 4.9,
    badge: 'TRENDING',
  ),
  const Product(
    id: '4',
    name: 'OVERSIZED TEE',
    brand: 'ESSENTIALS LAB',
    category: 'Streetwear',
    price: 45.00,
    imageUrl:
        'https://images.unsplash.com/photo-1775979654476-89575df179bd?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    description:
        'Signature bone white oversized tee. 100% organic cotton, drop-shoulder fit.',
    sizes: ['XS', 'S', 'M', 'L', 'XL'],
    colors: ['Bone White', 'Black', 'Grey'],
    rating: 4.8,
  ),
  const Product(
    id: '5',
    name: 'WIDE LEG DENIM',
    brand: 'STUDIO DENIM',
    category: 'Streetwear',
    price: 89.00,
    imageUrl:
        'https://images.unsplash.com/photo-1768745534123-a491d5d33059?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    description:
        'Vintage wash wide-leg jeans. High-waisted silhouette with a relaxed, street-ready fit.',
    sizes: ['26', '28', '30', '32', '34'],
    colors: ['Vintage Blue', 'Black', 'White'],
    rating: 4.9,
  ),
  const Product(
    id: '6',
    name: 'UTILITY JACKET',
    brand: 'ARKIV STUDIO',
    category: 'Streetwear',
    price: 120.00,
    imageUrl:
        'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=600&q=80',
    description:
        'Matte onyx bomber jacket with utility pockets. Water-resistant shell.',
    sizes: ['S', 'M', 'L', 'XL'],
    colors: ['Matte Onyx', 'Army Green'],
    rating: 4.7,
  ),
  const Product(
    id: '7',
    name: 'CORE HOODIE',
    brand: 'TYPO GRAPHICS',
    category: 'Streetwear',
    price: 65.00,
    imageUrl:
        'https://images.unsplash.com/photo-1576693239181-317efff553bb?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    description: 'Carbon grey core hoodie with signature graphic print.',
    sizes: ['S', 'M', 'L', 'XL', 'XXL'],
    colors: ['Carbon Grey', 'Black'],
    rating: 5.0,
  ),
  const Product(
    id: '8',
    name: 'Midweight Hoodie',
    brand: 'ESSENTIALS LAB',
    category: 'Streetwear',
    price: 110.00,
    imageUrl:
        'https://images.unsplash.com/photo-1586791400644-b04429f7d808?q=80&w=688&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    description: 'Chunky knit boxy hoodie in premium merino blend.',
    sizes: ['XS', 'S', 'M', 'L'],
    colors: ['Cream', 'Oat', 'Black'],
    rating: 4.6,
    isNew: true,
  ),
  const Product(
    id: '9',
    name: 'STANDARD LOGO TEE',
    brand: 'TYPO GRAPHICS',
    category: 'Streetwear',
    price: 65.00,
    imageUrl:
        'https://images.unsplash.com/photo-1648231583528-55d20f68ef7a?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    description:
        'Classic logo tee in heavyweight cotton. The foundation of every wardrobe.',
    sizes: ['XS', 'S', 'M', 'L', 'XL'],
    colors: ['Black', 'White', 'Grey'],
    rating: 4.8,
  ),
  const Product(
    id: '10',
    name: 'CORE PUFFER',
    brand: 'ARKIV STUDIO',
    category: 'Streetwear',
    price: 290.00,
    imageUrl:
        'https://plus.unsplash.com/premium_photo-1708275308999-2c8b177d631f?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDF8fHxlbnwwfHx8fHw%3D',
    description:
        'Oversized puffer jacket in recycled fill. Onyx black with matte finish.',
    sizes: ['S', 'M', 'L', 'XL'],
    colors: ['Onyx Black', 'Forest'],
    rating: 4.9,
    badge: 'BESTSELLER',
  ),
];

// Category list
final List<Map<String, String>> categories = [
  {
    'name': 'Footwear',
    'image':
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
  },
  {
    'name': 'Streetwear',
    'image':
        'https://images.unsplash.com/photo-1503341504253-dff4815485f1?w=300&q=80'
  },
  {
    'name': 'Accessories',
    'image':
        'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=300&q=80'
  },
  {
    'name': 'Outerwear',
    'image':
        'https://images.unsplash.com/photo-1551028719-00167b16eac5?w=300&q=80'
  },
];
