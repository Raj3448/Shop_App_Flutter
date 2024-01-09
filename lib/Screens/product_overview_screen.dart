import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopii2/Screens/AuthenticationScreen.dart';
import '/Screens/AppDrawer.dart';
import '/Screens/cart_screen.dart';
import '/provider/cart.dart';
import '/provider/product.dart';
import '../widgets/Product_Grid_View.dart';
import 'package:provider/provider.dart';
import '/widgets/badge.dart';

enum ToggleFilters {
  favoriteScreen,
  all,
  logOut,
}

class Product_overview_screen extends StatefulWidget {
  static const routeName = '/productOverviewsScreen';
  @override
  State<Product_overview_screen> createState() =>
      _Product_overview_screenState();
}

class _Product_overview_screenState extends State<Product_overview_screen> {
  @override
  void initState() {
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<Products>(context).fetchingAndReteriveData();        //another way to calling another class method before the build method run of another class
    // });
    super.initState();
  }

  bool _isInit = true;
  bool _loadingSpinner = false;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _loadingSpinner = true;
      });

      // Provider.of<Products>(context).fetchingAndReteriveData().then((value) {
      //   setState(() {
      //     _loadingSpinner = false;
      //   });
      // });

      try {
        await Provider.of<Products>(context).fetchingAndReteriveData();
      } catch (error) {
        print(error);
        // showDialog(
        //     context: context,
        //     builder: ((ctx) => AlertDialog(
        //           title: const Center(child: Text('ERROR')),
        //           content: const Center(
        //               child: Text(
        //                   'Failed to fetch content (for refreshing click on \'shopping\')')),
        //           actions: [
        //             FloatingActionButton(
        //               onPressed: () {
        //                 Navigator.of(ctx).pop();
        //               },
        //               child: const Text('Ok'),
        //             )
        //           ],
        //         )));
      } finally {
        setState(() {
          _loadingSpinner = false;
        });
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final getFavorite = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (ToggleFilters value) {
                if (value == ToggleFilters.favoriteScreen) {
                  getFavorite.showFavorite();
                } else if (value == ToggleFilters.all) {
                  getFavorite.showAllList();
                } else {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context)
                      .pushReplacementNamed(AuthScreen.routeName);
                }
              },
              itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: ToggleFilters.favoriteScreen,
                      child: ListTile(
                        leading: Icon(Icons.favorite_sharp),
                        title: Text(
                          'Favorites',
                        ),
                      ),
                    ),
                    const PopupMenuItem(
                      value: ToggleFilters.all,
                      child: ListTile(
                          leading: Icon(Icons.list),
                          title: Text('All Products')),
                    ),
                    const PopupMenuItem(
                        value: ToggleFilters.logOut,
                        child: ListTile(
                          leading: Icon(Icons.logout),
                          title: Text('LogOut'),
                        )),
                  ]),
          Consumer<Cart>(
              builder: (_, cart, child) => Badges(
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(CartScreen.routeName);
                      },
                      icon: const Icon(
                        Icons.shopping_cart,
                        color: Color.fromARGB(255, 57, 220, 206),
                      )),
                  Colors.amber,
                  cart.itemCounts.toString())),
        ],
        title: const Text(
          'Shop App',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: _loadingSpinner
          ? const Center(
              child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 255, 91, 88)),
            )
          : RefreshIndicator(
              onRefresh: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .fetchingAndReteriveData();
                } catch (error) {
                  //...
                }
              },
              child: ProductGridView()),
    );
  }
}
