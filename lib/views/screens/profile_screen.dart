// views/screens/profile_screen.dart
// User profile screen

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../utils/app_theme.dart';
import '../widgets/reusable_widgets.dart';
import 'login_screen.dart';
import 'product_listing_screen.dart';
import 'order_history_screen.dart';
import 'payment_methods_screen.dart';
import 'settings_screen.dart';
import 'wishlist_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      appBar: const ClothyfyAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  // Avatar with person icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3F4F5F),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.name ?? 'Nadeesha Amod',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.dark,
                    ),
                  ),
                  if (user?.email != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      user!.email,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () async {
                        final auth = context.read<AuthProvider>();
                        final nameController = TextEditingController(
                          text: user?.name ?? 'Nadeesha Amod',
                        );
                        final emailController = TextEditingController(
                          text: user?.email ?? '',
                        );
                        final phoneController = TextEditingController(
                          text: user?.phone ?? '',
                        );
                        final addressController = TextEditingController(
                          text: user?.address ?? '',
                        );
                        final cityController = TextEditingController(
                          text: user?.city ?? '',
                        );
                        final zipController = TextEditingController(
                          text: user?.zip ?? '',
                        );

                        final saved = await showDialog<bool>(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            title: const Text('Edit Profile'),
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: nameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Name',
                                    ),
                                  ),
                                  TextField(
                                    controller: emailController,
                                    decoration: const InputDecoration(
                                      labelText: 'Email',
                                    ),
                                  ),
                                  TextField(
                                    controller: phoneController,
                                    decoration: const InputDecoration(
                                      labelText: 'Phone',
                                    ),
                                  ),
                                  TextField(
                                    controller: addressController,
                                    decoration: const InputDecoration(
                                      labelText: 'Address',
                                    ),
                                  ),
                                  TextField(
                                    controller: cityController,
                                    decoration: const InputDecoration(
                                      labelText: 'City',
                                    ),
                                  ),
                                  TextField(
                                    controller: zipController,
                                    decoration: const InputDecoration(
                                      labelText: 'ZIP',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext, false),
                                child: const Text('CANCEL'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(dialogContext, true),
                                child: const Text('SAVE'),
                              ),
                            ],
                          ),
                        );

                        if (saved == true) {
                          await auth.updateProfile(
                                name: nameController.text,
                                email: emailController.text,
                                phone: phoneController.text,
                                address: addressController.text,
                                city: cityController.text,
                                zip: zipController.text,
                              );
                        }

                        nameController.dispose();
                        emailController.dispose();
                        phoneController.dispose();
                        addressController.dispose();
                        cityController.dispose();
                        zipController.dispose();
                      },
                      style: OutlinedButton.styleFrom(
                        side:
                            const BorderSide(color: AppColors.dark, width: 1.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                      ),
                      child: const Text(
                        'EDIT PROFILE',
                        style: TextStyle(
                          color: AppColors.dark,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Menu items
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _MenuItem(
                    icon: Icons.shopping_bag_outlined,
                    label: 'My Orders',
                    onTap: () => Navigator.push(
                      context,
                      FadeSlideTransition(page: const OrderHistoryScreen()),
                    ),
                  ),
                  _Divider(),
                  Builder(builder: (context) {
                    final wishlist = context.watch<WishlistProvider>();
                    final count = wishlist.items.length;
                    return _MenuItem(
                      icon: Icons.favorite_outline,
                      label: 'Saved Items',
                      badge: count > 0 ? count.toString() : null,
                      onTap: () => Navigator.push(
                        context,
                        FadeSlideTransition(page: const WishlistScreen()),
                      ),
                    );
                  }),
                  _Divider(),
                  _MenuItem(
                    icon: Icons.credit_card_outlined,
                    label: 'Payment Methods',
                    onTap: () => Navigator.push(
                      context,
                      FadeSlideTransition(page: const PaymentMethodsScreen()),
                    ),
                  ),
                  _Divider(),
                  _MenuItem(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    onTap: () => Navigator.push(
                      context,
                      FadeSlideTransition(page: const SettingsScreen()),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Logout button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                  onPressed: () async {
                    await context.read<AuthProvider>().signOut();
                    if (!context.mounted) {
                      return;
                    }
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.dark, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: AppColors.dark, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'LOGOUT',
                      style: TextStyle(
                        color: AppColors.dark,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: ClothyfyBottomNav(
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (index == 1) {
            Navigator.pop(context);
            Navigator.push(
                context,
                FadeSlideTransition(
                    page: const ProductListingScreen(category: 'All')));
          } else if (index == 2) {
            Navigator.pop(context);
            Navigator.push(
                context, FadeSlideTransition(page: const WishlistScreen()));
          }
        },
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? badge;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 24, color: AppColors.dark),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.dark,
                ),
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFD32F2F),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            const SizedBox(width: 12),
            const Icon(Icons.chevron_right, size: 18, color: AppColors.grey),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(
        height: 1, indent: 56, endIndent: 20, color: Color(0xFFF0EDE8));
  }
}
