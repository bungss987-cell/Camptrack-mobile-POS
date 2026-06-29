import 'package:flutter/material.dart';

import '../models/asset.dart';

class RentalPage extends StatefulWidget {
  final Asset asset;

  const RentalPage({
    super.key,
    required this.asset,
  });

  @override
  State<RentalPage> createState() => _RentalPageState();
}

class _RentalPageState extends State<RentalPage> {
  final TextEditingController customerController =
      TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sewa Alat"),
        backgroundColor: Colors.green,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [

          Text(
            widget.asset.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: customerController,
            decoration: const InputDecoration(
              labelText: "Nama Penyewa",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "Jumlah",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          Row(
            children: [

              IconButton(
                onPressed: () {
                  if (quantity > 1) {
                    setState(() {
                      quantity--;
                    });
                  }
                },
                icon: const Icon(Icons.remove_circle),
              ),

              Text(
                quantity.toString(),
                style: const TextStyle(fontSize: 20),
              ),

              IconButton(
                onPressed: () {
                  setState(() {
                    quantity++;
                  });
                },
                icon: const Icon(Icons.add_circle),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            "Harga : Rp ${widget.asset.rentalPrice}",
            style: const TextStyle(
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "Total : Rp ${widget.asset.rentalPrice * quantity}",
            style: const TextStyle(
              color: Colors.green,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 35),

          SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () {

              },
              child: const Text(
                "Sewa Sekarang",
              ),
            ),
          )
        ],
      ),
    );
  }
}