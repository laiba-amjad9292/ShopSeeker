import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/modules/home/controller/shop.controller.dart';
import 'package:shop_seeker/modules/home/models/shop_listing.model.dart';
import 'package:shop_seeker/modules/home/screen/shop_details.screen.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/extensions/size_extension.util.dart';
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
          onTap: () {
            logic.listingToUpdate_ = widget.listing;
            Get.to(() => ShopDetails(listing: widget.listing));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
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
                    child: Image.network(
                      widget.listing?.mainImage.isNotEmpty == true
                          ? widget.listing!.mainImage
                          : 'https://picsum.photos/200/300',
                      height: 200,
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
                          widget.listing?.name ?? "",
                          style: stylew600(size: 18),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        2.hp,
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
          ),
        );
      },
    );
  }
}
