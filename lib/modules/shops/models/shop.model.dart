import 'package:shop_seeker/modules/shops/models/product.model.dart';

class ShopModel {
  final String id;
  final String name;
  final String address;
  final String image;
  final List<ProductModel> products;

  ShopModel({
    required this.id,
    required this.name,
    required this.address,
    required this.image,
    required this.products,
  });

  factory ShopModel.fromMap(Map<String, dynamic> map) {
    return ShopModel(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      image: map['image'],
      products:
          (map['products'] as List<dynamic>)
              .map((e) => ProductModel.fromMap(e))
              .toList(),
    );
  }
}
