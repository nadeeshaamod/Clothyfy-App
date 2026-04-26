// main.dart
// Entry point of the CLOTHYFY fashion store application

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';
import 'utils/app_theme.dart';
import 'views/screens/login_screen.dart';

void main() {
  runApp(const ClothyfyApp());
}

class ClothyfyApp extends StatelessWidget {
  const ClothyfyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Cart state management
        ChangeNotifierProvider(create: (_) => CartProvider()),
        // Wishlist state management
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
      ],
      child: MaterialApp(
        title: 'CLOTHYFY',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        // Start at Login screen
        home: const LoginScreen(),
      ),
    );
  }
}
