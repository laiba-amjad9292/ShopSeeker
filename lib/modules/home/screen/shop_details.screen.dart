import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/global/widgets/appbar/appbar.widget.dart';
import 'package:shop_seeker/modules/home/models/shop.model.dart';
import 'package:shop_seeker/modules/home/models/shop_listing.model.dart';
import 'package:shop_seeker/modules/home/screen/add_update.screen.dart';
import 'package:shop_seeker/modules/home/screen/add_update_product.screen.dart';
import 'package:shop_seeker/modules/home/screen/product_details.screen.dart';
import 'package:shop_seeker/modules/home/widget/product_card.widget.dart';
import 'package:shop_seeker/services/user_manager.service.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/extensions/size_extension.util.dart';
import 'package:shop_seeker/utils/theme/textStyles.utils.dart';

class ShopDetails extends StatefulWidget {
  final ListingModel? listing;
  final ShopModel shop;

  const ShopDetails({super.key, required this.shop, this.listing});
  @override
  State<ShopDetails> createState() => _ShopDetailsState();
}

class _ShopDetailsState extends State<ShopDetails> {
  @override
  Widget build(BuildContext context) {
    final ShopModel shop = widget.shop;
    return Scaffold(
      appBar: CustomAppBar(
        title: "Listing_Details".tr,
        titleColor: AppColors.white,
        backButton: true,
        centeredTitle: false,
        appBarColor: AppColors.primary,
        actions: [
          // if (widget.listing?.userId == UserManager.instance.userId)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 6.w),
            child: IconButton(
              color: AppColors.primary,
              onPressed: () {
                Get.to(() => AddUpdateScreen(listing: widget.listing));
              },
              icon: Image.asset(
                'assets/icons/ic_edit.png',
                width: 25,
                color: AppColors.white,
              ),
            ),
          ),
        ],
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
                Row(
                  children: [
                    Expanded(
                      child: Text("Products", style: stylew600(size: 22)),
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 6.w),
                      child: IconButton(
                        color: AppColors.primary,
                        onPressed: () {
                          Get.to(() => const AddUpdateProductScreen());
                        },
                        icon: Image.asset(
                          'assets/icons/addIcon.png',
                          width: 26,
                          height: 26,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                16.hp,
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: shop.products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, index) {
                    final product = shop.products[index];
                    return ProductCard(
                      product: product,
                      onTap: () {
                        Get.to(() => ProductDetailScreen(product: product));
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
