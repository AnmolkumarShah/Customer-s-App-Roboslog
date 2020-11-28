import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import './cart_item.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  final bool accepted;
  final bool rejected;
  final bool dispatched;
  final DateTime expectedDelivery;

  OrderItem({
    @required this.amount,
    @required this.dateTime,
    @required this.id,
    @required this.products,
    this.accepted,
    this.rejected,
    this.expectedDelivery,
    this.dispatched,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _item = [];

  List<OrderItem> get item {
    return [..._item];
  }

  Future<String> getUser() async {
    User userData = FirebaseAuth.instance.currentUser;
    return userData.uid;
  }

  Future<void> getAndSetOrders() async {
    try {
      final uid = await getUser();
      final res = await FirebaseFirestore.instance
          .collection('orders')
          .doc(uid)
          .collection('user_orders')
          .get();
      List<OrderItem> fetchedItems = res.docs
          .map(
            (e) => OrderItem(
              amount: e['amount'],
              dateTime: DateTime.parse(e['dateTime']),
              id: e.id,
              accepted: e['accepted'],
              rejected: e['rejected'],
              dispatched: e['dispatched'],
              expectedDelivery: e['expectedDelivery'] != null
                  ? DateTime.parse((e['expectedDelivery']))
                  : null,
              products: (e['products'] as List<dynamic>)
                  .map(
                    (data) => CartItem(
                      id: data['id'],
                      price: data['price'],
                      quantity: data['quantity'],
                      title: data['title'],
                    ),
                  )
                  .toList(),
            ),
          )
          .toList();

      _item = fetchedItems;
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addItem(List<CartItem> cartProducts, double total) async {
    final uid = await getUser();

    final generatedId = await FirebaseFirestore.instance
        .collection('orders')
        .doc(uid)
        .collection('user_orders')
        .add({
      'amount': total,
      'dateTime': DateTime.now().toIso8601String(),
      'accepted': null,
      'rejected': null,
      'expectedDelivery': null,
      'dispatched': null,
      'products': cartProducts
          .map((e) => {
                'user_id': uid,
                'id': e.id,
                'title': e.title,
                'quantity': e.quantity,
                'price': e.price,
              })
          .toList(),
    });

    await FirebaseFirestore.instance.collection('orders_all').add({
      'amount': total,
      'dateTime': DateTime.now().toIso8601String(),
      'user_id': uid,
      'order_id': generatedId.id.toString(),
      'accepted': null,
      'rejected': null,
      'expectedDelivery': null,
      'dispatched': null,
      'products': cartProducts
          .map((e) => {
                'id': e.id,
                'title': e.title,
                'quantity': e.quantity,
                'price': e.price,
              })
          .toList(),
    });

    _item.insert(
      0,
      OrderItem(
        amount: total,
        dateTime: DateTime.now(),
        id: generatedId.toString(),
        products: cartProducts,
        accepted: null,
        expectedDelivery: null,
        rejected: null,
        dispatched: null,
      ),
    );
    notifyListeners();
  }
}
