import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/product.dart';
import '../models/transaction.dart';
import '../providers/product_provider.dart';
import '../providers/transaction_provider.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  Product? _selectedProduct;
  final _qtyCtrl = TextEditingController();
  final _dateFormat = DateFormat('dd MMM yyyy');
  final _timeFormat = DateFormat('HH:mm');
  final _monthFormat = DateFormat('MMMM yyyy');

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    await Provider.of<TransactionProvider>(context, listen: false).fetchTransactions();
  }

  Future<void> _showAddDialog() async {
    _selectedProduct = null;
    _qtyCtrl.clear();

    await showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tambah Transaksi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple[800],
                ),
              ),
              const SizedBox(height: 20),
              Consumer<ProductProvider>(
                builder: (context, productProvider, _) {
                  final products = productProvider.items;
                  return DropdownButtonFormField<Product>(
                    value: _selectedProduct,
                    items: products.map((p) {
                      return DropdownMenuItem(
                        value: p,
                        child: Text(
                          p.name,
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedProduct = val),
                    decoration: InputDecoration(
                      labelText: 'Pilih Produk',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _qtyCtrl,
                decoration: InputDecoration(
                  labelText: 'Jumlah',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final qty = int.tryParse(_qtyCtrl.text) ?? 0;
                        if (_selectedProduct == null || qty <= 0) return;

                        final total = _selectedProduct!.price * qty;
                        final newTx = SalesTransaction(
                          id: '',
                          productId: _selectedProduct!.id,
                          productName: _selectedProduct!.name,
                          quantity: qty,
                          total: total,
                          createdAt: DateTime.now(),
                        );

                        await Provider.of<TransactionProvider>(context, listen: false)
                            .addTransaction(newTx);
                        if (mounted) Navigator.pop(context);
                      },
                      child: const Text(
                        'Simpan',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showEditDialog(SalesTransaction tx) async {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final products = productProvider.items;

    _selectedProduct = products.firstWhere((p) => p.id == tx.productId);
    _qtyCtrl.text = tx.quantity.toString();

    await showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit Transaksi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple[800],
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<Product>(
                value: _selectedProduct,
                items: products.map((p) {
                  return DropdownMenuItem(
                    value: p,
                    child: Text(
                      p.name,
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedProduct = val),
                decoration: InputDecoration(
                  labelText: 'Produk',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _qtyCtrl,
                decoration: InputDecoration(
                  labelText: 'Jumlah',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        await Provider.of<TransactionProvider>(context, listen: false)
                            .deleteTransaction(tx.id);
                        if (mounted) Navigator.pop(context);
                      },
                      child: const Text(
                        'Hapus',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        final qty = int.tryParse(_qtyCtrl.text) ?? 0;
                        if (_selectedProduct == null || qty <= 0) return;

                        final updatedTx = SalesTransaction(
                          id: tx.id,
                          productId: _selectedProduct!.id,
                          productName: _selectedProduct!.name,
                          quantity: qty,
                          total: _selectedProduct!.price * qty,
                          createdAt: tx.createdAt,
                        );

                        await Provider.of<TransactionProvider>(context, listen: false)
                            .updateTransaction(updatedTx);
                        if (mounted) Navigator.pop(context);
                      },
                      child: const Text(
                        'Simpan',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<BarChartGroupData>> _generateChartData() async {
    final txs = Provider.of<TransactionProvider>(context, listen: false).items;
    final now = DateTime.now();
    final days = List.generate(7, (i) => DateTime(now.year, now.month, now.day - i));

    return List.generate(7, (i) {
      final day = days[6 - i];
      final total = txs
          .where((tx) =>
      tx.createdAt.year == day.year &&
          tx.createdAt.month == day.month &&
          tx.createdAt.day == day.day)
          .fold<int>(0, (sum, tx) => sum + tx.total);

      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: total.toDouble(),
            width: 20,
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: total.toDouble() * 1.2,
              color: Colors.grey[200],
            ),
          ),
        ],
      );
    });
  }

  Future<void> _generateAndExportPdf() async {
    final txProvider = Provider.of<TransactionProvider>(context, listen: false);
    final txs = txProvider.items;
    final now = DateTime.now();
    final monthName = _monthFormat.format(now);

    final pdf = pw.Document();

    // Get the future values before building the PDF
    final todayTotal = await txProvider.getTotalToday();
    final monthTotal = await txProvider.getTotalThisMonth();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Laporan Transaksi',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    'Bulan: $monthName',
                    style: const pw.TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            pw.Row(
              children: [
                _buildPdfStatCard(
                  title: 'Total Hari Ini',
                  value: todayTotal,
                ),
                pw.SizedBox(width: 10),
                _buildPdfStatCard(
                  title: 'Total Bulan Ini',
                  value: monthTotal,
                ),
              ],
            ),
            pw.SizedBox(height: 20),

            pw.Text(
              'Daftar Transaksi',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 10),

            pw.Table.fromTextArray(
              context: context,
              border: null,
              cellAlignment: pw.Alignment.centerLeft,
              headerDecoration: pw.BoxDecoration(
                color: PdfColors.grey300,
              ),
              headerHeight: 25,
              cellHeight: 30,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.center,
                2: pw.Alignment.center,
                3: pw.Alignment.centerRight,
                4: pw.Alignment.center,
              },
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 12,
              ),
              cellStyle: const pw.TextStyle(fontSize: 10),
              headers: ['Produk', 'Qty', 'Harga', 'Total', 'Tanggal'],
              data: txs.map((tx) {
                return [
                  tx.productName,
                  tx.quantity.toString(),
                  'Rp ${(tx.total ~/ tx.quantity).toString()}',
                  'Rp ${tx.total.toString()}',
                  _dateFormat.format(tx.createdAt),
                ];
              }).toList(),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  pw.Widget _buildPdfStatCard({
    required String title,
    required int value,
  }) {
    return pw.Container(
      width: 250,
      height: 60,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey600,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'Rp $value',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required Future<int> value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FutureBuilder<int>(
        future: value,
        builder: (context, snapshot) {
          return Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    snapshot.hasData ? 'Rp ${snapshot.data}' : '...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final txProvider = Provider.of<TransactionProvider>(context);
    final txs = txProvider.items;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Transaksi Penjualan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
            onPressed: _generateAndExportPdf,
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: _showAddDialog,
          ),
        ],
      ),
      body: txProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.today,
                    title: 'Hari Ini',
                    value: txProvider.getTotalToday(),
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.calendar_month,
                    title: 'Bulan Ini',
                    value: txProvider.getTotalThisMonth(),
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Penjualan 7 Hari Terakhir',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 200,
                    child: FutureBuilder<List<BarChartGroupData>>(
                      future: _generateChartData(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        return BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            barTouchData: BarTouchData(
                              enabled: true,
                              touchTooltipData: BarTouchTooltipData(
                                tooltipBgColor: Colors.deepPurple,
                                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                  return BarTooltipItem(
                                    'Rp ${rod.toY.toInt()}',
                                    const TextStyle(color: Colors.white),
                                  );
                                },
                              ),
                            ),
                            barGroups: snapshot.data!,
                            gridData: FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      'Rp ${value.toInt()}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    const labels = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(
                                        labels[value.toInt()],
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadData,
                child: ListView.separated(
                  itemCount: txs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final tx = txs[i];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.receipt,
                            color: Colors.deepPurple[400],
                          ),
                        ),
                        title: Text(
                          tx.productName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              '${tx.quantity} x Rp ${tx.total ~/ tx.quantity}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              _dateFormat.format(tx.createdAt),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Rp ${tx.total}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple[800],
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              _timeFormat.format(tx.createdAt),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                        onTap: () => _showEditDialog(tx),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}