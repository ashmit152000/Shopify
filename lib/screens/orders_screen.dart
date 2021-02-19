import 'package:Shopify/widgets/drawer.dart';
import 'package:Shopify/widgets/order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders-screen';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ListView.builder(
        itemCount: orderData.getOrderItem.length,
        itemBuilder: (ctx, i) => OrderItem(
          orderData.getOrderItem[i],
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
