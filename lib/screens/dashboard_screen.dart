import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';
import '../providers/transaction_provider.dart';
import 'product_screen.dart';
import 'ingredient_screen.dart';
import 'transaction_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late double _monthlyGrowthPercentage = 0.0;
  late double _dailyTransactionGrowth = 0.0;
  late double _customerSatisfaction = 92.0;

  @override
  void initState() {
    super.initState();
    _calculateGrowthMetrics();
  }

  Future<void> _calculateGrowthMetrics() async {
    // In a real app, you would fetch historical data from your backend
    // Here we simulate calculations with dummy data
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _monthlyGrowthPercentage = 12.5; // Example: 12.5% monthly growth
      _dailyTransactionGrowth = 8.3; // Example: 8.3% daily growth
      _customerSatisfaction = 94.2; // Example: 94.2% satisfaction
    });
  }

  String _formatGrowth(double value) {
    return '${value > 0 ? '↑' : value < 0 ? '↓' : '→'} ${value.abs().toStringAsFixed(1)}%';
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: const Color(0xFF6C56F9),
        elevation: 0,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Keluar',
            onPressed: () {
              auth.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C56F9), Color(0xFF8A77FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C56F9).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat datang,',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Role: ${user.role}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.notifications_none, color: Colors.white),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Stats Overview - First Row
              Row(
                children: [
                  Expanded(
                    child: Consumer<ProductProvider>(
                      builder: (context, productProvider, _) => _buildModernStatCard(
                        value: productProvider.items.length.toString(),
                        label: 'Produk Aktif',
                        icon: Icons.local_drink_rounded,
                        color: const Color(0xFF6C56F9),
                        trend: _formatGrowth(_dailyTransactionGrowth),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Consumer<TransactionProvider>(
                      builder: (context, transactionProvider, _) => FutureBuilder<int>(
                        future: transactionProvider.getTotalToday(),
                        builder: (context, snapshot) {
                          final count = snapshot.data ?? 0;
                          return _buildModernStatCard(
                            value: count.toString(),
                            label: 'Transaksi Hari Ini',
                            icon: Icons.shopping_bag_rounded,
                            color: const Color(0xFF00C9A7),
                            trend: _formatGrowth(_dailyTransactionGrowth),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Stats Overview - Second Row
              Row(
                children: [
                  Expanded(
                    child: Consumer<TransactionProvider>(
                      builder: (context, transactionProvider, _) => FutureBuilder<int>(
                        future: transactionProvider.getTotalThisMonth(),
                        builder: (context, snapshot) {
                          final total = snapshot.data ?? 0;
                          return _buildModernStatCard(
                            value: 'Rp ${NumberFormat('#,###').format(total)}',
                            label: 'Penjualan Bulanan',
                            icon: Icons.attach_money_rounded,
                            color: const Color(0xFFFF6B6B),
                            trend: _formatGrowth(_monthlyGrowthPercentage),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildModernStatCard(
                      value: '${_customerSatisfaction.toStringAsFixed(1)}%',
                      label: 'Kepuasan Pelanggan',
                      icon: Icons.sentiment_satisfied_rounded,
                      color: const Color(0xFFFFB84D),
                      trend: _formatGrowth(_customerSatisfaction - 92.0), // Show change from baseline
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Quick Actions Menu
              const Text(
                'Menu Cepat',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  _buildModernActionCard(
                    icon: Icons.add_circle_outline_rounded,
                    title: 'Produk',
                    color: const Color(0xFF6C56F9),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProductScreen()),
                    ),
                  ),
                  _buildModernActionCard(
                    icon: Icons.inventory_rounded,
                    title: 'Bahan Baku',
                    color: const Color(0xFF00C9A7),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const IngredientScreen()),
                    ),
                  ),
                  _buildModernActionCard(
                    icon: Icons.receipt_long_rounded,
                    title: 'Transaksi',
                    color: const Color(0xFFFF6B6B),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TransactionScreen()),
                    ),
                  ),
                  _buildModernActionCard(
                    icon: Icons.analytics_rounded,
                    title: 'Analisis',
                    color: const Color(0xFFFFB84D),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur Analisis akan segera hadir!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Recent Activity Section
              const Text(
                'Aktivitas Terkini',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 16),
              _buildActivityItem(
                icon: Icons.shopping_bag_rounded,
                color: const Color(0xFF6C56F9),
                title: 'Pesanan baru #1234',
                subtitle: '2 menit lalu',
              ),
              _buildActivityItem(
                icon: Icons.inventory_rounded,
                color: const Color(0xFF00C9A7),
                title: 'Stok hampir habis',
                subtitle: '30 menit lalu',
              ),
              _buildActivityItem(
                icon: Icons.local_drink_rounded,
                color: const Color(0xFFFF6B6B),
                title: 'Produk baru ditambahkan',
                subtitle: '2 jam lalu',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernStatCard({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
    required String trend,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: color,
                  ),
                ),
                const Spacer(),
                Text(
                  trend,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: trend.startsWith('↑')
                        ? Colors.green
                        : trend.startsWith('↓')
                        ? Colors.red
                        : Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 24,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
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
              size: 20,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }
}