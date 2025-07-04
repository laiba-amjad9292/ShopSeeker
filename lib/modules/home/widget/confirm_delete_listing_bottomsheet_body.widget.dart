import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/global/widgets/button.widget.dart';
import 'package:shop_seeker/modules/home/controller/shop.controller.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/extensions/size_extension.util.dart';
import 'package:shop_seeker/utils/theme/textStyles.utils.dart';

class ConfirmDeleteBottomSheet extends StatefulWidget {
  const ConfirmDeleteBottomSheet({super.key});

  @override
  State<ConfirmDeleteBottomSheet> createState() =>
      _ConfirmDeleteBottomSheetState();
}

class _ConfirmDeleteBottomSheetState extends State<ConfirmDeleteBottomSheet> {
  var myListingsController = Get.find<ShopAddingController>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          4.hp,
          Text(
            '⚠',
            textAlign: TextAlign.center,
            style: stylew700(size: 48, color: AppColors.colorFDA712),
          ),
          4.hp,
          Text(
            'Confirm_Delete'.tr,
            textAlign: TextAlign.center,
            style: stylew700(size: 18),
          ),
          4.hp,
          Text(
            "Confirm_Delete_subheading".tr,
            style: stylew400(size: 14, color: AppColors.color667085),
            textAlign: TextAlign.center,
          ),
          32.hp,
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              children: [
                AppButton(
                  title: "Delete".tr,
                  fontColor: Colors.white,
                  onTap: () {
                    myListingsController.handleDeleteShopListing();
                  },
                  color: AppColors.colorF97970,
                ),
                12.hp,
                AppButton(
                  onTap: () {
                    Get.back();
                  },
                  title: "cancel".tr,
                  color: AppColors.colorF2F4F7,
                  fontColor: AppColors.color1D2939,
                  elevation: 0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
