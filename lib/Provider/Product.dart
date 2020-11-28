import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final double price;
  final String description;
  final String images;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.description,
    @required this.name,
    @required this.price,
    @required this.images,
    this.isFavourite,
  });

  Future<String> getUser() async {
    User userData = FirebaseAuth.instance.currentUser;
    return userData.uid;
  }

  Future<void> toggleFavourite(String id) async {
    isFavourite = !isFavourite;
    final uid = await getUser();
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({id: isFavourite});

    notifyListeners();
  }
}
