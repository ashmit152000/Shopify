import 'package:Shopify/providers/product.dart';
import 'package:Shopify/providers/product_providers.dart';
import 'package:Shopify/widgets/drawer.dart';
import 'package:Shopify/widgets/user_product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-product-screen';
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductProviders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productData.items.length,
          itemBuilder: (_, i) => Column(
            children: [
              UserProductItem(
                  productData.items[i].title, productData.items[i].imageUrl),
                  Divider(),
            ],
          ),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
