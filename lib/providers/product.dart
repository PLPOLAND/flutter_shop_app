import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavoriteStatus() async {
    isFavorite = !isFavorite;

    final url = Uri.parse(
        'https://fluttershopapp-36c65-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json');
    try {
      await http.patch(
        url,
        body: json.encode({
          'isFavorite': isFavorite,
        }),
      );
    } catch (e) {
      print(e);
      rethrow;
    }

    notifyListeners();
  }
}
