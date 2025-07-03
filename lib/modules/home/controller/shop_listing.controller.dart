import 'package:get/get.dart';
import 'package:shop_seeker/modules/home/models/shop.model.dart';

class ShopListingController extends GetxController {
  var shopProductList = <ShopModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadShops();
  }

  void loadShops() {
    final data = [
      {
        'id': '1',
        'name': 'Falafel House',
        'address': 'Riyadh, Al Madinah Street',
        'image': 'assets/images/Falafel.jpg',
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
        'address': 'Jeddah, King Fahd Road',
        'image': 'assets/images/Falafel.jpg',
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

    shopProductList.value = data.map((e) => ShopModel.fromMap(e)).toList();
  }
}
