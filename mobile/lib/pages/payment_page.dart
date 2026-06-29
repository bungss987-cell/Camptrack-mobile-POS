import 'package:flutter/material.dart';
import '../services/transaction_service.dart';

class PaymentPage extends StatefulWidget {
  final int transactionId;
  final int totalPrice;

  const PaymentPage({
    super.key,
    required this.transactionId,
    required this.totalPrice,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TransactionService service = TransactionService();

  String paymentMethod = "QRIS";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pembayaran"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.payments,
                  color: Colors.green,
                ),
                title: const Text("Total Pembayaran"),
                subtitle: Text(
                  "Rp ${widget.totalPrice}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Metode Pembayaran",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            RadioListTile(
              value: "QRIS",
              groupValue: paymentMethod,
              title: const Text("QRIS"),
              onChanged: (v) {
                setState(() {
                  paymentMethod = v!;
                });
              },
            ),

            RadioListTile(
              value: "Transfer",
              groupValue: paymentMethod,
              title: const Text("Transfer Bank"),
              onChanged: (v) {
                setState(() {
                  paymentMethod = v!;
                });
              },
            ),

            RadioListTile(
              value: "COD",
              groupValue: paymentMethod,
              title: const Text("COD"),
              onChanged: (v) {
                setState(() {
                  paymentMethod = v!;
                });
              },
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  try {
                    await service.payTransaction(
                      id: widget.transactionId,
                      paymentMethod: paymentMethod,
                    );

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Pembayaran berhasil"),
                      ),
                    );

                    Navigator.pop(context);
                  } catch (e) {
                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );
                  }
                },
                child: const Text("Bayar Sekarang"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}