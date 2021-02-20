import 'package:Shopify/screens/orders_screen.dart';
import 'package:Shopify/screens/products_overview_screen.dart';
import 'package:Shopify/screens/user_products_screen.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Text(
                'Actions',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            ListTile(
              leading: Icon(Icons.shop),
              title: Text(
                'Shop',
                style: TextStyle(fontSize: 15),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text(
                'Orders',
                style: TextStyle(fontSize: 15),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
              },
            ),

            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                'Manage Products',
                style: TextStyle(fontSize: 15),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
              },
            ),

            Divider(),

             
          ],
        ),
      );
  }
}