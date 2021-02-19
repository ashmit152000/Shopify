import 'package:Shopify/screens/orders_screen.dart';
import 'package:Shopify/screens/products_overview_screen.dart';
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
                'Products',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            ListTile(
              leading: Icon(Icons.payment),
              title: Text(
                'Orders',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
              },
            ),

             
          ],
        ),
      );
  }
}