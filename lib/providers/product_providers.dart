import 'package:Shopify/models/http_exception.dart';
import 'package:Shopify/providers/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductProviders with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String authToken;

  ProductProviders(this.authToken,this._items);

  List<Product> get favorites {
    return _items.where((prodItem) => prodItem.isFavourite == true).toList();
  }

  List<Product> get items {
    return [..._items];
  }

  // void showFavouritesOnly() {
  //   _showFavouritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavouritesOnly = false;
  //   notifyListeners();
  // }

  Product getProduct(String id) {
    return _items.firstWhere((meal) => meal.id == id);
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final url =
        'https://shopify-ae99f-default-rtdb.firebaseio.com/products/${id}.json?auth=$authToken';

    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      await http.patch(
        url,
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.imageUrl,
            // 'isFavourite': newProduct.isFavourite
          },
        ),
      );
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://shopify-ae99f-default-rtdb.firebaseio.com/products/${id}.json?auth=$authToken';

    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var exisitingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, exisitingProduct);
      notifyListeners();
      throw HttpException("Couldn\'t delete product");
    } else {
      exisitingProduct = null;
    }

    // _items.removeWhere((prod) => prod.id == id);
  }

  Future<void> fetchData() async {
    final url =
        'https://shopify-ae99f-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: double.parse(prodData['price']),
            imageUrl: prodData['imageUrl'],
            isFavourite: prodData['isFavourite'],
          ),
        );
        _items = loadedProducts;
        notifyListeners();
      });
      print(json.decode(response.body));
    } catch (error) {
      // print(error);
      // throw error;
    }
  }

  Future<void> addProduct(Product p) async {
    final url =
        'https://shopify-ae99f-default-rtdb.firebaseio.com/products.json?auth=$authToken';

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': p.title,
          'description': p.description,
          'price': p.price,
          'imageUrl': p.imageUrl,
          'isFavourite': p.isFavourite,
        }),
      );
      final newProduct = Product(
        title: p.title,
        price: p.price,
        description: p.description,
        imageUrl: p.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      // print(error);
      throw error;
    }
  }
}
