import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final String name;
  final int price;

  const MenuCard({
    super.key,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: const Icon(Icons.local_drink_rounded, color: Colors.orange),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Rp $price"),
      ),
    );
  }
}
