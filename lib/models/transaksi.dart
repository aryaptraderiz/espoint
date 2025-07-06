import 'package:cloud_firestore/cloud_firestore.dart';

class Transaksi {
  final String id;
  final String minumanId;
  final String namaMinuman;
  final int jumlah;
  final int totalHarga;
  final DateTime tanggal;

  Transaksi({
    required this.id,
    required this.minumanId,
    required this.namaMinuman,
    required this.jumlah,
    required this.totalHarga,
    required this.tanggal,
  });

  factory Transaksi.fromMap(Map<String, dynamic> data, String docId) {
    return Transaksi(
      id: docId,
      minumanId: data['minumanId'] ?? '',
      namaMinuman: data['namaMinuman'] ?? '',
      jumlah: data['jumlah'] ?? 0,
      totalHarga: data['totalHarga'] ?? 0,
      tanggal: (data['tanggal'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'minumanId': minumanId,
      'namaMinuman': namaMinuman,
      'jumlah': jumlah,
      'totalHarga': totalHarga,
      'tanggal': Timestamp.fromDate(tanggal),
    };
  }
}
