import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/global/others/container_properties.dart';
import 'package:shop_seeker/global/widgets/appbar/appbar.widget.dart';
import 'package:shop_seeker/global/widgets/textfield.widget.dart';
import 'package:shop_seeker/modules/shops/controller/shop_listing.controller.dart';
import 'package:shop_seeker/modules/shops/screen/add_update.screen.dart';
import 'package:shop_seeker/modules/shops/screen/shop_details.screen.dart';
import 'package:shop_seeker/modules/shops/widget/shop_card.widget.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/extensions/size_extension.util.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final ShopListingController controller = Get.put(ShopListingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backButton: false,
        appBarColor: AppColors.primary,
        title: "Arab Market",
        titleColor: AppColors.white,
        actions: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 6.w),
            child: IconButton(
              color: AppColors.primary,
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
              Expanded(
                child: Obx(() {
                  final shopList = controller.shopProductList;
                  return ListView.builder(
                    itemCount: shopList.length,
                    itemBuilder: (context, index) {
                      final shop = shopList[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ShopCard(
                          shop: shop,
                          onTap: () => Get.to(() => ShopDetails(shop: shop)),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
