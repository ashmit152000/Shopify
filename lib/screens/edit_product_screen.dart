import 'package:Shopify/providers/product.dart';
import 'package:Shopify/providers/product_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  var _initValues = {
    'id': '',
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionNode.dispose();
    _imageFocus.removeListener(_updateImageUrl);
  }

  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        final product = Provider.of<ProductProviders>(context, listen: false)
            .getProduct(productId);
        _edittedProduct = product;
        _initValues['id'] = _edittedProduct.id;
        _initValues['title'] = _edittedProduct.title;
        _initValues['description'] = _edittedProduct.description;
        _initValues['price'] = _edittedProduct.price.toString();
        _initValues['imageUrl'] = _edittedProduct.imageUrl;
        _imageUrlController.text = _initValues['imageUrl'];
      }
    }
    _isInit = false;
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
    final _valid = _form.currentState.validate();
    if (!_valid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    if (_edittedProduct.id != null) {
      Provider.of<ProductProviders>(context, listen: false)
          .updateProduct(_edittedProduct.id, _edittedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      Provider.of<ProductProviders>(context, listen: false)
          .addProduct(_edittedProduct)
          .catchError((error) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An error occured'),
                  content: Text('Something went wrong!'),
                  actions: [
                    FlatButton(
                        child: Text('Okay'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ],
                ));
      }).then((response) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    }
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
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
                          id: _edittedProduct.id,
                          title: value.isEmpty ? null : value,
                          description: _edittedProduct.description,
                          price: _edittedProduct.price,
                          imageUrl: _edittedProduct.imageUrl,
                          isFavourite: _edittedProduct.isFavourite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_descriptionNode);
                      },
                      onSaved: (value) {
                        _edittedProduct = Product(
                          id: _edittedProduct.id,
                          title: _edittedProduct.title,
                          description: _edittedProduct.description,
                          price: value.isEmpty
                              ? _edittedProduct.price
                              : double.parse(value),
                          imageUrl: _edittedProduct.imageUrl,
                          isFavourite: _edittedProduct.isFavourite,
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
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionNode,
                      onSaved: (value) {
                        _edittedProduct = Product(
                          id: _edittedProduct.id,
                          title: _edittedProduct.title,
                          description: value,
                          price: _edittedProduct.price,
                          imageUrl: _edittedProduct.imageUrl,
                          isFavourite: _edittedProduct.isFavourite,
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
                                id: _edittedProduct.id,
                                title: _edittedProduct.title,
                                description: _edittedProduct.description,
                                price: _edittedProduct.price,
                                imageUrl: value,
                                isFavourite: _edittedProduct.isFavourite,
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
