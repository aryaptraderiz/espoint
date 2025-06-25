import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';

class MenuProvider with ChangeNotifier {
  final List<Product> _menus = [];

  List<Product> get menus => _menus;

  Future<void> fetchMenus() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .orderBy('createdAt', descending: true)
        .get();

    _menus.clear();
    for (var doc in snapshot.docs) {
      _menus.add(Product.fromFirestore(doc.id, doc.data()));
    }
    notifyListeners();
  }

  Future<void> addMenu(String name, int price) async {
    await FirebaseFirestore.instance.collection('products').add({
      'name': name,
      'price': price,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await fetchMenus();
  }
}
