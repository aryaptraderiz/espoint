import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class TransaksiScreen extends StatefulWidget {
  const TransaksiScreen({super.key});

  @override
  State<TransaksiScreen> createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  String? selectedProductId;
  int selectedPrice = 0;
  int quantity = 1;
  String cashier = "Admin"; // bisa ambil dari auth nantinya

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transaksi Penjualan")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirestoreService().getProducts(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final products = snapshot.data!.docs;

                return DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Pilih Produk"),
                  items: products.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return DropdownMenuItem<String>(
                      value: doc.id,
                      child: Text(data['name']),
                    );
                  }).toList(),
                  onChanged: (val) {
                    final product = products.firstWhere((d) => d.id == val);
                    final price = (product['price'] as int?) ?? 0;

                    setState(() {
                      selectedProductId = val;
                      selectedPrice = price;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: "Jumlah"),
              keyboardType: TextInputType.number,
              onChanged: (val) {
                quantity = int.tryParse(val) ?? 1;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (selectedProductId == null) return;

                final ref = FirebaseFirestore.instance.collection('products').doc(selectedProductId);
                final snapshot = await ref.get();
                final productName = snapshot['name'];
                final total = selectedPrice * quantity;

                await FirestoreService().addTransaction({
                  'productId': ref,
                  'productName': productName,
                  'quantity': quantity,
                  'totalPrice': total,
                  'cashier': cashier,
                });

                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Transaksi berhasil!")));
              },
              child: const Text("Simpan Transaksi"),
            )
          ],
        ),
      ),
    );
  }
}
