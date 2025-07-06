import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../providers/transaksi_provider.dart';
import '../models/transaksi.dart';

class GrafikScreen extends StatelessWidget {
  const GrafikScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transaksiList = Provider.of<TransaksiProvider>(context).transaksiList;

    // Kelompokkan transaksi per tanggal
    final Map<String, int> jumlahPerTanggal = {};
    for (var trx in transaksiList) {
      final tgl = DateFormat('dd/MM').format(trx.tanggal);
      jumlahPerTanggal[tgl] = (jumlahPerTanggal[tgl] ?? 0) + trx.jumlah;
    }

    final tanggalList = jumlahPerTanggal.keys.toList();
    final maxJumlah = jumlahPerTanggal.values.fold<int>(0, (a, b) => a > b ? a : b);

    return Scaffold(
      appBar: AppBar(title: const Text('Grafik Penjualan')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Jumlah Minuman Terjual per Hari',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxJumlah + 5,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 32),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          final idx = value.toInt();
                          return Text(
                            idx < tanggalList.length ? tanggalList[idx] : '',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: List.generate(tanggalList.length, (i) {
                    final tgl = tanggalList[i];
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: jumlahPerTanggal[tgl]!.toDouble(),
                          color: Colors.teal,
                          width: 16,
                        )
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}