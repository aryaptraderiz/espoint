import 'package:flutter/material.dart';
import '../models/stok.dart';

class StokCard extends StatelessWidget {
  final Stok stok;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const StokCard({super.key, required this.stok, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isWarning = stok.jumlah <= stok.batasMinimum;
    return Card(
      color: isWarning ? Colors.red[50] : null,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        title: Text(stok.nama),
        subtitle: Text('Stok: ${stok.jumlah}, Batas: ${stok.batasMinimum}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isWarning)
              const Icon(Icons.warning, color: Colors.red),
            IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}