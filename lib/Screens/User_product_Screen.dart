import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/Screens/AppDrawer.dart';
import '/Screens/Edit_Screen.dart';
import '/widgets/User_ProductItem.dart';
import '../provider/product.dart';

class UserProductScreen extends StatefulWidget {
  static const routeName = '/UserProductScreen';

  @override
  State<UserProductScreen> createState() => _UserProductScreenState();
}

class _UserProductScreenState extends State<UserProductScreen> {
  bool triggerForRefresh = false;

  // Future<void> _afterRefresh(BuildContext context) async {
  //   try {
  //     return await Provider.of<Products>(context, listen: false)
  //         .fetchingAndReteriveData()
  //         .then((response) {
  //       print(response);
  //       setState(() {
  //         triggerForRefresh = true;
  //       });
  //     });
  //   } catch (error) {
  //     //...
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final _Products = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditScreen.routeName);
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          try {
            await Provider.of<Products>(context, listen: false)
                .fetchingAndReteriveData()
                .then((_) {
              setState(() {
                triggerForRefresh = true;
              });
            });
          } catch (error) {
            //...
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: ListView.builder(
            itemCount: _Products.items.length,
            itemBuilder: (_, index) => UserProductItem(
                _Products.items[index].id,
                _Products.items[index].imageUrl,
                _Products.items[index].title),
          ),
        ),
      ),
    );
  }
}
