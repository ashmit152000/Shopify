import 'package:Shopify/screens/product_details_screen.dart';
import 'package:Shopify/screens/products_overview_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyShop',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.deepOrange,
        fontFamily: 'Lato',
        
      ),
      
      home: MyHomePage(),
      routes: {
        ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen()
      },
    );
    
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProductsOverviewScreen();
  }
}
