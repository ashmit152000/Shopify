import 'package:Shopify/providers/auth.dart';
import 'package:Shopify/providers/cart.dart';
import 'package:Shopify/providers/orders.dart';
import 'package:Shopify/screens/auth_screen.dart';
import 'package:Shopify/screens/cart_screen.dart';
import 'package:Shopify/screens/edit_product_screen.dart';
import 'package:Shopify/screens/orders_screen.dart';
import 'package:Shopify/screens/product_details_screen.dart';
import 'package:Shopify/screens/products_overview_screen.dart';
import 'package:Shopify/screens/user_products_screen.dart';
import 'package:flutter/material.dart';
import './providers/product_providers.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),

        ChangeNotifierProxyProvider<Auth,ProductProviders>(
          update: (context,auth,previousProducts) => ProductProviders(auth.token, previousProducts == null ? [] : previousProducts.items,auth.userId),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (context,auth,previousOrders) => Orders(auth.token,
          previousOrders == null ? [] : previousOrders.getOrderItem,auth.userId),
        ),
        
      ],
      child: Consumer<Auth>(
        builder: (_, auth, __) {
          return MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),
            home: auth.getToken() ? ProductsOverviewScreen() : AuthScreen(),
            routes: {
              ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductsScreen.routeName: (ctx) => EditProductsScreen(),
              AuthScreen.routeName: (ctx) => AuthScreen(),
            },
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProductsOverviewScreen();
  }
}
