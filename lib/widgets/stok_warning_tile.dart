import 'package:flutter/material.dart';

class StokWarningTile extends StatelessWidget {
  final String name;
  final int stock;
  final String unit;
  final bool isLow;

  const StokWarningTile({
    super.key,
    required this.name,
    required this.stock,
    required this.unit,
    required this.isLow,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isLow ? Colors.red[50] : Colors.white,
      child: ListTile(
        leading: const Icon(Icons.inventory_2),
        title: Text(name),
        subtitle: Text("Sisa stok: $stock $unit"),
        trailing: isLow
            ? const Icon(Icons.warning_amber, color: Colors.red)
            : const Icon(Icons.check_circle, color: Colors.green),
      ),
    );
  }
}
