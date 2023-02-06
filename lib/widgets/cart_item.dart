import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({
    super.key,
    required this.item,
  });

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(child: Text('\$ ${item.price}')),
              ),
            ),
            title: Text(item.title),
            subtitle: Text('Total: \$ ${item.price * item.quantity}'),
            trailing: Text('${item.quantity} x'),
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      // confirmDismiss: (direction) {
      //   return showDialog(
      //     context: context,
      //     builder: (ctx) => AlertDialog(
      //       title: const Text('Are you sure?'),
      //       content:
      //           const Text('Do you want to remove the item from the cart?'),
      //       actions: [
      //         TextButton(
      //           onPressed: () {
      //             Navigator.of(ctx).pop(false);
      //           },
      //           child: const Text('No'),
      //         ),
      //         TextButton(
      //           onPressed: () {
      //             Navigator.of(ctx).pop(true);
      //           },
      //           child: const Text('Yes'),
      //         ),
      //       ],
      //     ),
      //   );
      // },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(item.id);
      },
    );
  }
}
