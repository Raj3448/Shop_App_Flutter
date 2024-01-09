import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:http/http.dart' as _HTTP;
import '/models/HttpException.dart';

import './cart.dart';

class OrderItem {
  final String id;
  final List<CartItem> OrderedProducts;
  final DateTime dateTime;
  final double totalAmount;

  OrderItem(this.id, this.OrderedProducts, this.dateTime, this.totalAmount);
}

class Order with ChangeNotifier {
  List<OrderItem> _OrderItems = [];

  List<OrderItem> get OrderItems {
    return [..._OrderItems];
  }

  Future<void> fetchOrderedItems() async {
    Uri url = Uri(
        scheme: 'https',
        host: 'flutterdemo-8d638-default-rtdb.firebaseio.com',
        path: '/order.json');

    List<OrderItem> loadedOrderList = [];
    dynamic response;
    try {
      response = await _HTTP.get(url);

      final extractedOrderedItem =
          json.decode(response.body) as Map<String, dynamic>;
      print('Status code of OrderedItems: ${response.statusCode}');
      if (response.statusCode == 200) {
        extractedOrderedItem.forEach((OrderItemkey, orderedItems) {
          List<CartItem> orderedProductsList = [];
          List<dynamic> tempList = json.decode(orderedItems['orderedProducts']);
          try {
            orderedProductsList = tempList
                .map((singleItem) => CartItem(
                    id: singleItem['id'],
                    title: singleItem['title'],
                    price: singleItem['price'],
                    quantity: singleItem['quantity']))
                .toList();
          } catch (error) {
            print('Error (when converting Map object into List ):$error');
            //...
          }
          loadedOrderList.add(OrderItem(
              OrderItemkey,
              orderedProductsList,
              DateTime.parse(orderedItems['dateTime']),
              double.parse(orderedItems['totalAmount'])));
        });
        print('statement reaches upto me 1');
        //return extractedOrderedItem;
      } else {
        print('Orderlist unable to fetching!!!');
        //return null;
      }
      _OrderItems = loadedOrderList;
      notifyListeners();
      print('statement reaches upto me2');
    } catch (error) {
      print('Error after OrderFetching: $error');
      throw HttpException("Error when fetching orderlist from db");
    }
  }

  Future<void> addOrderItems(
      List<CartItem> orderproducts, double totalAmount) async {
    final Uri url = Uri(
      scheme: 'https',
      host: 'flutterdemo-8d638-default-rtdb.firebaseio.com',
      path: '/order.json',
    );
    final dTimeContent = DateTime.now();

    try {
      final httpResponse = await _HTTP.post(url,
          body: json.encode({
            'dateTime': dTimeContent.toIso8601String(),
            'totalAmount': totalAmount.toString(),
            'orderedProducts': json.encode(orderproducts
                .map((cartElement) => {
                      'id': cartElement.id,
                      'title': cartElement.title,
                      'price': cartElement.price,
                      'quantity': cartElement.quantity,
                    })
                .toList()),
          }));
      print("http received response: $httpResponse");
      final response = json.decode(httpResponse.body)['name'];
      print('Received response:$response');
      if (httpResponse.statusCode == 200) {
        _OrderItems.insert(
            0,
            OrderItem(json.decode(httpResponse.body)['name'], orderproducts,
                dTimeContent, totalAmount));
        print('Order list added successfully!!!');
        notifyListeners();
      } else {
        final dynamic response = httpResponse.statusCode;
        print('Received response statuscode:$response');
        print("HTTP response was null");
      }
    } catch (error) {
      print('Order error when posting data: $error');
      //print('decoded response order screen: ${json.decode(response)}');
      //print('statuscode for order : ${}');
      throw HttpException("Unable to save order!!");
    }
  }
}
