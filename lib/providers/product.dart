import 'dart:convert';

import 'package:Shopify/models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavourite = false});

  void toggleFavourite(String authToken) async {
    final url =
        'https://shopify-ae99f-default-rtdb.firebaseio.com/products/${id}.json?auth=$authToken';
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    try {
      final response = await http.patch(
      url,
      body: json.encode(
        {'isFavourite': isFavourite},
      )
      
    );
    if(response.statusCode >= 400){
       isFavourite = oldStatus;
      notifyListeners();
      throw HttpException("Couldn\'t add to Favourites");
     
    }
    // isFavourite = isFavourite;
    } catch (error) {
      isFavourite = oldStatus;
      notifyListeners();
      throw error;
    }
    
    
  }
}
