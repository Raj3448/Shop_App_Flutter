import 'package:flutter/material.dart';
import '/provider/product.dart';
import '/provider/product_template.dart';
import './product Item.dart';
import 'package:provider/provider.dart';

class ProductGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Productdata = Provider.of<Products>(context);
    final _ProductItem = Productdata.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _ProductItem.length,
      itemBuilder: (ctx, index) => ChangeNotifierProvider<Product>.value(
        value: _ProductItem[index],
        child: ProductItem(),
      ),
    );
  }
}
