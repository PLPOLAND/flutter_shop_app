import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/main_drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: orders.count == 0
          ? Center(child: Text("There is no orders yet! Make some"))
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return OrderItem(order: orders.orders[index]);
              },
              itemCount: orders.count),
      drawer: MainDrawer(),
    );
  }
}
