import 'package:flutter/material.dart';

import '../providers/orders.dart' as ord;

import 'package:intl/intl.dart';

class OrderItem extends StatelessWidget {
  const OrderItem({super.key, required this.order});

  final ord.OrderItem order;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            ListTile(
              title: Text('\$ ${order.amount}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(order.dateTime),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.expand_more),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
