import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Product> _items = [];
  bool _isLoading = false;

  List<Product> get items => _items;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    final snapshot = await _db
        .collection('products')
        .orderBy('createdAt', descending: true)
        .get();

    _items = snapshot.docs.map((doc) {
      return Product.fromMap(doc.id, doc.data());
    }).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final docRef = await _db.collection('products').add(product.toMap());
    _items.insert(0, Product(
      id: docRef.id,
      name: product.name,
      description: product.description,
      imageUrl: product.imageUrl,
      price: product.price,
      createdAt: product.createdAt,
    ));
    notifyListeners();
  }

  Future<void> updateProduct(Product updated) async {
    await _db.collection('products').doc(updated.id).update(updated.toMap());
    final index = _items.indexWhere((p) => p.id == updated.id);
    if (index != -1) {
      _items[index] = updated;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    await _db.collection('products').doc(id).delete();
    _items.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
