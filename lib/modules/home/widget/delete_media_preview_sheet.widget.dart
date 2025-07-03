import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:shop_seeker/global/widgets/button.widget.dart';
import 'package:shop_seeker/global/widgets/network_image/custom_network_image.widget.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/extensions/size_extension.util.dart';
import 'package:shop_seeker/utils/theme/textStyles.utils.dart';

class ImageDeletePreviewBottomSheet extends StatefulWidget {
  final VoidCallback handleDelete;
  final String? imageURL;

  const ImageDeletePreviewBottomSheet(
    this.handleDelete,
    this.imageURL, {
    super.key,
  });

  @override
  _ImageDeletePreviewBottomSheetState createState() =>
      _ImageDeletePreviewBottomSheetState();
}

class _ImageDeletePreviewBottomSheetState
    extends State<ImageDeletePreviewBottomSheet>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: InteractiveViewer(
                child: NetworkImageCustom(
                  width: double.infinity,
                  height: 220,
                  image: widget.imageURL ?? "",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        32.hp,
        Text(
          'do_you_want_to_Delete'.tr,
          textAlign: TextAlign.center,
          style: stylew700(size: 18, color: AppColors.color1D2939),
        ),
        4.hp,
        Text(
          'do_you_want_to_Delete_subheading'.tr.tr,
          textAlign: TextAlign.center,
          style: stylew400(size: 14, color: AppColors.color667085),
        ),
        32.hp,
        SafeArea(
          top: false,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      onTap: () {
                        Get.back();
                      },
                      title: "cancel".tr,
                      color: AppColors.colorF2F4F7,
                      fontColor: AppColors.color1D2939,
                      elevation: 0,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: AppButton(
                      onTap: () {
                        widget.handleDelete();
                      },
                      title: "Delete".tr,
                      color: AppColors.colorF97970,
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        16.hp,
      ],
    );
  }
}
