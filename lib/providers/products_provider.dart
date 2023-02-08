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

  void addProduct(Product product) {
    final newProduct = Product(
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      id: product.id == '' ? DateTime.now().toString() : product.id,
    );

    _items.add(newProduct); // add the new product to the list
    notifyListeners(); // notify all the listeners that the data has changed (from the ChangeNotifier class)
  }

  findById(String productId) {
    return _items.firstWhere((product) => product.id == productId);
  }

  void deleteProduct(String id) {
    _items.removeWhere((product) => product.id == id);
    notifyListeners();
  }

  void updateProduct(Product editedProduct) {
    if (_items.indexWhere((element) => element.id == editedProduct.id) != -1) {
      _items[_items.indexWhere((element) => element.id == editedProduct.id)] =
          editedProduct;
    }
    notifyListeners();
  }
}
