import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/cart.dart';
import 'package:flutter_shop_app/providers/orders.dart';
import 'package:provider/provider.dart';

import '../widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _addingOrder = false;
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Center(
          child: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text('\$ ${cart.totalAmount.toStringAsFixed(2)}'),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                    onPressed: cart.items.isEmpty
                        ? null
                        : () async {
                            setState(() {
                              _addingOrder = true;
                            });
                            await Provider.of<Orders>(context, listen: false)
                                .addOrder(cart.items.values.toList(),
                                    cart.totalAmount);
                            cart.clear();
                            setState(() {
                              _addingOrder = false;
                            });
                          },
                    child: Text('ORDER NOW'),
                  ),
                  if (_addingOrder)
                    CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.secondary,
                    )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemBuilder: (ctx, index) {
                  return CartItemWidget(
                      item: cart.items.values.toList()[index]);
                },
                itemCount: cart.itemCount),
          )
        ],
      )),
    );
  }
}
