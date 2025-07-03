import 'package:flutter/material.dart';
import 'package:shop_seeker/global/widgets/appbar/appbar.widget.dart';
import 'package:shop_seeker/modules/home/models/shop.model.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/extensions/size_extension.util.dart';
import 'package:shop_seeker/utils/theme/textStyles.utils.dart';

class ShopDetails extends StatefulWidget {
  final ShopModel shop;

  const ShopDetails({super.key, required this.shop});
  @override
  State<ShopDetails> createState() => _ShopDetailsState();
}

class _ShopDetailsState extends State<ShopDetails> {
  @override
  Widget build(BuildContext context) {
    final ShopModel shop = widget.shop;
    return Scaffold(
      appBar: CustomAppBar(
        appBarColor: AppColors.primary,
        title: "Shop Details",
        titleColor: AppColors.white,
        backButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(11.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.hp,
                Text(shop.name, style: stylew600(size: 22)),
                Text(
                  shop.address,
                  style: stylew600(size: 14, color: AppColors.colorAAAAAA),
                ),
                10.hp,
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    "assets/images/Falafel.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                10.hp,
                Text("Products", style: stylew600(size: 22)),
                // Obx(
                //   () => GridView.builder(
                //     shrinkWrap: true,
                //     physics: NeverScrollableScrollPhysics(),
                //     itemCount: shop.products.length,
                //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //       crossAxisCount: 2,
                //       mainAxisSpacing: 10,
                //       crossAxisSpacing: 10,
                //       childAspectRatio: 0.9,
                //     ),
                //     itemBuilder: (context, index) {
                //       final product = shop.products[index];
                //       return ProductCard(
                //         product: product,
                //         onTap: () {
                //           Get.to(() => ProductDetailScreen(product: product));
                //         },
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
