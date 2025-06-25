import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 🔽 Tambah transaksi
  Future<void> addTransaction(Map<String, dynamic> data) async {
    await _db.collection('transactions').add({
      ...data,
      'date': FieldValue.serverTimestamp(),
    });
  }

  // 🔽 Ambil semua produk
  Stream<QuerySnapshot> getProducts() {
    return _db.collection('products').orderBy('createdAt', descending: true).snapshots();
  }

  // 🔽 Tambah produk baru
  Future<void> addProduct(String name, int price) async {
    await _db.collection('products').add({
      'name': name,
      'price': price,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // 🔽 Update stok bahan
  Future<void> updateStock(String ingredientId, int newStock) async {
    await _db.collection('ingredients').doc(ingredientId).update({
      'stock': newStock,
    });
  }

  // 🔽 Get stok menipis
  Stream<QuerySnapshot> getLowStockIngredients() {
    return _db
        .collection('ingredients')
        .where('stock', isLessThanOrEqualTo: FieldPath.documentId)
        .snapshots();
  }
}
