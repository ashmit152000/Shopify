import 'package:Shopify/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/shopping-cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Card(
                  margin: EdgeInsets.all(15),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(fontSize: 20),
                        ),
                        Spacer(),
                        Consumer<Cart>(
                          builder: (context, cart, ch) => Chip(
                            label: Text(
                              "\$${cart.totalAmount}",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .primaryTextTheme
                                      .headline6
                                      .color),
                            ),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        ),
                        FlatButton(
                          child: Text(
                            'Order Now',
                          ),
                          onPressed: cart.totalAmount  <= 0 ? null : () async {
                            setState(() {
                              _isLoading = true;
                            });
                            await Provider.of<Orders>(context, listen: false)
                                .addOrder(cart.items.values.toList(),
                                    cart.totalAmount);
                            cart.clearCart();
                            setState(() {
                              _isLoading = false;
                            });
                          },
                          // color: Theme.of(context).primaryColor,
                          textColor: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Consumer<Cart>(
                  builder: (context, cart, build) => Expanded(
                    child: ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: (ctx, i) => CartItem(
                          cart.items.values.toList()[i].id,
                          cart.items.keys.toList()[i],
                          cart.items.values.toList()[i].price,
                          cart.items.values.toList()[i].quantity,
                          cart.items.values.toList()[i].title),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
