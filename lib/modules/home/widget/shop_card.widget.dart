import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:shop_seeker/modules/home/controller/shop.controller.dart';
import 'package:shop_seeker/modules/home/models/shop.model.dart';
import 'package:shop_seeker/modules/home/models/shop_listing.model.dart';
import 'package:shop_seeker/modules/home/screen/shop_details.screen.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/theme/textStyles.utils.dart';

class ShopCard extends StatelessWidget {
  final ListingModel? listing;
  final ShopModel shop;
  final VoidCallback onTap;

  const ShopCard({
    super.key,
    required this.shop,
    required this.onTap,
    this.listing,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShopAddingController>(
      builder: (logic) {
        return GestureDetector(
          onTap: () {
            logic.listingToUpdate_ = listing;
            Get.to(() => ShopDetails(listing: listing, shop: shop));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: Image.asset(
                    shop.image,
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shop.name,
                        style: stylew600(size: 18),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        shop.address,
                        style: stylew600(
                          size: 13,
                          color: AppColors.colorAAAAAA,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
