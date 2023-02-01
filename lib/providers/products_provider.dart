import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items => [..._items]; // copy of the list

  void addProduct() {
    _items.add(
      Product(
        id: DateTime.now().toString(),
        title: 'Red Shirt',
        description: 'A red shirt - it is pretty red!',
        price: 29.99,
        imageUrl:
            'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      ),
    );
    notifyListeners(); // notify all the listeners that the data has changed (from the ChangeNotifier class)
  }
}
