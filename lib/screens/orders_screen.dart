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
    var scaffold = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.error != null) {
              Future.delayed(Duration.zero)
                  .then((value) => scaffold.showSnackBar(
                        const SnackBar(
                          content: Text("An error occurred!"),
                        ),
                      ));
              return const Center(child: Text("An error occurred!"));
            } else {
              return Consumer<Orders>(
                builder: (ctx, orders, _) => orders.count == 0
                    ? const Center(
                        child: Text("There is no orders yet! Make some"))
                    : ListView.builder(
                        itemBuilder: (ctx, index) {
                          return OrderItem(order: orders.orders[index]);
                        },
                        itemCount: orders.count),
              );
            }
          }
        },
      ),
      drawer: const MainDrawer(),
    );
  }
}
