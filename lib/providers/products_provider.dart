import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';

class ProductsProvider with ChangeNotifier {
  ProductsProvider(this.token, this._items) {
    url = Uri.parse(
        'https://fluttershopapp-36c65-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$token');
    fetchAndSetProducts();
  }
  Uri? url;
  final token;

  List<Product> _items = [];

  List<Product> get items {
    return [..._items]; // copy of the list (by "..." operator)
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts({bool clearData = false}) async {
    print("fetching products");
    try {
      if (clearData) {
        _items = [];
      }
      final response = await http.get(url!);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((productId, productData) {
        _items.add(Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite: productData['isFavorite'],
        ));
      });
      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    // return

    try {
      final response = await http.post(url!,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite,
          }));
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct); // add the new product to the list
      notifyListeners(); // notify all the listeners that the data has changed (from the ChangeNotifier class)
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  findById(String productId) {
    return _items.firstWhere((product) => product.id == productId);
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://fluttershopapp-36c65-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json?auth=$token');
    var index = _items.indexWhere((product) => product.id == id);
    var deletedItem = _items[index];
    _items.removeAt(index);
    _items.removeWhere((product) => product.id == id);
    try {
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        throw const HttpException("Could not delete product");
      }
    } catch (error) {
      _items.insert(index, deletedItem);
      notifyListeners();
      rethrow;
    }
    notifyListeners();
  }

  Future updateProduct(Product editedProduct) async {
    if (_items.indexWhere((element) => element.id == editedProduct.id) != -1) {
      final url = Uri.parse(
          'https://fluttershopapp-36c65-default-rtdb.europe-west1.firebasedatabase.app/products/${editedProduct.id}.json?auth=$token');
      try {
        await http.patch(
          url,
          body: json.encode({
            'title': editedProduct.title,
            'description': editedProduct.description,
            'imageUrl': editedProduct.imageUrl,
            'price': editedProduct.price,
          }),
        );
        _items[_items.indexWhere((element) => element.id == editedProduct.id)] =
            editedProduct;
      } catch (e) {
        print(e);
        rethrow;
      }
    }
    notifyListeners();
    return Future.value(); // ToDO: implement the http update
  }
}
