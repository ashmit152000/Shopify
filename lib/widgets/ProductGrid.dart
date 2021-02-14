
import 'package:Shopify/providers/product.dart';
import 'package:Shopify/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_providers.dart';

class ProductGridView extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductProviders>(context);
    final products = productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(child: ProductItem(
          // id: products[index].id,
          // title: products[index].title,
          // imageUrl: products[index].imageUrl,
        ),value: products[index] ,);
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
    );
  }
}
