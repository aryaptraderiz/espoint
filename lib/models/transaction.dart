import 'package:cloud_firestore/cloud_firestore.dart';

class SalesTransaction {
  final String id;
  final String productId;
  final String productName;
  final int quantity;
  final int total;
  final DateTime createdAt;

  SalesTransaction({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.total,
    required this.createdAt,
  });

  factory SalesTransaction.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SalesTransaction(
      id: doc.id,
      productId: data['productId'] ?? '',
      productName: data['productName'] ?? '',
      quantity: data['quantity'] ?? 0,
      total: data['total'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'total': total,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}