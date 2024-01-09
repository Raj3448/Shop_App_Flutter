import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/product_template.dart';
import '../provider/product.dart';

class EditScreen extends StatefulWidget {
  static const routeName = '/EditScreen';
  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _priceFocusNode = FocusNode();
  final _DiscriptionNode = FocusNode();
  final _ImageURLNode = FocusNode();

  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  String temp = '';
  //bool _toggleAfterAdding = false;
  late Product _EditedProduct = Product(
    id: temp,
    title: _titleController.text,
    description: _descriptionController.text,
    price: double.parse(_priceController.text),
    imageUrl: _ImageURLController.text,
    isFavorite: _EditedProduct.isFavorite,
  );

  final _ImageURLController = TextEditingController();

  late String productId;

  bool _isLoading = false;

  void _updateImageListener() {
    if (!_ImageURLNode.hasFocus) {
      if ((!_ImageURLController.text.startsWith('http') &&
              (!_ImageURLController.text.startsWith('https')) ||
          (!_ImageURLController.text.endsWith('.png') &&
              !_ImageURLController.text.endsWith('.jpg') &&
              !_ImageURLController.text.endsWith('.jpeg')))) {
        return;
      }
      setState(() {});
    }
  }

  bool isInits = true;

  @override
  void initState() {
    _ImageURLController.addListener(_updateImageListener);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInits) {
      productId = ModalRoute.of(context)!.settings.arguments.toString();
      Products productsProvider = Provider.of<Products>(context, listen: false);
      _EditedProduct = productsProvider.finById(productId);

      if (_EditedProduct.title != '') {
        _titleController.text = _EditedProduct.title;
        _priceController.text = _EditedProduct.price.toString();
        _descriptionController.text = _EditedProduct.description;
        _ImageURLController.text = _EditedProduct.imageUrl;

        _EditedProduct = Product(
          id: _EditedProduct.id,
          title: _titleController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          imageUrl: _ImageURLController.text,
          isFavorite: _EditedProduct.isFavorite,
        );
      }
      isInits = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _ImageURLController.removeListener(_updateImageListener);
    _priceFocusNode.dispose();
    _DiscriptionNode.dispose();
    _ImageURLController.dispose();
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> showNetworkErrorDialog() async {
    return await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              content: const Text('504 error'),
              title: const Text('Something went wrong!'),
              actions: [
                FloatingActionButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Navigator.of(context).pop();
                    }),
              ],
            ));
  }

  int flag = 0;

  void _saveForm() {
    bool isValidate = _globalKey.currentState!.validate();

    if (!isValidate) {
      return;
    }

    _globalKey.currentState?.save();
    setState(() {
      flag = 1;
      _isLoading = true;
    });

    _EditedProduct = Product(
      id: _EditedProduct.id,
      title: _titleController.text,
      description: _descriptionController.text,
      price: double.parse(_priceController.text),
      imageUrl: _ImageURLController.text,
      isFavorite: _EditedProduct.isFavorite,
    );

    if (!(Products.toggleForUpdate == true) && (_EditedProduct.id != temp)) {
      Products.toggleForUpdate = false;

      print('for update');
      Provider.of<Products>(context, listen: false)
          .updateProduct(productId, _EditedProduct)
          .catchError((error) {
        return showNetworkErrorDialog();
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    } else {
      print('for adding');

      Provider.of<Products>(context, listen: false)
          .addItems(_EditedProduct)
          .catchError((error) {
        return showNetworkErrorDialog();
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    }
    // print('Final Submitted Product From Edited Screen:');

    // print(_EditedProduct);
    // print('ID ' + _EditedProduct.id);
    // print('title ' + _EditedProduct.title);
    // print('description ' + _EditedProduct.description);
    // print('Price ' + _EditedProduct.price.toString());
    // print('ImageUrl ' + _EditedProduct.imageUrl);
    // print('ImageUrl ' + _EditedProduct.isFavorite.toString());
    // print('--------------');
    // print(_EditedProduct);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.pink,
                strokeWidth: 3.0,
              ),
            )
          : SingleChildScrollView(
              child: Form(
                key: _globalKey,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(children: [
                    TextFormField(
                        cursorColor: Colors.cyan,
                        decoration: const InputDecoration(
                          label: Text(
                            'Title',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          hintText: 'Enter Product Title:',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter title';
                          }
                          if (value.length <= 5) {
                            return 'Please enter few more content';
                          } else {
                            return null;
                          }
                        },
                        controller: _titleController,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);

                          print(_titleController.text);
                        }),
                    TextFormField(
                        decoration: const InputDecoration(
                          label: Text(
                            'Price',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          hintText: 'Enter Product Price:',
                        ),
                        cursorColor: Colors.cyan,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        focusNode: _priceFocusNode,
                        controller: _priceController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter integer number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter number greater than zero';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_DiscriptionNode);

                          print(_descriptionController.text);
                        }),
                    TextFormField(
                      decoration: const InputDecoration(
                          label: Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          hintText: 'Enter Product Description In 3 Lines:'),
                      cursorColor: Colors.cyan,
                      maxLines: 4,
                      controller: _descriptionController,
                      focusNode: _DiscriptionNode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter description';
                        }
                        if (value.length <= 10) {
                          return 'Please enter few more context';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        print(_descriptionController.text);
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 150,
                          width: 150,
                          margin: const EdgeInsets.only(top: 10, right: 15),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2, color: Colors.deepPurple)),
                            child: _ImageURLController.text.isEmpty
                                ? const Center(
                                    child: Text(
                                      'Enter Image URL',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  )
                                : FittedBox(
                                    fit: BoxFit.cover,
                                    child: Image.network(
                                      _ImageURLController.text,
                                    ),
                                  ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                                label: Text('Image URL'),
                                hintText: 'Enter Image URL Only:'),
                            cursorColor: Colors.cyan,
                            textInputAction: TextInputAction.done,
                            controller: _ImageURLController,
                            focusNode: _ImageURLNode,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter URL';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter valid URL';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please enter valid image URL';
                              }

                              return null;
                            },
                            onFieldSubmitted: (_) {
                              print(_ImageURLController.text);

                              _saveForm();
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 25, right: 15),
                      child: ElevatedButton(
                        onPressed: () {
                          _saveForm();
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
    );
  }
}
