import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/global/others/container_properties.dart';
import 'package:shop_seeker/global/widgets/appbar/appbar.widget.dart';
import 'package:shop_seeker/global/widgets/no_item_found/not_items.widget.dart';
import 'package:shop_seeker/global/widgets/textfield.widget.dart';
import 'package:shop_seeker/modules/home/controller/shop.controller.dart';
import 'package:shop_seeker/modules/home/models/shop_listing.model.dart';
import 'package:shop_seeker/modules/home/screen/add_update.screen.dart';
import 'package:shop_seeker/modules/home/widget/shop_card.widget.dart';
import 'package:shop_seeker/services/database.service.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/extensions/size_extension.util.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final ShopAddingController controller = Get.find<ShopAddingController>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      controller.handleGetShopListing();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backButton: false,
        appBarColor: AppColors.primary,
        title: "arab_market".tr,
        titleColor: AppColors.white,
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 6.w),
            child: IconButton(
              onPressed: () {
                Get.to(() => const AddUpdateScreen());
              },
              icon: Image.asset(
                'assets/icons/addIcon.png',
                width: 26,
                height: 26,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.handleGetShopListing();
        },

        child: StreamBuilder(
          stream: Database.getMyShopListingStream(
            FirebaseAuth.instance.currentUser?.uid ?? '',
          ),
          builder: (context, snap) {
            if (!snap.hasData) return SizedBox();
            if (snap.data?.docs.isEmpty ?? true) {
              final isLoggedIn = FirebaseAuth.instance.currentUser != null;

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  10.hp,
                  Container(
                    height: 59.h,
                    decoration: ContainerProperties.shadowDecoration(
                      color: AppColors.white,
                      radius: 11,
                      blurRadius: 20,
                      xd: 0,
                      yd: 5,
                    ),
                    child: CustomTextField(
                      showTitle: false,
                      hintText: "search_your_shop".tr,
                      keyName: "search",
                      focusedBorderColor: Colors.transparent,
                      enabledBorderColor: Colors.transparent,
                      prefixIcon: Image.asset(
                        'assets/icons/SearchIcon.png',
                        color: AppColors.colorAAAAAA,
                      ),
                    ),
                  ),
                  24.hp,
                  NoItemFound(
                    heading: "No_shops_found".tr,
                    subheading:
                        isLoggedIn
                            ? "please_add_a_new_shop_to_get_started".tr
                            : "Stay_tuned_for_updates".tr,
                    primaryButtonTitle: isLoggedIn ? "add_shop".tr : null,
                    onPrimaryClick:
                        isLoggedIn
                            ? () => Get.to(() => const AddUpdateScreen())
                            : null,
                  ),
                ],
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: (snap.data?.docs.length ?? 0) + 1,
              separatorBuilder: (_, __) => 12.hp,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    children: [
                      10.hp,
                      Container(
                        height: 59.h,
                        decoration: ContainerProperties.shadowDecoration(
                          color: AppColors.white,
                          radius: 11,
                          blurRadius: 20,
                          xd: 0,
                          yd: 5,
                        ),
                        child: CustomTextField(
                          showTitle: false,
                          hintText: "search_your_shop".tr,
                          keyName: "search",
                          focusedBorderColor: Colors.transparent,
                          enabledBorderColor: Colors.transparent,
                          prefixIcon: Image.asset(
                            'assets/icons/SearchIcon.png',
                            color: AppColors.colorAAAAAA,
                          ),
                        ),
                      ),
                      16.hp,
                    ],
                  );
                }

                // final shop = controller.myListings[index - 1];
                final shop = ListingModel.fromSnapSnapshot(
                  snap.data?.docs[index - 1],
                );
                return ShopCard(listing: shop, onTap: () {});
              },
            );
          },
        ),
      ),
    );
  }
}
