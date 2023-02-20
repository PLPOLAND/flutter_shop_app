import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

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

  Future<void> toggleFavoriteStatus(String token, String userID) async {
    isFavorite = !isFavorite;
    notifyListeners();

    final url = Uri.parse(
        'https://fluttershopapp-36c65-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userID/$id.json?auth=$token');
    try {
      final response = await http.put(
        url,
        body: json.encode({
          'isFavorite': isFavorite,
        }),
      );
      if (response.statusCode >= 400) {
        print("Error: ${response.statusCode} ${response.body}");
        isFavorite = !isFavorite;
        notifyListeners();
        throw HttpException("Could not update product");
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
