import 'package:cloud_firestore/cloud_firestore.dart';

class Ingredient {
  final String id;
  final String name;
  final int stock;
  final String unit;
  final DateTime createdAt;

  Ingredient({
    required this.id,
    required this.name,
    required this.stock,
    required this.unit,
    required this.createdAt,
  });

  factory Ingredient.fromMap(String id, Map<String, dynamic> data) {
    return Ingredient(
      id: id,
      name: data['name'] ?? '',
      stock: data['stock'] ?? 0,
      unit: data['unit'] ?? 'pcs',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'stock': stock,
      'unit': unit,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
