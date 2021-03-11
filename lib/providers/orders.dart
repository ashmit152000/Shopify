import 'package:Shopify/providers/cart.dart';
import 'package:Shopify/widgets/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItemData> products;
  final DateTime dateTime;

  OrderItem({this.id, this.amount, this.products, this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get getOrderItem {
    return [..._orders];
  }
  final String authToken;
  final String userId;
  
  Orders(this.authToken, this._orders,this.userId);

  Future<void> fetchAndSetOrders() async {
    final url = 'https://shopify-ae99f-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';

    final response = await http.get(url);
    final List<OrderItem> loadedItem = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    if (extractedData == null) {
      return;
    }

    extractedData.forEach((orderId, orderData) {
      loadedItem.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItemData(
                  id: item['id'],
                  price: item['price'],
                  title: item['title'],
                  quantity: item['quantity'],
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedItem.reversed.toList();
  }

  Future<void> addOrder(List<CartItemData> cartProducts, double total) async {
    final url = 'https://shopify-ae99f-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'amount': total,
            'dateTime': DateTime.now().toIso8601String(),
            'products': cartProducts
                .map(
                  (cartP) => {
                    'id': cartP.id,
                    'title': cartP.title,
                    'price': cartP.price,
                    'quantity': cartP.quantity,
                  },
                )
                .toList()
          },
        ),
      );

      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: DateTime.now(),
          products: cartProducts,
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error);

      throw error;
    }
  }
}
