import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/global/widgets/button.widget.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/extensions/container_extension.util.dart';
import 'package:shop_seeker/utils/extensions/size_extension.util.dart';
import 'package:shop_seeker/utils/helpers/hex_color.util.dart';
import 'package:shop_seeker/utils/theme/textStyles.utils.dart';

class DialogueIcons {
  static String info = 'assets/icons/ic_alert_circle.png';
  static String success = 'assets/icons/ic_check_circle_ok.png';
  static String warning = 'assets/icons/ic_alert_triangle.png';
  static String error = 'assets/icons/ic_alert_octagon.png';
}

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
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
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
          // _buildTitle(),
          if (showCross == true)
            Row(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    if (onCancel == null) {
                      Get.back();
                    } else {
                      onCancel!();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    child: const Icon(
                      Icons.close,
                      size: 17,
                      color: AppColors.black,
                    ),
                  ).bordered(borderColor: Colors.black, radius: 60),
                ),
              ],
            ),
          10.hp,
          Text(
            description.tr,
            style:
                titleStyle ??
                stylew600(size: 14, color: const Color(0xff50545D)),
            textAlign: TextAlign.center,
          ),
          if (trailing != null) ...[8.hp, trailing!, 8.hp],
          30.hp,
          if (titleWidget == null) ...[
            Image.asset(icon ?? DialogueIcons.info, width: 60),
          ] else ...[
            titleWidget ?? Container(),
          ],
          if (subTittle != null) ...[
            Padding(
              padding: const EdgeInsets.only(
                top: 30,
                bottom: 0,
                left: 10,
                right: 10,
              ),
              child: Text(
                subTittle ?? "",
                textAlign: TextAlign.center,
                style:
                    subTitleStyle ??
                    stylew400(color: HexColor('#FFB73F'), size: 14),
              ),
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
