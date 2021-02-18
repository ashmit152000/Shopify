import 'package:Shopify/providers/cart.dart';
import 'package:Shopify/providers/product.dart';
import 'package:Shopify/providers/product_providers.dart';
import 'package:Shopify/widgets/badge.dart';
import 'package:Shopify/widgets/productgrid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum FilterOptions { Favourites, All }

class ProductsOverviewScreen extends StatefulWidget {
  // final List<Product> loadedProducts = ;
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavourites = false;
  @override
  Widget build(BuildContext context) {
    // final productContainer = Provider.of<ProductProviders>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopify'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favourites'),
                value: FilterOptions.Favourites,
              ),
              PopupMenuItem(
                child: Text('Show all'),
                value: FilterOptions.All,
              )
            ],
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favourites) {
                  //...
                  // productContainer.showFavouritesOnly();

                  _showOnlyFavourites = true;
                  // print(_showOnlyFavourites);
                } else {
                  //..
                  // productContainer.showAll();

                  _showOnlyFavourites = false;
                  // print(_showOnlyFavourites);
                }
              });
            },
          ),
          Consumer<Cart>(builder: (context, cart, ch) => Badge(
            child: ch,
            value: cart.cartItemCount.toString(),
          ),child: Icon(Icons.shopping_cart)) 
        ],
      ),
      body: ProductGridView(_showOnlyFavourites),
    );
  }
}
