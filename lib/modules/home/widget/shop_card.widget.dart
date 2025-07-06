import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/global/others/global_functions.dart';
import 'package:shop_seeker/global/widgets/network_image/custom_network_image.widget.dart';
import 'package:shop_seeker/modules/home/controller/shop.controller.dart';
import 'package:shop_seeker/modules/home/models/shop_listing.model.dart';
import 'package:shop_seeker/modules/home/screen/shop_details.screen.dart';
import 'package:shop_seeker/modules/home/widget/account_access.widget.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/theme/textStyles.utils.dart';

class ShopCard extends StatefulWidget {
  final ListingModel? listing;
  final VoidCallback onTap;

  const ShopCard({super.key, required this.onTap, this.listing});

  @override
  State<ShopCard> createState() => _ShopCardState();
}

class _ShopCardState extends State<ShopCard> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShopAddingController>(
      builder: (logic) {
        return GestureDetector(
          onTap: () async {
            if (FirebaseAuth.instance.currentUser == null) {
              GlobalFunctions.showBottomSheet(const AccountAccessRequired());
            } else {
              logic.listingToUpdate_ = widget.listing;
              Get.to(() => ShopDetails(listing: widget.listing));
            }
          },

          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),

              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: NetworkImageCustom(
                    image: widget.listing?.image[0],
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.listing?.name ?? "",
                        style: stylew600(size: 18),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        [
                          widget.listing?.address ?? "",
                          widget.listing?.country ?? "",
                          widget.listing?.city ?? "",
                          widget.listing?.postalCode ?? "",
                        ].where((e) => e.isNotEmpty).join(', '),
                        style: stylew600(
                          size: 13,
                          color: AppColors.color98A2B3,
                        ),
                        softWrap: true,
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
