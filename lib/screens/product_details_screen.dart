import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  
  static const routeName = '/product-detail';
  
  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(appBar: AppBar(title: Text(title),),);
  }
}