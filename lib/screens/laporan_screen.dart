import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LaporanScreen extends StatelessWidget {
  const LaporanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(title: const Text("Laporan Penjualan")),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('transactions').orderBy('date').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          // 🔢 Buat map {tanggal : totalPenjualan}
          final Map<String, int> totalPerDay = {};

          for (var doc in docs) {
            final trx = doc.data() as Map<String, dynamic>;
            final timestamp = trx['date'] as Timestamp?;
            final total = trx['totalPrice'] is int
                ? trx['totalPrice'] as int
                : int.tryParse(trx['totalPrice'].toString()) ?? 0;

            if (timestamp != null) {
              final dateStr = DateFormat('dd/MM').format(timestamp.toDate());
              totalPerDay[dateStr] = (totalPerDay[dateStr] ?? 0) + total;
            }
          }

          final sortedKeys = totalPerDay.keys.toList()..sort();

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text("Grafik Penjualan Harian", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                SizedBox(
                  height: 250,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true, interval: 10000),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final index = value.toInt();
                              if (index < 0 || index >= sortedKeys.length) return const Text('');
                              return Text(sortedKeys[index], style: const TextStyle(fontSize: 10));
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(sortedKeys.length, (index) {
                        final key = sortedKeys[index];
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: totalPerDay[key]!.toDouble(),
                              color: Colors.indigo,
                              width: 18,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),
                const Text("Daftar Transaksi"),
                Expanded(
                  child: ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final trx = docs[index];
                      return ListTile(
                        leading: const Icon(Icons.receipt),
                        title: Text(trx['productName']),
                        subtitle: Text("Qty: ${trx['quantity']} | Rp${trx['totalPrice']}"),
                        trailing: Text(DateFormat('dd MMM').format((trx['date'] as Timestamp).toDate())),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
