
import 'package:Shopify/providers/product_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context).settings.arguments as String;
    final productData = Provider.of<ProductProviders>(context);
    final product = productData.getProduct(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
    );
  }
}
