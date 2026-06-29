import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/transaction.dart';
import '../providers/transaction_provider.dart';
import '../utils/snackbar_helper.dart';
import 'tracking_page.dart';
import 'history_detail_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Riwayat Penyewaan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: "Berlangsung"),
            Tab(text: "Selesai"),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<TransactionProvider>().fetchTransactions();
            },
          ),
        ],
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, txProvider, _) {
          if (txProvider.state == TransactionState.loading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
            );
          }

          if (txProvider.state == TransactionState.error) {
            return _buildErrorState(txProvider);
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildTransactionList(txProvider.ongoingTransactions, true),
              _buildTransactionList(txProvider.completedTransactions, false),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTransactionList(
    List<TransactionModel> transactions,
    bool isOngoing,
  ) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isOngoing ? Icons.hourglass_empty : Icons.check_circle_outline,
              size: 70,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              isOngoing
                  ? "Tidak ada penyewaan aktif"
                  : "Belum ada penyewaan selesai",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFF2E7D32),
      onRefresh: () => context.read<TransactionProvider>().fetchTransactions(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          return _buildTransactionCard(transactions[index], isOngoing);
        },
      ),
    );
  }

  Widget _buildTransactionCard(TransactionModel trx, bool isOngoing) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HistoryDetailPage(transaction: trx),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: invoice + status
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trx.invoiceNumber,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            trx.assetName,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadge(trx.transactionStatus),
                  ],
                ),

                const SizedBox(height: 14),

                // Info row
                Row(
                  children: [
                    _buildInfoChip(Icons.person_outline, trx.customerName),
                    const SizedBox(width: 12),
                    _buildInfoChip(
                      Icons.shopping_bag_outlined,
                      "${trx.quantity ?? 1} unit",
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Payment status + price
                Row(
                  children: [
                    _buildPaymentBadge(trx.paymentStatus),
                    const Spacer(),
                    Text(
                      "Rp ${_formatPrice(trx.totalCost)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),

                // Action buttons
                if (isOngoing) ...[
                  const SizedBox(height: 14),
                  const Divider(height: 1),
                  const SizedBox(height: 14),
                  _buildActionButtons(trx),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(TransactionModel trx) {
    return Row(
      children: [
        // Pay button (if pending)
        if (trx.paymentStatus == "PENDING")
          Expanded(
            child: _buildActionButton(
              icon: Icons.payment,
              label: "Bayar",
              color: Colors.blue,
              onTap: () => _handlePayment(trx),
            ),
          ),

        if (trx.paymentStatus == "PENDING") const SizedBox(width: 8),

        // Tracking button
        Expanded(
          child: _buildActionButton(
            icon: Icons.local_shipping_outlined,
            label: "Tracking",
            color: const Color(0xFF2E7D32),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TrackingPage(
                    trackingNumber: trx.trackingNumber ?? "-",
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(width: 8),

        // Return button
        Expanded(
          child: _buildActionButton(
            icon: Icons.assignment_return,
            label: "Kembalikan",
            color: Colors.orange,
            onTap: () => _handleReturn(trx),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final isOngoing = status == "ONGOING";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isOngoing
            ? Colors.orange.withOpacity(0.1)
            : const Color(0xFF2E7D32).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isOngoing ? "Berlangsung" : "Selesai",
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: isOngoing ? Colors.orange.shade700 : const Color(0xFF2E7D32),
        ),
      ),
    );
  }

  Widget _buildPaymentBadge(String? status) {
    final isPending = status == "PENDING";
    final color = isPending ? Colors.red : const Color(0xFF2E7D32);
    final label = isPending ? "Belum Bayar" : "Lunas";
    final icon = isPending ? Icons.warning_amber : Icons.check_circle;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(TransactionProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              provider.errorMessage ?? "Terjadi kesalahan",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => provider.fetchTransactions(),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text("Coba Lagi"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePayment(TransactionModel trx) async {
    final txProvider = context.read<TransactionProvider>();

    final success = await txProvider.processPayment(
      transactionId: trx.id,
      paymentMethod: "QRIS",
    );

    if (!mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(context, "Pembayaran berhasil!");
    } else {
      SnackbarHelper.showError(
        context,
        txProvider.errorMessage ?? "Pembayaran gagal",
      );
    }
  }

  Future<void> _handleReturn(TransactionModel trx) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Konfirmasi Pengembalian"),
        content: const Text(
          "Apakah barang sudah benar-benar dikembalikan dalam kondisi baik?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Ya, Kembalikan"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final txProvider = context.read<TransactionProvider>();
    final success = await txProvider.processReturn(trx.id);

    if (!mounted) return;

    if (success) {
      SnackbarHelper.showSuccess(context, "Barang berhasil dikembalikan!");
    } else {
      SnackbarHelper.showError(
        context,
        txProvider.errorMessage ?? "Gagal memproses pengembalian",
      );
    }
  }

  String _formatPrice(int price) {
    final str = price.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count == 3 && i != 0) {
        buffer.write('.');
        count = 0;
      }
    }
    return buffer.toString().split('').reversed.join('');
  }
}
