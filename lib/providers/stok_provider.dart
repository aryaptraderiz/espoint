import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/ingredient.dart';

class StokProvider with ChangeNotifier {
  final List<Ingredient> _ingredients = [];

  List<Ingredient> get ingredients => _ingredients;

  Future<void> fetchIngredients() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('ingredients')
        .orderBy('stock')
        .get();

    _ingredients.clear();
    for (var doc in snapshot.docs) {
      _ingredients.add(Ingredient.fromFirestore(doc.id, doc.data()));
    }
    notifyListeners();
  }

  Future<void> updateStock(String id, int newStock) async {
    await FirebaseFirestore.instance
        .collection('ingredients')
        .doc(id)
        .update({'stock': newStock});
    await fetchIngredients();
  }
}
