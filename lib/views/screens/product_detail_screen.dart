// views/screens/product_detail_screen.dart
// Product detail screen matching the CLOTHYFY design

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../providers/products_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../utils/app_theme.dart';
import '../widgets/reusable_widgets.dart';
import 'cart_screen.dart';
import 'wishlist_screen.dart';
import 'profile_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? _selectedSize;
  int _selectedColorIndex = 0;
  bool _addedToCart = false;

  final List<Color> _colorSwatches = [
    const Color(0xFFF5F2ED),
    const Color(0xFF1A1A1A),
    const Color(0xFF4A6741),
  ];

  void _addToCart() {
    if (_selectedSize == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a size'),
          backgroundColor: AppColors.dark,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    context.read<CartProvider>().addItem(
          widget.product,
          _selectedSize!,
          widget.product.colors[_selectedColorIndex],
        );

    setState(() => _addedToCart = true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} added to bag'),
        backgroundColor: AppColors.dark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        action: SnackBarAction(
          label: 'VIEW BAG',
          textColor: Colors.white,
          onPressed: () => Navigator.push(
              context, FadeSlideTransition(page: const CartScreen())),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _addedToCart = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final catalog = context.watch<ProductsProvider>().products;
    final wishlist = context.watch<WishlistProvider>();
    final isWishlisted = wishlist.isWishlisted(product.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8)
              ],
            ),
            child: const Icon(Icons.arrow_back_ios_new,
                size: 16, color: AppColors.dark),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: WishlistButton(
              isWishlisted: isWishlisted,
              onTap: () => wishlist.toggle(product),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image
            Stack(
              children: [
                Image.network(
                  product.imageUrl,
                  height: 420,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 420,
                    color: AppColors.lightGrey,
                    child: const Icon(Icons.image_outlined,
                        size: 60, color: AppColors.grey),
                  ),
                ),
                // Page dots indicator
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (i) => Container(
                        width: i == 0 ? 20 : 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: i == 0
                              ? AppColors.dark
                              : Colors.grey.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand + Wishlist
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.brand,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.grey,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Name
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.dark,
                      letterSpacing: -0.5,
                      height: 1.1,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Price
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.dark,
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Divider(color: AppColors.lightGrey),
                  const SizedBox(height: 20),

                  // Color selector
                  Row(
                    children: [
                      const Text(
                        'COLOR — ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          color: AppColors.dark,
                        ),
                      ),
                      Text(
                        product.colors[_selectedColorIndex].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.grey,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(
                      _colorSwatches.length,
                      (i) => GestureDetector(
                        onTap: () => setState(() => _selectedColorIndex = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 34,
                          height: 34,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: _colorSwatches[i],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedColorIndex == i
                                  ? AppColors.dark
                                  : Colors.grey.withValues(alpha: 0.3),
                              width: _selectedColorIndex == i ? 2.5 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Size selector
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'SELECT SIZE',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          color: AppColors.dark,
                        ),
                      ),
                      Text(
                        'SIZE GUIDE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          color: AppColors.grey,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: product.sizes.map((size) {
                      final isSelected = _selectedSize == size;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedSize = size),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 52,
                          height: 42,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.dark
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.dark
                                  : AppColors.lightGrey,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              size,
                              style: TextStyle(
                                color:
                                    isSelected ? Colors.white : AppColors.dark,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Add to bag button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: ElevatedButton(
                        onPressed: _addToCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _addedToCart ? AppColors.success : AppColors.dark,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _addedToCart ? 'ADDED ✓' : 'ADD TO BAG',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                            if (!_addedToCart) ...[
                              const SizedBox(width: 10),
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.add,
                                    color: Colors.white, size: 14),
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_shipping_outlined,
                            size: 14, color: AppColors.grey),
                        SizedBox(width: 6),
                        Text(
                          'Free shipping on all orders over \$200',
                          style: TextStyle(fontSize: 12, color: AppColors.grey),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Divider(color: AppColors.lightGrey),
                  const SizedBox(height: 20),

                  // Description
                  const Text(
                    'THE NARRATIVE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                      height: 1.7,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Expandable sections
                  const _ExpandableRow(label: 'SPECIFICATIONS'),
                  const Divider(color: AppColors.lightGrey),
                  const _ExpandableRow(label: 'CARE INSTRUCTIONS'),
                  const Divider(color: AppColors.lightGrey),

                  const SizedBox(height: 24),

                  // Complete the vibe
                  const Text(
                    'COMPLETE THE\nVIBE',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.dark,
                      letterSpacing: -0.5,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Related products
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: catalog.length > 1 ? 3 : 0,
                      itemBuilder: (context, i) {
                        final relatedCandidates = catalog
                            .where((item) => item.id != product.id)
                            .toList();
                        final related = relatedCandidates[
                            i % relatedCandidates.length];
                        return GestureDetector(
                          onTap: () => Navigator.pushReplacement(
                            context,
                            FadeSlideTransition(
                                page: ProductDetailScreen(product: related)),
                          ),
                          child: Container(
                            width: 140,
                            margin: const EdgeInsets.only(right: 12),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    related.imageUrl,
                                    height: 160,
                                    width: 140,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      height: 160,
                                      color: AppColors.lightGrey,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 24,
                                  left: 10,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.9),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          related.brand,
                                          style: const TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.dark,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '\$${related.price.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (related.isNew)
                                  const Positioned(
                                    top: 8,
                                    right: 8,
                                    child: BadgeLabel(
                                        text: 'NEW',
                                        bg: Colors.white,
                                        textColor: AppColors.dark),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ClothyfyBottomNav(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (index == 2) {
            Navigator.pop(context);
            Navigator.push(
                context, FadeSlideTransition(page: const WishlistScreen()));
          } else if (index == 3) {
            Navigator.pop(context);
            Navigator.push(
                context, FadeSlideTransition(page: const ProfileScreen()));
          }
        },
      ),
    );
  }
}

class _ExpandableRow extends StatelessWidget {
  final String label;
  const _ExpandableRow({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: AppColors.dark,
            ),
          ),
          const Icon(Icons.keyboard_arrow_down,
              color: AppColors.grey, size: 20),
        ],
      ),
    );
  }
}
