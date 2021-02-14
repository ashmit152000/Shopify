import 'package:Shopify/widgets/productgrid.dart';
import 'package:flutter/material.dart';


class ProductsOverviewScreen extends StatelessWidget {
  // final List<Product> loadedProducts = ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopify'),
      ),
      body: ProductGridView(),
    );
  }
}
