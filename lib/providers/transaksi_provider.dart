import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransaksiProvider with ChangeNotifier {
  final List<SaleTransaction> _transactions = [];

  List<SaleTransaction> get transactions => _transactions;

  Future<void> fetchTransactions() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('transactions')
        .orderBy('date', descending: true)
        .get();

    _transactions.clear();
    for (var doc in snapshot.docs) {
      _transactions.add(SaleTransaction.fromFirestore(doc.id, doc.data()));
    }
    notifyListeners();
  }

  Future<void> addTransaction(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection('transactions').add(data);
    await fetchTransactions();
  }
}
