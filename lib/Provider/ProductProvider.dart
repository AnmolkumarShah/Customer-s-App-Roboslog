import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../Provider/Product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _items = [];

  void delete(dynamic id) {
    FirebaseFirestore.instance.collection('products').doc(id).delete();
  }

  List<Product> get items {
    return [..._items];
  }

  Future<String> getUserId() async {
    User userData = FirebaseAuth.instance.currentUser;
    return userData.uid;
  }

  Future<void> getAndSetProducts() async {
    try {
      final uid = await getUserId();
      final res = await FirebaseFirestore.instance.collection('products').get();
      final fav =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      List<Product> fetchedItems = res.docs
          .map(
            (e) => Product(
              id: e.id,
              description: e['description'],
              name: e['name'],
              price: e['price'],
              images: e['imageUrl'],
              isFavourite:
                  fav.data().containsKey(e.id) ? fav.data()[e.id] : false,
            ),
          )
          .toList();

      _items = fetchedItems;
    } catch (error) {
      throw (error);
    }
  }

  List<Product> get favProducts {
    return _items.where((element) => element.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<Map<String, dynamic>> getUser() async {
    User userData = FirebaseAuth.instance.currentUser;
    final res = await FirebaseFirestore.instance
        .collection('users')
        .doc(userData.uid)
        .get();

    return res.data();
  }

  Future<void> updateUsers(
    String username,
    String password,
    File image,
    BuildContext context,
    String email,
    String oldpass,
    String addr1,
    String addr2,
    String state,
    String pincode,
  ) async {
    User userData = FirebaseAuth.instance.currentUser;
    final data = await getUser();
    var urlNew;

    if (image != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('users_image')
          .child(userData.uid + '.jpg');

      await ref.putFile(image).onComplete;

      urlNew = await ref.getDownloadURL();
    } else {
      urlNew = data['image_url'];
    }

    await FirebaseFirestore.instance.collection('users').doc(userData.uid)
        // .collection('details')
        // .doc('info')
        .update(
      {
        'image_url': urlNew,
        'username': username,
        'password': password,
        'email': data['email'],
        'addr1': addr1,
        'addr2': addr2,
        'state': state,
        'pincode': pincode,
      },
    );
    // Phoenix.rebirth(context);
    // if (password != null) {
    //   User userData = FirebaseAuth.instance.currentUser;
    //   try {
    //     await userData.reauthenticateWithCredential(
    //       EmailAuthProvider.credential(
    //         email: email,
    //         password: oldpass,
    //       ),
    //     );
    //     await userData.updatePassword(password);
    //     print(password);
    //   } catch (err) {
    //     throw err;
    //   }
    // }
    notifyListeners();
  }

  Future<Map<String, dynamic>> maxItemCount() async {
    final res = await FirebaseFirestore.instance
        .collection('adminData')
        .doc("TSB06dHQbdvE2swBISrQ")
        .get();
    final Map<String, dynamic> data = res.data();
    return data;
    notifyListeners();
  }

  Future<void> addProduct(Product newProd) async {
    print(newProd.name);
    final generatedId =
        await FirebaseFirestore.instance.collection('products').add({
      'name': newProd.name,
      'price': newProd.price,
      'description': newProd.description,
      'imageUrl': newProd.images,
    });
    _items.add(Product(
      id: generatedId.toString(),
      description: newProd.description,
      name: newProd.name,
      price: newProd.price,
      images: newProd.images,
    ));
    notifyListeners();
  }
}
