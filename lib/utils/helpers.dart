import 'package:flutter/material.dart';

class Helpers {
  static void showSnackbar(BuildContext context, String message, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: color ?? Colors.black87,
      duration: const Duration(seconds: 2),
    ));
  }

  static String formatCurrency(int amount) {
    return "Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => "${m[1]}.")}";
  }
}
