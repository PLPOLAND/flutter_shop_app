import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'cart.dart';

class Orders with ChangeNotifier {
  static var url;
  final String authToken;
  final String userID;

  Orders(this.authToken, this.userID, this._orders) {
    url = Uri.parse(
        'https://fluttershopapp-36c65-default-rtdb.europe-west1.firebasedatabase.app/orders/$userID.json?auth=$authToken');
    fetchAndSetOrders();
  }

  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    if (authToken == "") {
      return;
    }
    try {
      final response = await http.get(url);
      if (response.body == "null") {
        notifyListeners();
        return;
      }
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<OrderItem> loadedOrders = [];
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price'],
                  ))
              .toList(),
        ));
      });
      loadedOrders.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      _orders = loadedOrders;
      notifyListeners();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  get count => orders.length;

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final date = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': date.toIso8601String(),
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price,
                    })
                .toList(),
          }));
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: date,
        ),
      );
    } catch (error) {
      print(error);
      rethrow;
    } finally {
      notifyListeners();
    }
  }
}

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}
