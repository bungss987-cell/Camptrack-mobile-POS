class Asset {
  final int id;
  final String name;
  final String description;
  final int stock;
  final int rentalPrice;

  Asset({
    required this.id,
    required this.name,
    required this.description,
    required this.stock,
    required this.rentalPrice,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      stock: json["stock"],
      rentalPrice: json["rentalPrice"],
    );
  }
}