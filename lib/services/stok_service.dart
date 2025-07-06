import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/stok.dart';

class StokService {
  final CollectionReference _stokCollection =
  FirebaseFirestore.instance.collection('stok');

  Future<List<Stok>> getAllStok() async {
    final snapshot = await _stokCollection.get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Stok(
        id: doc.id,
        nama: data['nama'] ?? '',
        jumlah: data['jumlah'] ?? 0,
        batasMinimum: data['batasMinimum'] ?? 0,
      );
    }).toList();
  }

  Future<void> addStok(String nama, int jumlah, int batasMinimum) async {
    await _stokCollection.add({
      'nama': nama,
      'jumlah': jumlah,
      'batasMinimum': batasMinimum,
    });
  }

  Future<void> updateStok(Stok s) async {
    await _stokCollection.doc(s.id).update({
      'nama': s.nama,
      'jumlah': s.jumlah,
      'batasMinimum': s.batasMinimum,
    });
  }

  Future<void> deleteStok(String id) async {
    await _stokCollection.doc(id).delete();
  }
}
