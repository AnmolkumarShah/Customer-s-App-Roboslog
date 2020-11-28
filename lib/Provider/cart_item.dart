import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';

class CartItem with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem({
    @required this.id,
    @required this.price,
    @required this.quantity,
    @required this.title,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  Future<String> getUser() async {
    User userData = FirebaseAuth.instance.currentUser;
    return userData.uid;
  }

  int get itemCount {
    return _items.length == null ? 0 : _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addItem(String prodId, double price, String title) {
    if (_items.containsKey(prodId)) {
      _items.update(
        prodId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
          title: existingCartItem.title,
        ),
      );
    } else {
      _items.putIfAbsent(prodId, () {
        return CartItem(
          id: DateTime.now().toString(),
          quantity: 1,
          title: title,
          price: price,
        );
      });
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String productKey) {
    print(productKey);
    if (!_items.containsKey(productKey)) {
      return;
    }
    if (_items[productKey].quantity > 1) {
      _items.update(
        productKey,
        (existingProduct) => CartItem(
          id: existingProduct.id,
          price: existingProduct.price,
          quantity: existingProduct.quantity - 1,
          title: existingProduct.title,
        ),
      );
    } else {
      _items.remove(productKey);
    }
    notifyListeners();
  }

  void deleteItem(String id) {
    _items.remove(id);
    notifyListeners();
  }
}
