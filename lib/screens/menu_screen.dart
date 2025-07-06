import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../utils/helpers.dart';
import '../utils/date_formatter.dart';
import '../widgets/menu_card.dart';
import '../widgets/custom_appbar.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();

    void showAddDialog() {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Tambah Menu Minuman"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Nama Minuman"),
              ),
              TextField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Harga"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final name = nameCtrl.text.trim();
                final price = int.tryParse(priceCtrl.text.trim()) ?? 0;

                if (name.isEmpty || price <= 0) {
                  Helpers.showSnackbar(context, "Nama dan harga harus diisi!", color: Colors.red);
                  return;
                }

                await FirestoreService().addProduct(name, price);
                Navigator.pop(context);
                Helpers.showSnackbar(context, "Menu berhasil ditambahkan!");
                nameCtrl.clear();
                priceCtrl.clear();
              },
              child: const Text("Simpan"),
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(title: "Menu Minuman"),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService().getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(child: Text("Belum ada menu minuman"));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final name = data['name'] ?? '';
              final price = data['price'] ?? 0;

              return MenuCard(
                name: name,
                price: price,
              );
            },
          );
        },
      ),
    );
  }
}
