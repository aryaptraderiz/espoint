import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/minuman.dart';

class MinumanService {
  final CollectionReference _minumanCollection =
  FirebaseFirestore.instance.collection('minuman');

  Future<List<Minuman>> getAllMinuman() async {
    final snapshot = await _minumanCollection.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Minuman(
        id: doc.id,
        nama: data['nama'] ?? '',
        harga: data['harga'] ?? 0,
      );
    }).toList();
  }

  Future<void> addMinuman(String nama, int harga) async {
    await _minumanCollection.add({
      'nama': nama,
      'harga': harga,
    });
  }

  Future<void> updateMinuman(Minuman m) async {
    await _minumanCollection.doc(m.id).update({
      'nama': m.nama,
      'harga': m.harga,
    });
  }

  Future<void> deleteMinuman(String id) async {
    await _minumanCollection.doc(id).delete();
  }
}
