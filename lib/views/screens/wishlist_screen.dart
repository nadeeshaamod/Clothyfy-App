// views/screens/wishlist_screen.dart
// Wishlist screen showing saved products

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../utils/app_theme.dart';
import '../widgets/reusable_widgets.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      appBar: const ClothyfyAppBar(showBack: true),
      body: wishlist.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_outline,
                      size: 64, color: AppColors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No saved items yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Tap the heart icon to save pieces',
                      style: TextStyle(color: AppColors.grey)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('BROWSE NOW'),
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Wishlist',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.dark,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        '${wishlist.items.length} saved item${wishlist.items.length > 1 ? 's' : ''}',
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.grey),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.58,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: wishlist.items.length,
                    itemBuilder: (context, index) {
                      final product = wishlist.items[index];
                      return ProductCard(
                        product: product,
                        onTap: () => Navigator.push(
                          context,
                          FadeSlideTransition(
                              page: ProductDetailScreen(product: product)),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
