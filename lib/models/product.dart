import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String? description;
  final String imageUrl;
  final int price;
  final DateTime createdAt;
  final DateTime lastEditedAt;  // Add this line

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.imageUrl,
    required this.price,
    required this.createdAt,
    required this.lastEditedAt,  // Add this line
  });

  factory Product.fromMap(String id, Map<String, dynamic> data) {
    return Product(
      id: id,
      name: data['name'] ?? '',
      description: data['description'],
      imageUrl: data['imageUrl'] ?? '',
      price: data['price'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastEditedAt: (data['lastEditedAt'] as Timestamp?)?.toDate() ??  // Add this line
          (data['createdAt'] as Timestamp).toDate(),  // Default to createdAt if not exists
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastEditedAt': Timestamp.fromDate(lastEditedAt),  // Add this line
    };
  }
}