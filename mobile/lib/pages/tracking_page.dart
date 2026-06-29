import 'package:flutter/material.dart';

class TrackingPage extends StatelessWidget {
  final String trackingNumber;

  const TrackingPage({
    super.key,
    required this.trackingNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tracking Pengiriman"),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.qr_code,
                color: Colors.green,
              ),
              title: const Text("Nomor Resi"),
              subtitle: Text(
                trackingNumber.isEmpty ? "-" : trackingNumber,
              ),
            ),
          ),
        ],
      ),
    );
  }
}