import 'package:flutter/material.dart';
import '../models/transaksi.dart';
import 'package:intl/intl.dart';

class TransaksiTile extends StatelessWidget {
  final Transaksi transaksi;

  const TransaksiTile({super.key, required this.transaksi});

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd MMM yyyy');
    return ListTile(
      title: Text(transaksi.namaMinuman),
      subtitle: Text('${transaksi.jumlah} x = Rp${transaksi.totalHarga}'),
      trailing: Text(formatter.format(transaksi.tanggal)),
    );
  }
}