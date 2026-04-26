// views/widgets/product_card.dart
// Product card used in grids and lists

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/wishlist_provider.dart';
import '../../utils/app_theme.dart';
import 'reusable_widgets.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image container
          SizedBox(
            height: 170,
            width: double.infinity,
            child: Stack(
              children: [
                // Product image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    product.imageUrl,
                    width: double.infinity,
                    height: 170,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: AppColors.lightGrey,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.dark,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.lightGrey,
                      child: const Icon(Icons.image_outlined,
                          size: 40, color: AppColors.grey),
                    ),
                  ),
                ),
                // Wishlist button
                Positioned(
                  top: 10,
                  right: 10,
                  child: Consumer<WishlistProvider>(
                    builder: (context, wishlist, _) => WishlistButton(
                      isWishlisted: wishlist.isWishlisted(product.id),
                      onTap: () => wishlist.toggle(product),
                    ),
                  ),
                ),
                // Badge
                if (product.badge != null)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: BadgeLabel(text: product.badge!),
                  ),
                if (product.isNew)
                  const Positioned(
                    top: 10,
                    left: 10,
                    child: BadgeLabel(
                        text: 'NEW',
                        bg: Colors.white,
                        textColor: AppColors.dark),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Product info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.dark,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.colors.first,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.dark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Star rating
          Row(
            children: [
              const Icon(Icons.star_rounded, size: 13, color: Colors.amber),
              const SizedBox(width: 3),
              Text(
                product.rating.toString(),
                style: const TextStyle(fontSize: 11, color: AppColors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
