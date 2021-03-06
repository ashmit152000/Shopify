import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem(this.id, this.productId, this.price, this.quantity, this.title);

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, ch) => Dismissible(
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          cart.removeItem(productId);
        },
        confirmDismiss: (direction) {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Are you sure ?'),
              content: Text('Do you want to remove the item from the cart ? '),
              actions: [
                FlatButton(child: Text('No'),onPressed: () {
                  Navigator.of(context).pop(false);
                },),
                FlatButton(child: Text('Yes !'),onPressed: (){
                  Navigator.of(context).pop(true);
                },),
              ],
              
            ),
          );
        },
        key: ValueKey(id),
        background: Container(
          color: Theme.of(context).errorColor,
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        ),
        child: Card(
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                child: FittedBox(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text('\$$price'),
                  ),
                ),
              ),
              title: Text(title),
              subtitle: Text('Total: \$${price * quantity}'),
              trailing: Text('${quantity}X'),
            ),
          ),
        ),
      ),
    );
  }
}
