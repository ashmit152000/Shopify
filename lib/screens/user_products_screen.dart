import 'package:Shopify/providers/product.dart';
import 'package:Shopify/providers/product_providers.dart';
import 'package:Shopify/screens/edit_product_screen.dart';
import 'package:Shopify/widgets/drawer.dart';
import 'package:Shopify/widgets/user_product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatefulWidget {
  static const routeName = '/user-product-screen';

  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
  
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  
  Future<void> _refreshProducts(BuildContext context)  async {
    await Provider.of<ProductProviders>(context, listen: false).fetchData(true);
  }

  

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<ProductProviders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductsScreen.routeName);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder:(ctx,snapshot) => snapshot.connectionState == ConnectionState.waiting ? Center(child: CircularProgressIndicator(),) : RefreshIndicator(
          onRefresh: () {return _refreshProducts(context);},
          child: Consumer<ProductProviders>(builder: (ctx,productData,ch) => Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
              itemCount: productData.items.length,
              itemBuilder: (_, i) => Column(
                children: [
                  UserProductItem(
                    productData.items[i].id,
                    productData.items[i].title,
                    productData.items[i].imageUrl,
                  ),
                  Divider(),
                ],
              ),
            ),
          )),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
