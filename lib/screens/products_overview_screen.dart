import 'package:Shopify/providers/cart.dart';
import 'package:Shopify/providers/product.dart';
import 'package:Shopify/providers/product_providers.dart';
import 'package:Shopify/screens/cart_screen.dart';
import 'package:Shopify/screens/orders_screen.dart';
import 'package:Shopify/widgets/badge.dart';
import 'package:Shopify/widgets/drawer.dart';
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
  var _isInit = true;

  @override
  void initState() {
  
    super.initState();
    
  }

  @override
    void didChangeDependencies() {
      // TODO: implement didChangeDependencies
      if(_isInit){
         Provider.of<ProductProviders>(context).fetchData();
      }
      _isInit = false;
      super.didChangeDependencies();
    }
 

  @override
  Widget build(BuildContext context) {
    // final productContainer = Provider.of<ProductProviders>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopify'),
        actions: [
          Consumer<Cart>(
            builder: (context, cart, ch) => Badge(
              child: ch,
              value: cart.cartItemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
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
        ],
      ),
      body: ProductGridView(_showOnlyFavourites),
      drawer: AppDrawer(),
    );
  }
}
