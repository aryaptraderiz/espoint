import 'package:flutter/material.dart';

class TransaksiListTile extends StatelessWidget {
  final String productName;
  final int quantity;
  final int totalPrice;
  final String cashier;
  final String date;

  const TransaksiListTile({
    super.key,
    required this.productName,
    required this.quantity,
    required this.totalPrice,
    required this.cashier,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.receipt_long),
      title: Text(productName),
      subtitle: Text("Qty: $quantity • Rp$totalPrice"),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(cashier, style: const TextStyle(fontSize: 12)),
          Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
