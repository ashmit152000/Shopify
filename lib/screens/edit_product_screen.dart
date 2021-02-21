import 'package:Shopify/providers/product.dart';
import 'package:flutter/material.dart';

class EditProductsScreen extends StatefulWidget {
  static const routeName = 'edit-product';
  @override
  _EditProductsScreenState createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageFocus = FocusNode();
  final _form = GlobalKey<FormState>();
  Product _edittedProduct =
      Product(id: null, title: '', price: 0.0, description: '', imageUrl: '');

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionNode.dispose();
    _imageFocus.removeListener(_updateImageUrl);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imageFocus.addListener(_updateImageUrl);
  }

  void _updateImageUrl() {
    if (!_imageFocus.hasFocus) {
      if (!_imageUrlController.text.startsWith('http') ||
          !_imageUrlController.text.startsWith('https')) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    _form.currentState.save();
    _form.currentState.validate();
    print(_edittedProduct.title);
    print(_edittedProduct.price);
    print(_edittedProduct.description);
    print(_edittedProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Products'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please fill the area';
                  }
                  return null;
                },
                onSaved: (value) {
                  _edittedProduct = Product(
                    id: null,
                    title: value.isEmpty ? null : value,
                    description: _edittedProduct.description,
                    price: _edittedProduct.price,
                    imageUrl: _edittedProduct.imageUrl,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_descriptionNode);
                },
                onSaved: (value) {
                  _edittedProduct = Product(
                    id: null,
                    title: _edittedProduct.title,
                    description: _edittedProduct.description,
                    price: value.isEmpty
                        ? _edittedProduct.price
                        : double.parse(value),
                    imageUrl: _edittedProduct.imageUrl,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please fill the area';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }

                  if (double.parse(value) <= 0) {
                    return 'Please enter a number greater than zero.';
                  }

                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionNode,
                onSaved: (value) {
                  _edittedProduct = Product(
                    id: null,
                    title: _edittedProduct.title,
                    description: value,
                    price: _edittedProduct.price,
                    imageUrl: _edittedProduct.imageUrl,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a value';
                  }
                  if (value.length < 10) {
                    return 'Description should be atleast 10 characters long';
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter URL')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  // TextFormField(
                  //   decoration: InputDecoration(labelText: 'Image URL'),
                  //   keyboardType: TextInputType.url,
                  //   textInputAction: TextInputAction.done,
                  //   controller: _imageUrlController,
                  // ),

                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image Url'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageFocus,
                      onFieldSubmitted: (value) {
                        _saveForm();
                      },
                      onSaved: (value) {
                        _edittedProduct = Product(
                          id: null,
                          title: _edittedProduct.title,
                          description: _edittedProduct.description,
                          price: _edittedProduct.price,
                          imageUrl: value,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please fill the area';
                        }
                        if (!value.startsWith('http') ||
                            !value.startsWith('https')) {
                          return 'Please enter a valid url';
                        }
                        return null;
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
