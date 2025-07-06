import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F7FA),
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.teal.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.teal.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 32, color: Colors.teal),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Selamat Datang 👋", style: TextStyle(fontSize: 16)),
                        SizedBox(height: 4),
                        Text("Aplikasi esPoint", style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Grid Menu
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              children: [
                _MenuCard(
                  icon: Icons.local_cafe,
                  label: 'Menu Minuman',
                  color: Colors.orange.shade100,
                  onTap: () => Navigator.pushNamed(context, '/menu'),
                ),
                _MenuCard(
                  icon: Icons.inventory_2,
                  label: 'Stok Bahan',
                  color: Colors.purple.shade100,
                  onTap: () => Navigator.pushNamed(context, '/stok'),
                ),
                _MenuCard(
                  icon: Icons.receipt_long,
                  label: 'Transaksi',
                  color: Colors.green.shade100,
                  onTap: () => Navigator.pushNamed(context, '/transaksi'),
                ),
                _MenuCard(
                  icon: Icons.bar_chart,
                  label: 'Grafik Penjualan',
                  color: Colors.blue.shade100,
                  onTap: () => Navigator.pushNamed(context, '/grafik'),
                ),
                _MenuCard(
                  icon: Icons.filter_alt_outlined,
                  label: 'Filter Transaksi',
                  color: Colors.grey.shade200,
                  onTap: () => Navigator.pushNamed(context, '/filter-transaksi'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.black87),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
