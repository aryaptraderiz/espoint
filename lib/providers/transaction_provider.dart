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

    try {
      final snapshot = await _db
          .collection('transactions')
          .orderBy('createdAt', descending: true)
          .get();

      _items = snapshot.docs.map((doc) {
        return SalesTransaction.fromFirestore(doc);
      }).toList();
    } catch (e) {
      debugPrint('Error fetching transactions: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTransaction(SalesTransaction tx) async {
    try {
      final docRef = await _db.collection('transactions').add(tx.toMap());
      _items.insert(0, SalesTransaction(
        id: docRef.id,
        productId: tx.productId,
        productName: tx.productName,
        quantity: tx.quantity,
        total: tx.total,
        createdAt: tx.createdAt,
      ));
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding transaction: $e');
      rethrow;
    }
  }

  Future<void> updateTransaction(SalesTransaction updated) async {
    try {
      await _db.collection('transactions').doc(updated.id).update(updated.toMap());
      final index = _items.indexWhere((tx) => tx.id == updated.id);
      if (index != -1) {
        _items[index] = updated;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating transaction: $e');
      rethrow;
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await _db.collection('transactions').doc(id).delete();
      _items.removeWhere((tx) => tx.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting transaction: $e');
      rethrow;
    }
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