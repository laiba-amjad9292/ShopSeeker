class ProductModel {
  final String name;
  final String imageUrl;
  final String description;
  final double price;

  ProductModel({
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.price,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
    );
  }
}
