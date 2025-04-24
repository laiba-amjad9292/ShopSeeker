import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shop_seeker/global/others/global_functions.dart';
import 'package:shop_seeker/global/widgets/dialog/attention_dialog.widget.dart';
import 'package:shop_seeker/utils/constants/app_enums.utils.dart';
import 'package:shop_seeker/utils/helpers/easyloading.util.dart';

void showError(
  message, {
  Function()? onTap,
  String? cancelText,
  String okText = 'Ok',
  String? icon,
  bool isHtml = false,
}) {
  EasyLoading.dismiss();
  GlobalFunctions.showToastAlert(
    strTitle: 'error_occur'.tr,
    strMsg: message,
    toastType: TOAST_TYPE.toastError,
  );
  return;
}
// }

void showWarning(
  message, {
  Function()? onTap,
  String? cancelText,
  String okText = 'Ok',
  String? icon,
  bool isHtml = false,
}) {
  EasyLoading.dismiss();

  GlobalFunctions.showToastAlert(
    strTitle: 'action_req'.tr,
    strMsg: message,
    toastType: TOAST_TYPE.toastInfo,
  );
  return;
}

void showSuccess(
  String message, {
  Function()? onSuccess,
  Function()? onCancel,
  bool isHtml = false,
  String? okText = "OK",
  String? cancelTest,
  String? subTitle,
  TextStyle? subTitleStyle,
  TextStyle? titleStyle,
}) {
  EasyLoading.dismiss();
  GlobalFunctions.showToastAlert(
    strTitle: 'success'.tr,
    strMsg: message,
    toastType: TOAST_TYPE.toastSuccess,
  );
  return;
}

Future<bool?> showInfo(
  message, {
  Function()? onSuccess,
  String? cancelText,
  bool? showCross,
  String? tittle,
  String? okText = 'Ok',
  bool? isHtml,
}) async {
  EasyLoading.dismiss();
  return await Get.dialog<bool?>(
    transitionDuration: Duration.zero,
    AttentionDialog(
      description: message.toString(),
      title: tittle ?? 'attention'.tr,
      okText: okText,
      cancelText: cancelText,
      showCross: showCross,
      icon: DialogueIcons.info,
      onTap: () {
        Get.back(result: true);
        if (onSuccess != null) {
          onSuccess();
        }
      },
    ),
  );
}
