import 'package:flutter/material.dart';
import '../models/asset.dart';
import '../services/transaction_service.dart';
import 'payment_page.dart';


class DetailPage extends StatefulWidget {
  final Asset asset;

  const DetailPage({
    super.key,
    required this.asset,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  final transactionService = TransactionService();

  int quantity = 1;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 1));

  int get totalDays =>
      endDate.difference(startDate).inDays + 1;

  int get totalPrice =>
      widget.asset.rentalPrice * quantity * totalDays;

  String getImage() {
    switch (widget.asset.name) {
      case "Kursi Lipat":
        return "assets/images/kursi.jpg";

      case "Hammock Outdoor":
        return "assets/images/hammock.jpg";

      case "Carrier 60L":
        return "assets/images/carrier.jpg";

      case "Tracking pool":
        return "assets/images/tracking.jpg";

      case "Matras Camp":
        return "assets/images/matras.jpg";

      case "Senter":
        return "assets/images/senter.jpg";

      case "Jacket":
        return "assets/images/jacket.jpg";

      case "Kompor dan Gas":
        return "assets/images/kompor.jpg";

      case "Sleeping Bag Outdoor":
        return "assets/images/sleeping_bag.jpg";

      default:
        return "assets/images/tenda.jpg";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(widget.asset.name),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          /// FOTO
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              getImage(),
              height: 240,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 20),

          /// NAMA ALAT
          Text(
            widget.asset.name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          /// DESKRIPSI
          Text(
            widget.asset.description,
            style: const TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 25),

          /// HARGA
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.money,
                color: Colors.green,
              ),
              title: const Text("Harga Sewa"),
              subtitle: Text(
                "Rp ${widget.asset.rentalPrice}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          ),

          /// STOK
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.inventory,
                color: Colors.green,
              ),
              title: const Text("Stok"),
              subtitle: Text("${widget.asset.stock} Unit"),
            ),
          ),

          const SizedBox(height: 25),

          /// NAMA
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: "Nama Penyewa",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 15),

          /// HP
          TextField(
            controller: phoneController,
            decoration: const InputDecoration(
              labelText: "No HP",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 15),

          /// ALAMAT
          TextField(
            controller: addressController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: "Alamat",
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          /// JUMLAH
          Row(
            children: [
              const Text(
                "Jumlah",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),

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
                "$quantity",
                style: const TextStyle(fontSize: 20),
              ),

              IconButton(
                onPressed: () {
                  if (quantity < widget.asset.stock) {
                    setState(() {
                      quantity++;
                    });
                  }
                },
                icon: const Icon(Icons.add_circle),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// TANGGAL PINJAM
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text("Tanggal Pinjam"),
            subtitle: Text(
              "${startDate.day}/${startDate.month}/${startDate.year}",
            ),
            trailing: const Icon(Icons.edit),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: startDate,
                firstDate: DateTime.now(),
                lastDate: DateTime(2030),
              );

              if (picked != null) {
                setState(() {
                  startDate = picked;

                  if (endDate.isBefore(startDate)) {
                    endDate = startDate;
                  }
                });
              }
            },
          ),

          /// TANGGAL KEMBALI
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text("Tanggal Kembali"),
            subtitle: Text(
              "${endDate.day}/${endDate.month}/${endDate.year}",
            ),
            trailing: const Icon(Icons.edit),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: endDate,
                firstDate: startDate,
                lastDate: DateTime(2030),
              );

              if (picked != null) {
                setState(() {
                  endDate = picked;
                });
              }
            },
          ),

          const SizedBox(height: 20),

          /// TOTAL
          Card(
            color: Colors.green.shade50,
            child: ListTile(
              leading: const Icon(
                Icons.payments,
                color: Colors.green,
              ),
              title: const Text("Total Pembayaran"),
              subtitle: Text("$totalDays Hari"),
              trailing: Text(
                "Rp $totalPrice",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          /// TOMBOL SEWA
          SizedBox(
            height: 55,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.shopping_cart),
              label: const Text("Sewa Sekarang"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
  try {
    final transactionId = await transactionService.createTransaction(
      assetId: widget.asset.id,
      customerName: nameController.text,
      customerPhone: phoneController.text,
      customerAddress: addressController.text,
      quantity: quantity,
      startDate: startDate,
      endDate: endDate,
    );

    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentPage(
          transactionId: transactionId,
          totalPrice: totalPrice,
        ),
      ),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Penyewaan berhasil"),
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
            ),
          ),
        ],
      ),
    );
  }
}