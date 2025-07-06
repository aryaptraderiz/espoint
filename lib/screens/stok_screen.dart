import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/stok_warning_tile.dart';
import '../services/notification_service.dart';

class StokScreen extends StatelessWidget {
  const StokScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;

    return Scaffold(
      appBar: const CustomAppBar(title: "Stok Bahan Baku"),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('ingredients').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final data = snapshot.data!.docs;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              final stok = item['stock'] ?? 0;
              final min = item['minStock'] ?? 0;
              final isLow = stok <= min;

              // Tampilkan notifikasi hanya jika stok menipis
              if (isLow) {
                NotificationService.showStockWarning(item['name']);
              }

              return StokWarningTile(
                name: item['name'],
                stock: stok,
                unit: item['unit'],
                isLow: isLow,
              );
            },
          );
        },
      ),
    );
  }
}
