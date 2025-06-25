import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<SalesTransaction> _items = [];
  bool _isLoading = false;

  List<SalesTransaction> get items => _items;
  bool get isLoading => _isLoading;

  Future<void> fetchTransactions() async {
    _isLoading = true;
    notifyListeners();
    final snapshot = await _db
        .collection('transactions')
        .orderBy('createdAt', descending: true)
        .get();

    _items = snapshot.docs.map((doc) {
      final data = doc.data();
      return SalesTransaction(
        id: doc.id,
        productName: data['productName'] ?? '',
        quantity: data['quantity'] ?? 0,
        total: data['total'] ?? 0,
        createdAt: (data['createdAt'] as Timestamp).toDate(),
      );
    }).toList();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTransaction(SalesTransaction tx) async {
    final docRef = await _db.collection('transactions').add({
      'productName': tx.productName,
      'quantity': tx.quantity,
      'total': tx.total,
      'createdAt': Timestamp.fromDate(tx.createdAt),
    });
    _items.insert(
      0,
      SalesTransaction(
        id: docRef.id,
        productName: tx.productName,
        quantity: tx.quantity,
        total: tx.total,
        createdAt: tx.createdAt,
      ),
    );
    notifyListeners();
  }

  Future<int> getTotalToday() async {
    final now = DateTime.now();
    final txs = _items.where((tx) =>
    tx.createdAt.year == now.year &&
        tx.createdAt.month == now.month &&
        tx.createdAt.day == now.day);
    return txs.fold<int>(0, (sum, tx) => sum + tx.total);
  }

  Future<int> getTotalThisMonth() async {
    final now = DateTime.now();
    final txs = _items.where((tx) =>
    tx.createdAt.year == now.year &&
        tx.createdAt.month == now.month);
    return txs.fold<int>(0, (sum, tx) => sum + tx.total);
  }
}
