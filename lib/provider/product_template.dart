import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as _HTTP;
import '/models/HttpException.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  late bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleIsFavorite() async {
    bool oldVal = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final Uri url = Uri(
      scheme: 'https',
      host: 'flutterdemo-8d638-default-rtdb.firebaseio.com',
      path: '/Product/$id.json',
    );

    try {
      final response = await _HTTP.patch(url,
          body: json.encode({
            'isFavorite': isFavorite,
          }));
      if (response.statusCode >= 400) {
        isFavorite = oldVal;
        notifyListeners();
        throw HttpException(
            "${response.statusCode}Favorite status could not be updated");
      }
    } catch (error) {
      isFavorite = oldVal;
      notifyListeners();
      throw HttpException("Favorite status could not be updated....");
    }
  }
}
