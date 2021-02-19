import 'package:flutter/material.dart';

class CartItemData {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItemData(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItemData> _items = {};

  Map<String, CartItemData> get items {
    return {..._items};
  }

  int get cartItemCount {
    return  _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) => {
      total += cartItem.price
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      // change the quantity of the existing item.
      _items.update(
          productId,
          (existingItem) => CartItemData(
              id: existingItem.id,
              title: existingItem.title,
              price: existingItem.price,
              quantity: existingItem.quantity + 1));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItemData(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

  void removeItem(String id){
    _items.remove(id);
     notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
