import 'package:Shopify/providers/product_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context).settings.arguments as String;
    final productData = Provider.of<ProductProviders>(context);
    final product = productData.getProduct(id);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(product.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.title),
              background: Hero(
                tag: product.id,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  product.description,
                  style: TextStyle(fontSize: 15),
                  softWrap: true,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Text(
                        'Amount: ',
                        style: TextStyle(fontSize: 15),
                      ),
                      Card(
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            '\$${product.price}',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        color: Theme.of(context).primaryColor,
                      ),
                      
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                ),
              ),
              SizedBox(height: 800,),
            ]),
          ),
        ],
      ),
    );
  }
}
