import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin ShowSnackBar {
  void showSnackBar({required String content, Color color = Colors.black}) {
    final sb = SnackBar(
      padding: const EdgeInsetsDirectional.all(17),
      content: Text(content),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(
      Get.context!,
    ).hideCurrentSnackBar(reason: SnackBarClosedReason.swipe);

    ScaffoldMessenger.of(Get.context!).showSnackBar(sb);
  }

  static void showSnackBarStatic({
    required String content,
    Color color = Colors.black,
  }) {
    final sb = SnackBar(
      padding: const EdgeInsetsDirectional.all(17),
      content: Text(content),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(
      Get.context!,
    ).hideCurrentSnackBar(reason: SnackBarClosedReason.swipe);
    ScaffoldMessenger.of(Get.context!).showSnackBar(sb);
  }
}
