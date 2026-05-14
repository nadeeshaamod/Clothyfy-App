// views/screens/payment_methods_screen.dart
// Payment methods screen

import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../widgets/reusable_widgets.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ClothyfyAppBar(showBack: true, title: 'PAYMENTS'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const _PaymentTile(
              title: 'Apple Pay',
              subtitle: 'Default payment method',
              icon: Icons.apple,
            ),
            const SizedBox(height: 12),
            const _PaymentTile(
              title: 'Visa •••• 4242',
              subtitle: 'Expires 08/28',
              icon: Icons.credit_card,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Card setup flow will be connected in Firebase phase 2'),
                      backgroundColor: AppColors.dark,
                    ),
                  );
                },
                child: const Text('ADD PAYMENT METHOD'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _PaymentTile({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.dark),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.dark,
                    )),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: AppColors.grey)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.grey),
        ],
      ),
    );
  }
}
