import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/order.dart';
import '../providers/order_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/app_bar_widget.dart';
import 'order_tracking_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: const AppBarWidget(title: 'My Orders'),
      body: Consumer2<OrderProvider, UserProvider>(
        builder: (context, orderProvider, userProvider, _) {
          final userId = userProvider.currentUser?.id;
          final orders = userId == null
              ? []
              : orderProvider.orders.where((o) => o.userId == userId).toList();
          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.list_alt, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text('No orders yet', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final Order o = orders[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                title: Text(o.orderNumber),
                subtitle: Text('${o.items.length} items • ${o.getStatusLabel()}'),
                trailing: Text('₹${o.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => OrderTrackingScreen(order: o)));
                },
              );
            },
          );
        },
      ),
    );
  }
}
