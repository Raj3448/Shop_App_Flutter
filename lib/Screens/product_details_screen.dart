import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/product_template.dart';
import '/provider/product.dart';

class Product_Details_Screen extends StatelessWidget {
  static const routeName = '/Product_Details_Screen';

  @override
  Widget build(BuildContext context) {
    dynamic receivedObject = ModalRoute.of(context)?.settings.arguments;
    const Key _centerkey = ValueKey<String>("Bottom sliver key list");

    Product? _singleProductItem = Provider.of<Products>(context, listen: false)
        .items
        .firstWhere((element) => element.id == receivedObject['Id']);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _singleProductItem.title,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: CustomScrollView(
        key: _centerkey,
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                  decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    _singleProductItem.title,
                    style: const TextStyle(fontSize: 14),
                  )),
              centerTitle: true,
              background: Hero(
                  tag: _singleProductItem.id,
                  child: Image.network(_singleProductItem.imageUrl)),
            ),
          ),
          SliverList(
              key: _centerkey,
              delegate: SliverChildListDelegate([
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    '₹${_singleProductItem.price.toString()}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      _singleProductItem.description,
                      style: const TextStyle(
                        fontSize: 22,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ]))
        ],
      ),
    );
  }
}
