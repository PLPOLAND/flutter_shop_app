import 'package:flutter/material.dart';
import 'package:flutter_shop_app/widgets/main_drawer.dart';
import 'package:flutter_shop_app/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  const UserProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<ProductsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed('/edit-product');
            },
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: FutureBuilder(
        future: Provider.of<ProductsProvider>(context, listen: false)
            .fetchAndSetProducts(true),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<ProductsProvider>(
                    builder: (context, productsData, child) => RefreshIndicator(
                      onRefresh: () => productsData.fetchAndSetProducts(true),
                      child: ListView.builder(
                        itemCount: productsData.items.length,
                        itemBuilder: (ctx, i) => Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              UserProductItem(product: productsData.items[i]),
                              const Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
