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
    final now = DateTime.now();
    final productWithTimestamps = Product(
      id: '',
      name: product.name,
      description: product.description,
      imageUrl: product.imageUrl,
      price: product.price,
      createdAt: now,
      lastEditedAt: now,  // Set both timestamps to now for new product
    );

    final docRef = await _db.collection('products').add(productWithTimestamps.toMap());
    _items.insert(0, Product(
      id: docRef.id,
      name: productWithTimestamps.name,
      description: productWithTimestamps.description,
      imageUrl: productWithTimestamps.imageUrl,
      price: productWithTimestamps.price,
      createdAt: productWithTimestamps.createdAt,
      lastEditedAt: productWithTimestamps.lastEditedAt,
    ));
    notifyListeners();
  }

  Future<void> updateProduct(Product updated) async {
    final now = DateTime.now();
    final updatedWithTimestamp = Product(
      id: updated.id,
      name: updated.name,
      description: updated.description,
      imageUrl: updated.imageUrl,
      price: updated.price,
      createdAt: updated.createdAt,
      lastEditedAt: now,  // Update the lastEditedAt timestamp
    );

    await _db.collection('products').doc(updated.id).update(updatedWithTimestamp.toMap());
    final index = _items.indexWhere((p) => p.id == updated.id);
    if (index != -1) {
      _items[index] = updatedWithTimestamp;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    await _db.collection('products').doc(id).delete();
    _items.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}