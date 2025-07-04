import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/global/widgets/button.widget.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/extensions/size_extension.util.dart';
import 'package:shop_seeker/utils/theme/textStyles.utils.dart';

class UnSavedChangesBottomSheet extends StatelessWidget {
  const UnSavedChangesBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
            'Attention_Needed'.tr,
            textAlign: TextAlign.center,
            style: stylew700(size: 18),
          ),
          4.hp,
          Text(
            "Attention_data_lost".tr,
            style: stylew400(size: 14, color: AppColors.color667085),
            textAlign: TextAlign.center,
          ),
          32.hp,
          AppButton(
            title: "go_back".tr,
            color: AppColors.colorF97970,
            onTap: () {
              Get.back(); // Close bottom sheet
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Get.back(); // Go back from AddUpdateScreen
              });
            },
          ),
          12.hp,
          AppButton(
            title: "cancel".tr,
            color: AppColors.colorF2F4F7,
            fontColor: AppColors.color1D2939,
            borderSide: const BorderSide(color: AppColors.colorEAECF0),
            onTap: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
