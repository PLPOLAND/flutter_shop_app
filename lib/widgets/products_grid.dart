import 'package:flutter/material.dart';
import 'package:flutter_shop_app/providers/products_provider.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  ProductsGrid(this.showOnlyFavorites);
  bool showOnlyFavorites;

  @override
  Widget build(BuildContext context) {
    final productsProviderData = Provider.of<ProductsProvider>(context);
    final products = showOnlyFavorites
        ? productsProviderData.favoriteItems
        : productsProviderData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
          value: products[index], child: ProductItem()),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
