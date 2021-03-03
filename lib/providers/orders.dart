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

  Future<void> addOrder(List<CartItemData> cartProducts, double total) async {
    const url = 'https://shopify-ae99f-default-rtdb.firebaseio.com/orders.json';

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
