//import 'dart:ffi';

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:date_time/date_time.dart';
import 'package:http/http.dart' as _HTTP;

import 'product_template.dart';

class Products with ChangeNotifier {
  static bool toggleForUpdate = false;

  List<Product> _items = [
    // Product(
    //     id: 'T1',
    //     title: 'mobile',
    //     description: 'Apple iPhone 13 Pro 128 GB (Sierra Blue, 6 GB RAM)',
    //     price: 129000,
    //     imageUrl:
    //         'https://img2.gadgetsnow.com/gd/images/products/additional/large/G306210_View_1/mobiles/smartphones/apple-iphone-13-pro-128-gb-sierra-blue-6-gb-ram-.jpg'),
    // Product(
    //     id: 'T2',
    //     title: 'mobile',
    //     description: 'Google Pixel 6a 5G (Sage, 6GB RAM, 128GB Storage)',
    //     price: 28799,
    //     imageUrl:
    //         'https://www.addmecart.com/wp-content/uploads/2022/12/m1-64.png'),
    // Product(
    //     id: 'T3',
    //     title: 'mobile',
    //     description: 'Google Pixel 7 Pro 256 GB (Snow, 12 GB RAM)',
    //     price: 90800,
    //     imageUrl:
    //         'https://img1.gadgetsnow.com/gd/images/products/additional/large/G441410_View_1/mobiles/smartphones/google-pixel-7-pro-256-gb-snow-12-gb-ram-.jpg'),
    // Product(
    //     id: 'T4',
    //     title: 'mobile',
    //     description:
    //         'OnePlus 10T 5G (Moonstone Black, 12GB RAM, 256GB Storage)',
    //     price: 54999,
    //     imageUrl:
    //         'https://i.gadgets360cdn.com/products/large/oneplus-10t-oneplus-636x800-1659541437.jpg?downsize=*:180'),
    // Product(
    //     id: 'T5',
    //     title: 'watch',
    //     description: 'Apple Watch SE GPS + Cellular with Sports Band ',
    //     price: 35400,
    //     imageUrl:
    //         'https://media-ik.croma.com/prod/https://media.croma.com/image/upload/v1685969164/Croma%20Assets/Communication/Wearable%20Devices/Images/262061_qpjlyy.png?tr=w-640'),
    // Product(
    //     id: 'T6',
    //     title: 'watch',
    //     description: 'Mens Watches,Waterproof Military Outdoor Sport Watch',
    //     price: 22000,
    //     imageUrl:
    //         'https://images-cdn.ubuy.co.in/634ac34822bdfb7c3a37a993-mens-watches-skmei-waterproof-military.jpg'),
    // Product(
    //     id: 'T7',
    //     title: 'headphones',
    //     description:
    //         'boAt Rockerz 450 Bluetooth On Ear Headphones with Mic, Upto 15 Hours Playback',
    //     price: 1400,
    //     imageUrl:
    //         'https://m.media-amazon.com/images/I/61u1VALn6JL._SL1500_.jpg'),
    // Product(
    //     id: 'T8',
    //     title: 'earbuds',
    //     description:
    //         'Boult Audio Z25 True Wireless in Ear Earbuds with 32H Playtime, 45ms Low Latency',
    //     price: 1500,
    //     imageUrl:
    //         'https://m.media-amazon.com/images/I/71vlByXS-JL._SL1500_.jpg'),
    // Product(
    //     id: 'T9',
    //     title: 'earbuds',
    //     description:
    //         'KilTer By Life Like M10 TWS Bluetooth 5.1 Earphone Charging boxwireless Earbuds',
    //     price: 2500,
    //     imageUrl: 'https://m.media-amazon.com/images/I/51VLvYyblzL.jpg'),
    // Product(
    //     id: 'T10',
    //     title: 'VR Headset',
    //     description:
    //         'Meta Quest Pro All-In-One VR Headset (256GB) With GST Invoice',
    //     price: 139000,
    //     imageUrl:
    //         'https://i0.wp.com/deviestore.com/wp-content/uploads/2022/10/1-3.jpg?fit=1400%2C1050&ssl=1'),
    // Product(
    //     id: 'T11',
    //     title: 'VR Headset',
    //     description: 'PICO 4 All-in-One 128GB VR Headset Bundled with X-Ninja',
    //     price: 35000,
    //     imageUrl:
    //         'https://bankofelectronics.com/97-medium_default/oculus-quest-2-meta-vr-headset-buy-India.jpg'),
    // Product(
    //     id: 'T12',
    //     title: 'mobile',
    //     description:
    //         'Spigen TPU, PC Tough Armor Back Cover Case Compatible for Google Pixel 5 ',
    //     price: 8000,
    //     imageUrl:
    //         'https://m.media-amazon.com/images/I/51iFmpdKeuL._SL1000_.jpg'),
  ];

