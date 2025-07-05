import 'package:get/get.dart';
import 'package:shop_seeker/modules/home/models/product_listing.model.dart';

class ShopListingController extends GetxController {
  var shopProductList = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  void loadProducts() {
    final data = [
      {
        'id': '1',
        'name': 'Falafel House',
        'products': [
          {
            'name': 'Shawarma Roll',
            'imageUrl': 'assets/images/Falafel.jpg',
            'description': 'Delicious Arabic shawarma with garlic sauce.',
            'price': 5.0,
          },
          {
            'name': 'Baklava Box',
            'imageUrl': 'assets/images/Falafel.jpg',
            'description': 'Sweet dessert with nuts and honey.',
            'price': 4.5,
          },
        ],
      },
      {
        'id': '2',
        'name': 'Mandi Palace',
        'products': [
          {
            'name': 'Mandi Rice',
            'imageUrl': 'assets/images/Falafel.jpg',
            'description': 'Traditional Mandi rice with tender meat.',
            'price': 10.0,
          },
          {
            'name': 'Hummus',
            'imageUrl': 'assets/images/Falafel.jpg',
            'description': 'Classic hummus with olive oil.',
            'price': 3.0,
          },
        ],
      },
    ];

    List<ProductModel> products = [];
    for (var shop in data) {
      final productList =
          (shop['products'] as List)
              .map((item) => ProductModel.fromMap(item))
              .toList();
      products.addAll(productList);
    }

    shopProductList.value = products;
  }
}
