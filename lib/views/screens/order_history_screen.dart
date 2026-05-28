// views/screens/order_history_screen.dart
// Order history screen showing previous purchases

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/orders_provider.dart';
import '../../utils/app_theme.dart';
import '../widgets/reusable_widgets.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final auth = context.read<AuthProvider>();
    final user = auth.currentUser;
    if (user != null) {
      context.read<OrdersProvider>().loadOrdersForUser(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrdersProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ClothyfyAppBar(showBack: true, title: 'ORDERS'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: orders.isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.dark))
            : orders.orders.isEmpty
                ? const Center(
                    child: Text(
                      'No orders yet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey,
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: orders.orders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final order = orders.orders[index];
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Order ${order.id.substring(order.id.length > 6 ? order.id.length - 6 : 0)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.dark,
                                  ),
                                ),
                                Text(
                                  '\$${order.total.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.dark,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${order.items.length} item${order.items.length > 1 ? 's' : ''} • ${order.paymentMethod}',
                              style: const TextStyle(color: AppColors.grey),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              order.address,
                              style: const TextStyle(color: AppColors.grey),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              order.createdAt.toLocal().toString().substring(0, 16),
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
