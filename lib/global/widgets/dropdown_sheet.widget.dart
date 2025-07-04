import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shop_seeker/global/widgets/bottomsheet.widget.dart';
import 'package:shop_seeker/global/widgets/button.widget.dart';
import 'package:shop_seeker/modules/auth/models/action_picker.model.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/constants/app_enums.utils.dart';
import 'package:shop_seeker/utils/extensions/size_extension.util.dart';

class OpenActionSheet<T> {
  Widget? icon(DropDownBottomSheetClass s) {
    if (s.iconType == SheetIconType.asset) {
      return Image.asset(s.iconURL ?? '', height: 25, color: AppColors.primary);
    } else if (s.iconType == SheetIconType.svg) {
      log(s.iconURL ?? '');
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: SvgPicture.asset(s.iconURL ?? '', height: 25, width: 25),
      );
      // } else if (s.iconType == SheetIconType.network) {
      //   return NetworkImageCustom(
      //     image: s.iconURL ?? '',
      //     height: 50,
      //     width: 50,
      //   );
    }
    return null;
  }

  Future<T?> showActionSheet({
    required List<DropDownBottomSheetClass> items,
    required currentItem,
    bool hasSearch = false,
  }) async {
    return await Get.bottomSheet(
      ReusableBottomSheet(
        body: Column(
          children: [
            20.hp,
            ...List.generate(
              items.length,
              (index) => ListTile(
                leading:
                    items[index].iconURL == null || items[index].iconURL == ''
                        ? null
                        : icon(items[index]) ?? const SizedBox.shrink(),
                onTap: () => Get.back(result: items[index]),
                title: Text(items[index].name?.tr ?? ""),
              ),
            ),
            24.hp,
            AppButton(
              title: "cancel".tr,
              color: AppColors.primary30,
              fontColor: AppColors.primary,
              borderSide: const BorderSide(color: AppColors.colorEAECF0),
              onTap: () {
                Get.back();
              },
            ),
            10.hp,
          ],
        ).paddingSymmetric(horizontal: 16),
      ),
      isScrollControlled: true,
    );
  }
}
