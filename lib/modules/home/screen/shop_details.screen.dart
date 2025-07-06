import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/global/widgets/appbar/appbar.widget.dart';
import 'package:shop_seeker/global/widgets/button.widget.dart';
import 'package:shop_seeker/global/widgets/network_image/custom_network_image.widget.dart';
import 'package:shop_seeker/modules/home/models/product_listing.model.dart';
import 'package:shop_seeker/modules/home/models/shop_listing.model.dart';
import 'package:shop_seeker/modules/home/screen/add_update.screen.dart';
import 'package:shop_seeker/modules/home/screen/add_update_product.screen.dart';
import 'package:shop_seeker/modules/home/screen/product_details.screen.dart';
import 'package:shop_seeker/modules/home/widget/product_card.widget.dart';
import 'package:shop_seeker/services/user_manager.service.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/extensions/container_extension.util.dart';
import 'package:shop_seeker/utils/extensions/size_extension.util.dart';
import 'package:shop_seeker/utils/theme/textStyles.utils.dart';

class ShopDetails extends StatefulWidget {
  final ListingModel? listing;
  final ProductModel? product_listing;
  const ShopDetails({super.key, this.listing, this.product_listing});
  @override
  State<ShopDetails> createState() => _ShopDetailsState();
}

class _ShopDetailsState extends State<ShopDetails> {
  final List<ProductModel> products = [
    ProductModel(
      name: 'Baklava Box',
      imageUrl: 'assets/images/Falafel.jpg',
      description: 'Sweet dessert with nuts and honey.',
      price: 899.99,
    ),
    ProductModel(
      name: 'Mandi Palace',
      imageUrl: 'assets/images/Falafel.jpg',
      description: 'Traditional Mandi rice with tender meat.',
      price: 199.99,
    ),
  ];
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Listing_Details".tr,
        titleColor: AppColors.white,
        backButton: true,
        centeredTitle: false,
        appBarColor: AppColors.primary,
        actions: [
          if (widget.listing?.userId == UserManager.instance.userId)
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
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Row(
            children: [
              Expanded(
                child: AppButton(
                  title: "go_back".tr,
                  color: AppColors.primary30,
                  fontColor: AppColors.primary,
                  borderSide: const BorderSide(color: AppColors.colorEAECF0),
                  onTap: () {
                    Get.back();
                  },
                ),
              ),
              10.wp,
              if (widget.listing?.userId == UserManager.instance.userId)
                Expanded(
                  child: AppButton(
                    title: "Edit_Shop".tr,
                    maxLines: 1,
                    minFontSize: 8,
                    overflow: TextOverflow.ellipsis,
                    onTap: () {
                      Get.to(() => AddUpdateScreen(listing: widget.listing));
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 400,
                child: PageView.builder(
                  itemCount: widget.listing?.image.length,
                  onPageChanged:
                      (i) => setState(() {
                        index = i;
                      }),
                  itemBuilder: (context, index) {
                    final img = widget.listing?.image[index];
                    return NetworkImageCustom(
                      radius: 0,
                      image: img,
                      height: 400,
                    );
                  },
                ),
              ),
              10.hp,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.listing?.image.length ?? 0,
                  (i) => Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Container(
                      height: 6,
                      width: index == i ? 20 : 6,
                    ).bordered(
                      color: AppColors.primary.withOpacity(
                        index == i ? 1 : 0.2,
                      ),
                      radius: 60,
                    ),
                  ),
                ),
              ),
              10.hp,
              Padding(
                padding: const EdgeInsets.all(11.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.listing?.name ?? "",
                      style: stylew600(size: 22, color: AppColors.color101828),
                    ),
                    10.hp,
                    Row(
                      children: [
                        Text(
                          "Category".tr,
                          style: stylew600(color: AppColors.color101828),
                        ),
                        2.wp,
                        Text(
                          widget.listing?.category ?? "",
                          style: stylew600(
                            size: 14,
                            color: AppColors.color98A2B3,
                          ),
                        ),
                      ],
                    ),
                    5.hp,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "address".tr,
                          style: stylew600(color: AppColors.color101828),
                        ),

                        Text(
                          [
                            widget.listing?.address ?? "",
                            widget.listing?.country ?? "",
                            widget.listing?.city ?? "",
                            widget.listing?.postalCode ?? "",
                          ].where((e) => e.isNotEmpty).join(', '),
                          style: stylew600(
                            size: 14,
                            color: AppColors.color98A2B3,
                          ),
                          softWrap: true,
                        ),
                      ],
                    ),

                    5.hp,

                    Text(
                      "description".tr,
                      style: stylew600(size: 16, color: AppColors.color101828),
                    ),
                    Text(
                      widget.listing?.description ?? "",
                      style: stylew500(size: 14, color: AppColors.color98A2B3),
                      softWrap: true,
                    ),
                    10.hp,
                    Text(
                      "timing_on_weekday".tr,
                      style: stylew600(color: AppColors.color101828),
                    ),
                    5.hp,
                    Text(
                      widget.listing?.timingWeekdays ?? '',
                      style: stylew600(size: 14, color: AppColors.color98A2B3),
                    ),
                    5.hp,
                    Text(
                      "timing_on_weekend".tr,
                      style: stylew600(color: AppColors.color101828),
                    ),
                    5.hp,
                    Text(
                      widget.listing?.timingWeekends ?? '',
                      style: stylew600(size: 14, color: AppColors.color98A2B3),
                    ),

                    10.hp,
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "products".tr,
                            style: stylew600(
                              size: 22,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        if (FirebaseAuth.instance.currentUser?.uid ==
                            widget.listing?.userId)
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
                      itemCount: products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.9,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];
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
            ],
          ),
        ),
      ),
    );
  }
}
