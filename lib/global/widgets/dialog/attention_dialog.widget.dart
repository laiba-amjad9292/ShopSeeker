import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/global/widgets/button.widget.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/extensions/size_extension.util.dart';
import 'package:shop_seeker/utils/theme/textStyles.utils.dart';

class DialogueIcons {}

class AttentionDialog extends StatelessWidget {
  const AttentionDialog({
    super.key,
    required this.description,
    required this.onTap,
    this.okText,
    this.trailing,
    this.titleWidget,
    this.title,
    this.cancelText,
    this.icon,
    this.showTittle = true,
    this.showCross = false,
    this.iconColor,
    this.subTittle,
    this.subTitleStyle,
    this.titleStyle,
    this.onCancel,
  });

  final String description;
  final String? title;
  final Widget? titleWidget;
  final String? okText;
  final String? cancelText;
  final Widget? trailing;
  final bool? showTittle;
  final bool? showCross;
  final String? subTittle;
  final TextStyle? subTitleStyle;
  final TextStyle? titleStyle;

  final Function onTap;
  final Function? onCancel;
  final String? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 30.w),
        insetAnimationDuration: Duration.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: contentBox(context),
      ),
    );
  }

  contentBox(context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 3),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            description.tr,
            style: titleStyle ?? stylew600(size: 16, color: AppColors.black),
            textAlign: TextAlign.center,
          ),
          if (trailing != null) ...[8.hp, trailing!, 8.hp],
          30.hp,

          if (subTittle != null) ...[
            Text(
              subTittle ?? "",
              textAlign: TextAlign.center,
              style:
                  subTitleStyle ??
                  stylew400(color: AppColors.color888888, size: 14),
            ),
          ],
          30.hp,
          actions(),
        ],
      ),
    );
  }

  Row actions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (cancelText != null) ...[
          Expanded(
            child: AppButton(
              fontSize: 14,
              elevation: 0,
              isLoading: false,
              title: cancelText?.tr ?? "cancel".tr,
              onTap: () async {
                if (onCancel == null) {
                  Get.back();
                } else {
                  onCancel!();
                }
              },
              color: AppColors.colorF3FAF3,
              fontColor: AppColors.color2D6830,
            ),
          ),
          10.wp,
        ],
        if (okText != null) ...[
          Expanded(
            child: AppButton(
              fontSize: 14,
              elevation: 0,
              isLoading: false,
              title: okText ?? '',
              onTap: () async {
                onTap();
              },
              color: AppColors.primary,
              fontColor: Colors.white,
            ),
          ),
        ],
      ],
    );
  }
}
