import 'package:flutter/material.dart';

import 'product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: "p1",
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    )
  ];

  List<Product> get items {
    return [..._items]; // copy of the list (by "..." operator)
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  void addProduct() {
    // _items.add();
    notifyListeners(); // notify all the listeners that the data has changed (from the ChangeNotifier class)
  }

  findById(String productId) {
    return _items.firstWhere((product) => product.id == productId);
  }
}
