
import 'package:Shopify/providers/product.dart';
import 'package:Shopify/widgets/product_item.dart';
import 'package:Shopify/widgets/productgrid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_providers.dart';

class ProductGridView extends StatelessWidget {
  final _showFav;
  ProductGridView(this._showFav);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductProviders>(context);
    final products = _showFav ? productsData.favorites : productsData.items;
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
        childAspectRatio: 3 / 5,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
    );
  }
}
