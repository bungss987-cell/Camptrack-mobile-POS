import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../services/history_service.dart';
import '../services/transaction_service.dart';
import 'tracking_page.dart';
import 'history_detail_page.dart';


class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryService service = HistoryService();

  final TransactionService transactionService =
      TransactionService();

  late Future<List<TransactionModel>> histories;

  @override
  void initState() {
    super.initState();
    histories = service.getHistory();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "ONGOING":
        return Colors.orange;

      case "COMPLETED":
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Penyewaan"),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<TransactionModel>>(
        future: histories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final data = snapshot.data!;

          if (data.isEmpty) {
            return const Center(
              child: Text("Belum ada transaksi"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final trx = data[index];

              return InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HistoryDetailPage(
                        transaction: trx,
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                trx.invoiceNumber,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: getStatusColor(
                                  trx.transactionStatus,
                                ).withOpacity(.15),
                                borderRadius:
                                    BorderRadius.circular(20),
                              ),
                              child: Text(
                                trx.transactionStatus,
                                style: TextStyle(
                                  color: getStatusColor(
                                    trx.transactionStatus,
                                  ),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const Divider(),

                        ListTile(
                          dense: true,
                          leading: const Icon(Icons.person),
                          title: Text(trx.customerName),
                        ),

                        const SizedBox(height: 10),

if (trx.paymentStatus == "PENDING")
  SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      icon: const Icon(Icons.payment),
      label: const Text("Bayar Sekarang"),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      onPressed: () async {
        try {
          await transactionService.payTransaction(
            id: trx.id,
            paymentMethod: "QRIS",
          );

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Pembayaran berhasil"),
            ),
          );

          setState(() {
            histories = service.getHistory();
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
            ),
          );
        }
      },
    ),
  ),

                        ListTile(
                          dense: true,
                          leading: const Icon(Icons.backpack),
                          title: Text(trx.assetName),
                        ),

                        ListTile(
                          dense: true,
                          leading: const Icon(Icons.payments),
                          title: Text("Rp ${trx.totalCost}"),
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.local_shipping),
                            label:
                                const Text("Lihat Tracking"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TrackingPage(
                                    trackingNumber:
                                        trx.trackingNumber ??
                                            "-",
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.info),
                            label: const Text("Detail"),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      HistoryDetailPage(
                                    transaction: trx,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        if (trx.transactionStatus ==
                            "ONGOING") ...[
                          const SizedBox(height: 10),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(
                                Icons.assignment_turned_in,
                              ),
                              label: const Text(
                                "Selesai Dikembalikan",
                              ),
                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.orange,
                                foregroundColor:
                                    Colors.white,
                              ),
                             onPressed: () async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Konfirmasi"),
      content: const Text(
        "Apakah barang sudah benar-benar dikembalikan?",
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text("Batal"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text("Ya"),
        ),
      ],
    ),
  );

  if (confirm != true) return;

  try {
    await transactionService.returnTransaction(trx.id);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Barang berhasil dikembalikan",
        ),
      ),
    );

    setState(() {
      histories = service.getHistory();
    });
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.toString(),
        ),
      ),
    );
  }
},
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}