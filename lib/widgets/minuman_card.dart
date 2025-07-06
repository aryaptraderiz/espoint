import 'package:flutter/material.dart';
import '../models/minuman.dart';

class MinumanCard extends StatelessWidget {
  final Minuman minuman;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MinumanCard({super.key, required this.minuman, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        title: Text(minuman.nama),
        subtitle: Text('Harga: Rp${minuman.harga}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
