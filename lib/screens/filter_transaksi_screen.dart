import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/transaksi.dart';
import '../providers/transaksi_provider.dart';

class FilterTransaksiScreen extends StatefulWidget {
  const FilterTransaksiScreen({super.key});

  @override
  State<FilterTransaksiScreen> createState() => _FilterTransaksiScreenState();
}

class _FilterTransaksiScreenState extends State<FilterTransaksiScreen> {
  DateTime? mulai;
  DateTime? sampai;

  @override
  Widget build(BuildContext context) {
    final allTransaksi = Provider.of<TransaksiProvider>(context).transaksiList;
    final filtered = allTransaksi.where((t) {
      if (mulai != null && t.tanggal.isBefore(mulai!)) return false;
      if (sampai != null && t.tanggal.isAfter(sampai!)) return false;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Transaksi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _exportFilteredToPdf(filtered),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickDate(context, isMulai: true),
                    icon: const Icon(Icons.date_range),
                    label: Text(mulai == null
                        ? 'Dari Tanggal'
                        : DateFormat('dd/MM/yyyy').format(mulai!)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickDate(context, isMulai: false),
                    icon: const Icon(Icons.date_range),
                    label: Text(sampai == null
                        ? 'Sampai Tanggal'
                        : DateFormat('dd/MM/yyyy').format(sampai!)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('Tidak ada transaksi pada rentang ini.'))
                : ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final t = filtered[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.receipt),
                    title: Text(t.namaMinuman),
                    subtitle: Text('Jumlah: ${t.jumlah} - Rp ${t.totalHarga}'),
                    trailing: Text(DateFormat('dd/MM').format(t.tanggal)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _pickDate(BuildContext context, {required bool isMulai}) async {
    final now = DateTime.now();
    final initial = isMulai ? mulai ?? now : sampai ?? now;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
    );

    if (picked != null) {
      setState(() {
        if (isMulai) {
          mulai = picked;
        } else {
          sampai = picked;
        }
      });
    }
  }

  void _exportFilteredToPdf(List<Transaksi> list) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 0, child: pw.Text('Laporan Filter Transaksi')),
          pw.Table.fromTextArray(
            headers: ['Tanggal', 'Minuman', 'Jumlah', 'Total'],
            data: list.map((t) {
              return [
                DateFormat('dd/MM/yyyy').format(t.tanggal),
                t.namaMinuman,
                '${t.jumlah}',
                'Rp ${t.totalHarga}'
              ];
            }).toList(),
          )
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'laporan_filter_transaksi.pdf',
    );
  }
}
