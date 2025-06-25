import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/ingredient.dart';

class IngredientProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Ingredient> _items = [];
  bool _isLoading = false;

  List<Ingredient> get items => _items;
  bool get isLoading => _isLoading;

  Future<void> fetchIngredients() async {
    _isLoading = true;
    notifyListeners();

    final snapshot = await _db
        .collection('ingredients')
        .orderBy('createdAt', descending: true)
        .get();

    _items = snapshot.docs.map((doc) {
      return Ingredient.fromMap(doc.id, doc.data());
    }).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addIngredient(Ingredient ingredient) async {
    final docRef = await _db.collection('ingredients').add(ingredient.toMap());
    _items.insert(0, Ingredient(
      id: docRef.id,
      name: ingredient.name,
      stock: ingredient.stock,
      unit: ingredient.unit,
      createdAt: ingredient.createdAt,
    ));
    notifyListeners();
  }

  Future<void> updateIngredient(Ingredient updated) async {
    await _db.collection('ingredients').doc(updated.id).update(updated.toMap());
    final index = _items.indexWhere((i) => i.id == updated.id);
    if (index != -1) {
      _items[index] = updated;
      notifyListeners();
    }
  }

  Future<void> deleteIngredient(String id) async {
    await _db.collection('ingredients').doc(id).delete();
    _items.removeWhere((i) => i.id == id);
    notifyListeners();
  }
}
