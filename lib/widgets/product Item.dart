import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/Screens/product_details_screen.dart';
import '/main.dart';
import '/provider/cart.dart';
import '/provider/product_template.dart';

class ProductItem extends StatefulWidget {
  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool toggle = true;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    //final _SingleProductData = Provider.of<Product>(context);   // another way of accensing data as a provider by using Consumer class as below mentioned

    // Widget _showSnackBar() {

    //     return Show
    // }

    return Consumer<Product>(
      builder: (context, _SingleProductData, child) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(Product_Details_Screen.routeName, arguments: {
              'Id': _SingleProductData.id,
            });
          },
          child: GridTile(
            footer: GridTileBar(
              backgroundColor: Colors.black54,
              title: Text(_SingleProductData.title,
                  style: MyApp.fonttheme, textAlign: TextAlign.center),
              leading: IconButton(
                icon: _SingleProductData.isFavorite
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : const Icon(Icons.favorite_border),
                onPressed: () async {
                  try {
                    await _SingleProductData.toggleIsFavorite();
                  } catch (error) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Server Error!'),
                      duration: Duration(seconds: 3),
                      dismissDirection: DismissDirection.startToEnd,
                    ));
                  }
                },
              ),
              trailing: Consumer<Cart>(
                builder: (context, _cart, child) => IconButton(
                  icon: toggle
                      ? const Icon(Icons.shopping_cart)
                      : const Icon(
                          Icons.shopping_cart,
                          color: Colors.lime,
                        ),
                  onPressed: () {
                    setState(() {
                      count++;
                      toggle = false;
                    });
                    _cart.addItem(_SingleProductData.id,
                        _SingleProductData.price, _SingleProductData.title);

                    ScaffoldMessenger.of(context)
                        .hideCurrentSnackBar(); //After continuous pressing the icon then each bar stay for 2 second due to that resons its method hide current bar show the upcomming Bar
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('Item Added Into cart !'),
                      duration: const Duration(seconds: 2),
                      action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            setState(() {
                              count--;
                              if (count == 0) {
                                toggle = true;
                              }
                            });
                            _cart.removeSingleItem(_SingleProductData.id);
                          }),
                    ));
                  },
                ),
              ),
            ),
            child: Hero(
              tag: _SingleProductData.id,
              child: FadeInImage(
                placeholder:
                    const AssetImage('assests/Images/downloadImage.jpg'),
                image: NetworkImage(_SingleProductData.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