  var _showFavorites = false;

  List<Product> get items {
    if (_showFavorites) {
      return _items.where((element) => element.isFavorite).toList();
    } else {
      return [..._items];
    }
  }

  void showFavorite() {
    _showFavorites = true;
    notifyListeners();
  }

  void showAllList() {
    _showFavorites = false;
    notifyListeners();
  }

  // Product? findItem(String id) {
  //   Product? ProdItem;
  //   try {
  //     ProdItem = _items.firstWhere((element) => id == element.id);
  //   } catch (Exception) {
  //     ProdItem = null;
  //     print('error: $Exception');
  //   }
  //   return ProdItem;
  // }

  Future<Map<String, dynamic>> fetchingAndReteriveData() async {
    Uri url = Uri(
      scheme: 'https',
      host: 'flutterdemo-8d638-default-rtdb.firebaseio.com',
      path: '/Product.json',
    );
    try {
      final response = await _HTTP.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      List<Product> loadedProductData = [];

      extractedData.forEach((productKey, productData) {
        loadedProductData.add(Product(
            id: productKey,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageURL'],
            isFavorite: productData['isFavorite']));
      });
      _items = loadedProductData;
      notifyListeners();
      print(json.decode(response.body));
      return extractedData;
    } catch (error) {
      throw const HttpException("Data could not be deleted");
    }
  }

  Future<void> addItems(Product product) {
    //const url = 'https://flutterdemo-8d638-default-rtdb.firebaseio.com/Product.json';

    Uri url = Uri(
      scheme: 'https',
      host: 'flutterdemo-8d638-default-rtdb.firebaseio.com',
      path: '/Product.json',
    );

    return _HTTP
        .post(url,
            body: json.encode({
              'title': product.title,
              'price': product.price,
              'description': product.description,
              'imageURL': product.imageUrl,
              'isFavorite': product.isFavorite,
            }))
        .then((response) {
      print(json.decode(response.body));
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      print('Product Provider Received Object: ----');
      print('ID ' + newProduct.id);
      print('title ' + newProduct.title);
      print('description ' + newProduct.description);
      print('Price ' + newProduct.price.toString());
      print('ImageUrl ' + newProduct.imageUrl);
      print('ImageUrl ' + newProduct.isFavorite.toString());

      print('--------------');

      _items.add(newProduct);
      notifyListeners();
    }).catchError((error) {
      print(error);
      throw error;
    });
  }

  Product finById(String productId) {
    toggleForUpdate = false;
    final product = _items.firstWhere((element) => element.id == productId,
        orElse: () => Product(
            id: '', title: '', description: '', price: 0.0, imageUrl: ''));
    return product;
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    int ProdIndex = _items.indexWhere((element) => element.id == id);

    if (ProdIndex >= 0) {
      final Uri url = Uri(
        scheme: 'https',
        host: 'flutterdemo-8d638-default-rtdb.firebaseio.com',
        path: '/Product/$id.json',
      );

      await _HTTP.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'price': newProduct.price,
            'description': newProduct.description,
            'imageURL': newProduct.imageUrl,
          }));

      _items[ProdIndex] = newProduct;
      print('Product Provider Received Object: ----');
      print('ID ' + newProduct.id);
      print('title ' + newProduct.title);
      print('description ' + newProduct.description);
      print('Price ' + newProduct.price.toString());
      print('ImageUrl ' + newProduct.imageUrl);
      print('ImageUrl ' + newProduct.isFavorite.toString());
      print('--------------');
      notifyListeners();
    }
  }

  Future<void> removeProduct(String productId) async {
    final Uri url = Uri(
      scheme: 'https',
      host: 'flutterdemo-8d638-default-rtdb.firebaseio.com',
      path: '/products/$productId.json',
    );
    final existingProductIndex =
        _items.indexWhere((productitem) => productitem.id == productId);

    if (existingProductIndex >= 0) {
      dynamic existingProduct = _items[existingProductIndex];
      _items.remove(_items[existingProductIndex]);
      notifyListeners();
      try {
        final response = await _HTTP.delete(url);
        print('Deleted statusCode : ${response.statusCode}');

        if (response.statusCode >= 400) {
          _items.insert(existingProductIndex, existingProduct);
          notifyListeners();
        }

        int statusCode = json.decode(response.statusCode.toString()) as int;
        print('statusCode ${statusCode}');
        print('Delete user item successfully!!!');
        existingProduct = null;
      } catch (error) {
        _items.insert(existingProductIndex, existingProduct);
        notifyListeners();
        throw const HttpException("Data could not be deleted");
      }
      notifyListeners();
    }
  }
}
