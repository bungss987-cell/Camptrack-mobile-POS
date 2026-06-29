import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../models/asset.dart';
import '../services/asset_service.dart';
import 'detail_page.dart';

class AssetPage extends StatefulWidget {
  const AssetPage({super.key});

  @override
  State<AssetPage> createState() => _AssetPageState();
}

class _AssetPageState extends State<AssetPage> {
  final AssetService service = AssetService();

  late Future<List<Asset>> assets;

  String keyword = "";

  final List<String> promoImages = [
    "https://images.unsplash.com/photo-1504280390367-361c6d9f38f4",
    "https://images.unsplash.com/photo-1523987355523-c7b5b84cffd0",
    "https://images.unsplash.com/photo-1473448912268-2022ce9509d8",
  ];

  @override
  void initState() {
    super.initState();
    assets = service.getAssets();
  }

  String getImage(String name) {
    switch (name) {
      case "Tenda Dome 4 Orang":
        return "assets/images/tenda.jpg";

      case "Sleeping Bag Outdoor":
        return "assets/images/sleeping_bag.jpg";

      case "Kompor dan Gas":
        return "assets/images/kompor.jpg";

      case "Jacket":
        return "assets/images/jacket.jpg";

      case "Senter":
        return "assets/images/senter.jpg";

      case "Matras Camp":
        return "assets/images/matras.jpg";

      case "Tracking pool":
        return "assets/images/tracking.jpg";

      case "Carrier 60L":
        return "assets/images/carrier.jpg";

      case "Hammock Outdoor":
        return "assets/images/hammock.jpg";

      case "Kursi Lipat":
        return "assets/images/kursi.jpg";

      default:
        return "assets/images/tenda.jpg";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "CampTrack",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder<List<Asset>>(
        future: assets,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
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

          final filteredData = data.where((asset) {
            return asset.name
                .toLowerCase()
                .contains(keyword.toLowerCase());
          }).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    keyword = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Cari alat camping...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              CarouselSlider(
                options: CarouselOptions(
                  height: 180,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.92,
                ),
                items: promoImages.map((image) {
                  return ClipRRect(
                    borderRadius:
                        BorderRadius.circular(18),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          image,
                          fit: BoxFit.cover,
                        ),

                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black54,
                                Colors.transparent,
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),

                        const Positioned(
                          left: 20,
                          bottom: 20,
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                "PROMO CAMPTRACK",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Diskon hingga 30%\nSemua Alat Camping",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 25),

              const Text(
                "Daftar Peralatan",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              ...filteredData.map((asset) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DetailPage(asset: asset),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    margin:
                        const EdgeInsets.only(bottom: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(10),
                        child: Image.asset(
                          getImage(asset.name),
                          width: 65,
                          height: 65,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        asset.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        asset.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        crossAxisAlignment:
                            CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Rp ${asset.rentalPrice}",
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Stok ${asset.stock}",
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}