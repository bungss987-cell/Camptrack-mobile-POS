import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Widget buildMenu(
      IconData icon,
      String title,
      Color color,
  ) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 45,
              color: color,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CampTrack Dashboard"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: [

            buildMenu(
              Icons.inventory,
              "Data Aset",
              Colors.orange,
            ),

            buildMenu(
              Icons.shopping_cart,
              "Transaksi",
              Colors.blue,
            ),

            buildMenu(
              Icons.local_shipping,
              "Pengiriman",
              Colors.red,
            ),

            buildMenu(
              Icons.payment,
              "Pembayaran",
              Colors.green,
            ),

            buildMenu(
              Icons.bar_chart,
              "Laporan",
              Colors.purple,
            ),

            buildMenu(
              Icons.person,
              "Profil",
              Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
}