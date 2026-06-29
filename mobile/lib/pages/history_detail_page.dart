import 'package:flutter/material.dart';
import '../models/transaction.dart';

class HistoryDetailPage extends StatelessWidget {
  final TransactionModel transaction;

  const HistoryDetailPage({
    super.key,
    required this.transaction,
  });

  Color getStatusColor() {
    if (transaction.transactionStatus == "ONGOING") {
      return Colors.orange;
    }
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Transaksi"),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: ListTile(
              title: const Text("Invoice"),
              subtitle: Text(transaction.invoiceNumber),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("Nama Penyewa"),
              subtitle: Text(transaction.customerName),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("Barang"),
              subtitle: Text(transaction.assetName),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("Jumlah"),
              subtitle: Text("${transaction.quantity ?? 0} Unit"),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("Tanggal Pinjam"),
              subtitle: Text(transaction.startDate ?? "-"),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("Tanggal Kembali"),
              subtitle: Text(transaction.endDate ?? "-"),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("Metode Pembayaran"),
              subtitle: Text(transaction.paymentMethod ?? "-"),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("Status"),
              subtitle: Text(
                transaction.transactionStatus,
                style: TextStyle(
                  color: getStatusColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text("Total"),
              trailing: Text(
                "Rp ${transaction.totalCost}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.green,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}