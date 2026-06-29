import 'package:flutter/material.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "Bung Bung";
  String email = "user@gmail.com";
  String phone = "081234567890";
  String address = "Bandung";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CircleAvatar(
            radius: 55,
            backgroundColor: Colors.green,
            child: Icon(
              Icons.person,
              size: 60,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 20),

          Center(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Center(
            child: Text(
              email,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),

          const SizedBox(height: 30),

          Card(
            child: ListTile(
              leading: const Icon(Icons.phone),
              title: const Text("Nomor HP"),
              subtitle: Text(phone),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Alamat"),
              subtitle: Text(address),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.history),
              title: const Text("Riwayat Penyewaan"),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Edit Profil"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfilePage(
                      name: name,
                      email: email,
                      phone: phone,
                      address: address,
                    ),
                  ),
                );

                if (result != null) {
                  setState(() {
                    name = result["name"];
                    email = result["email"];
                    phone = result["phone"];
                    address = result["address"];
                  });
                }
              },
            ),
          ),

          const SizedBox(height: 40),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 55),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Fitur logout akan dibuat selanjutnya"),
                ),
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}