import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaksi.dart';

class TransaksiService {
  final CollectionReference _trxCollection = FirebaseFirestore.instance.collection('transaksi');

  Future<List<Transaksi>> getAllTransaksi() async {
    final snapshot = await _trxCollection.orderBy('tanggal', descending: true).get();
    return snapshot.docs.map((doc) => Transaksi.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  Future<void> addTransaksi(Transaksi transaksi) async {
    await _trxCollection.add(transaksi.toMap());
  }
}