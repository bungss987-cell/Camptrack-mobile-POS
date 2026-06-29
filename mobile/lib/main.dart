import 'package:flutter/material.dart';

import 'pages/asset_page.dart';
import 'pages/history_page.dart';
import 'pages/profile_page.dart';
import 'pages/tracking_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "CampTrack",
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final List<Widget> pages = [
  const AssetPage(),
  const HistoryPage(),
  const TrackingPage(
    trackingNumber: "-",
  ),
  const ProfilePage(),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
  NavigationDestination(
    icon: Icon(Icons.home),
    label: "Home",
  ),
  NavigationDestination(
    icon: Icon(Icons.history),
    label: "Riwayat",
  ),
  NavigationDestination(
    icon: Icon(Icons.local_shipping),
    label: "Tracking",
  ),
  NavigationDestination(
    icon: Icon(Icons.person),
    label: "Profil",
  ),
],
      ),
    );
  }
}

