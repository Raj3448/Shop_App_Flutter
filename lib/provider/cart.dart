import 'package:flutter/foundation.dart';

class CartItem {
  String id;
  String title;
  double price;
  int quantity;

  CartItem(
      {required this.id,
      required this.title,
      required this.price,
      required this.quantity});
}

class Cart with ChangeNotifier {
  bool toggle = false;

  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCounts {
    print(_items.length);
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((_, CartItem value) {
      total = total + value.price * value.quantity;
    });
    return total;
  }

  void addItem(String ProductId, double Price, String Title) {
    toggle = true;
    if (_items.containsKey(ProductId)) {
      _items.update(
          ProductId,
          (existingCart) => CartItem(
              id: existingCart.id,
              title: existingCart.title,
              price: existingCart.price,
              quantity: existingCart.quantity + 1));
    } else {
      _items.putIfAbsent(
          ProductId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: Title,
              price: Price,
              quantity: 1));
    }
    notifyListeners();
  }

  void removeItem(String ProductId) {
    _items.remove(ProductId);
    notifyListeners();
  }

  void OrderPush() {
    _items.clear();
    toggle = false;
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    } else if (_items[productId]!.quantity > 1) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity - 1));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }
}
