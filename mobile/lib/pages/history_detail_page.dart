import 'package:flutter/material.dart';
import '../models/transaction.dart';

class HistoryDetailPage extends StatelessWidget {
  final TransactionModel transaction;

  const HistoryDetailPage({
    super.key,
    required this.transaction,
  });

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

  @override
  Widget build(BuildContext context) {
    final isOngoing = transaction.transactionStatus == "ONGOING";

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Detail Transaksi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Status header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isOngoing
                    ? [Colors.orange.shade400, Colors.orange.shade600]
                    : [const Color(0xFF2E7D32), const Color(0xFF43A047)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (isOngoing ? Colors.orange : const Color(0xFF2E7D32))
                      .withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isOngoing ? Icons.hourglass_bottom : Icons.check_circle,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isOngoing ? "Sedang Berlangsung" : "Selesai",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        transaction.invoiceNumber,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Detail cards
          _buildSection(
            "Informasi Penyewa",
            Icons.person,
            [
              _buildDetailRow("Nama", transaction.customerName),
              _buildDetailRow("Barang", transaction.assetName),
              _buildDetailRow("Jumlah", "${transaction.quantity ?? 1} unit"),
            ],
          ),

          const SizedBox(height: 14),

          _buildSection(
            "Periode Penyewaan",
            Icons.date_range,
            [
              _buildDetailRow(
                "Tanggal Pinjam",
                _formatDate(transaction.startDate),
              ),
              _buildDetailRow(
                "Tanggal Kembali",
                _formatDate(transaction.endDate),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _buildSection(
            "Pembayaran",
            Icons.payment,
            [
              _buildDetailRow(
                "Status",
                transaction.paymentStatus == "SUCCESS" ? "Lunas" : "Belum Bayar",
                valueColor: transaction.paymentStatus == "SUCCESS"
                    ? const Color(0xFF2E7D32)
                    : Colors.red,
              ),
              _buildDetailRow(
                "Metode",
                transaction.paymentMethod ?? "-",
              ),
              _buildDetailRow(
                "Total",
                "Rp ${_formatPrice(transaction.totalCost)}",
                valueColor: const Color(0xFF2E7D32),
                isBold: true,
              ),
            ],
          ),

          if (transaction.trackingNumber != null) ...[
            const SizedBox(height: 14),
            _buildSection(
              "Pengiriman",
              Icons.local_shipping,
              [
                _buildDetailRow("Nomor Resi", transaction.trackingNumber!),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFF2E7D32), size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    Color? valueColor,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return "-";
    try {
      final date = DateTime.parse(dateStr);
      return "${date.day}/${date.month}/${date.year}";
    } catch (_) {
      return dateStr;
    }
  }
}
