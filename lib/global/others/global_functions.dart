import 'dart:io';

import 'package:camera/camera.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shop_seeker/global/widgets/bottomSheet.widget.dart';
import 'package:shop_seeker/global/widgets/dialog/dialog.widget.dart';
import 'package:shop_seeker/global/widgets/dialog/dialog_helpers.widget.dart';
import 'package:shop_seeker/global/widgets/dropdown_sheet.widget.dart';
import 'package:shop_seeker/global/widgets/snackbar.widget.dart';
import 'package:shop_seeker/modules/auth/models/action_picker.model.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/constants/app_constants.util.dart';
import 'package:shop_seeker/utils/constants/app_enums.utils.dart';
import 'package:shop_seeker/utils/extensions/container_extension.util.dart';
import 'package:shop_seeker/utils/extensions/size_extension.util.dart';
import 'package:shop_seeker/utils/helpers/easyloading.util.dart';
import 'package:shop_seeker/utils/theme/textStyles.utils.dart';

// import 'package:video_thumbnail/video_thumbnail.dart';

class GlobalFunctions {
  static sessionError({String? body}) async {
    showError(
      body ?? 'session_expired_login_again'.tr,
      onTap: () {
        // Get.find<UserDetail>().logout();
      },
    );
    // logoutUser();
  }

  static unKnownError() async {
    showError('something_went_wrong_try_again'.tr, onTap: () {});
  }

  static showInternetSnackbar() async {
    ShowSnackBar.showSnackBarStatic(content: 'check_your_connection'.tr);
  }

  static showPermissionFailed(String permissionName) async {
    showInfo(
      '${"Please_allow".tr} $permissionName ${"permission_from_app_settings".tr}',
      onSuccess: () {
        openAppSettings();
      },
      okText: 'Open_Settings'.tr,
      cancelText: 'cancel'.tr,
    );
  }

  static void countryCodePickerWidget(
    BuildContext context,
    void Function(Country) onSelect,
  ) {
    return showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: onSelect,
      favorite: ['DE'],
      countryListTheme: CountryListThemeData(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
        bottomSheetHeight: Get.height / 1.2,
        inputDecoration: InputDecoration(
          hintText: 'Search_Country_Code'.tr,
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 15,
          ),
          hintStyle: styleRegular(size: 14, color: AppColors.color667085),
          errorStyle: styleRegular(size: 12, color: AppColors.colorF97970),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.colorEAECF0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.colorEAECF0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.colorF97970),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.colorF97970),
          ),
          isDense: true,
          suffixIconColor: AppColors.colorD0D5DD,
          prefixIconColor: AppColors.primary,
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Icon(Icons.search, size: 25),
          ),
          prefixIconConstraints: BoxConstraints(
            maxWidth: 40.w,
            maxHeight: 43.h,
          ),
          suffixIconConstraints: BoxConstraints(
            maxWidth: 40.w,
            maxHeight: 40.h,
          ),
        ),
        searchTextStyle: stylew500(size: 14),
      ),
    );
  }

  static String getFlagEmoji(String countryCode) {
    return countryCode.toUpperCase().replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397),
    );
  }

  static void showBottomSheet(Widget body) {
    Get.bottomSheet(ReusableBottomSheet(body: body), isScrollControlled: true);
  }

  static int getNumberPlatform() {
    int platformNumber = 0;
    if (Platform.isAndroid) {
      platformNumber = 1;
    } else if (Platform.isIOS) {
      platformNumber = 2;
    } else if (Platform.isMacOS) {
      platformNumber = 3;
    }
    return platformNumber;
  }

  static bool get isTablet => Get.width > 600;

  static Widget showLoading() {
    return Center(
      child: LoadingAnimationWidget.hexagonDots(
        color: AppColors.primary,
        size: 40,
      ),
    );
  }

  static showToastAlert({
    required String strTitle,
    required String strMsg,
    int seconds = 4,
    TOAST_TYPE toastType = TOAST_TYPE.toastSuccess,
  }) {
    Widget widgetM = Container();
    Color iconColor = Colors.green.shade400;
    Color bgColor = AppColors.primary.withOpacity(0.1);
    Icon icon = const Icon(Icons.check, color: Color(0xff1D2939));
    switch (toastType) {
      case TOAST_TYPE.toastInfo:
        iconColor = AppColors.colorFFBF38;
        bgColor = AppColors.colorFFBF38.withOpacity(0.1);
        icon = const Icon(Icons.info, color: AppColors.white);

        break;

      case TOAST_TYPE.toastSuccess:
        iconColor = AppColors.color32D583;
        bgColor = AppColors.primary.withOpacity(0.1);
        icon = const Icon(Icons.check, color: AppColors.white);
        break;

      case TOAST_TYPE.toastError:
        iconColor = AppColors.colorF04438;
        bgColor = AppColors.colorF04438.withOpacity(0.1);
        icon = const Icon(Icons.close, color: AppColors.white);
        break;
    }

    widgetM = Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: iconColor.withOpacity(0.4), width: 2),
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              width: double.infinity,
              child: Column(
                children: [
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 12,
                          bottom: 16,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Container(
                                height: 20,
                                width: 20,
                                padding: EdgeInsets.all(3),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: icon,
                                ),
                              ).bordered(
                                color: iconColor,
                                showBorder: false,
                                radius: 40,
                              ),
                            ).bordered(
                              color: iconColor.withOpacity(0.4),
                              showBorder: false,
                              radius: 40,
                              padding: EdgeInsets.all(6),
                            ),
                            16.wp,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    strTitle.toString().tr,
                                    style: stylew600(
                                      color: AppColors.color101828,
                                      size: 16,
                                    ),
                                  ),
                                  4.hp,
                                  Text(
                                    strMsg.toString().tr,
                                    style: stylew600(
                                      color: AppColors.color475467,
                                      size: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    showSimpleNotification(
      widgetM,
      background: Colors.transparent,
      elevation: 0,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
      duration: Duration(seconds: seconds),
      slideDismissDirection: DismissDirection.up,
    );
  }

  static Future<DateTime?> selectDate(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? maxDate,
    DateTime? firstDate,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime(2000),
      firstDate: firstDate ?? DateTime(2000),
      lastDate: maxDate ?? DateTime(2101),
      helpText: 'select_date_heading'.tr,
      confirmText: 'select_date_ok_button_title'.tr,
      cancelText: 'select_date_cancel_button_title'.tr,
    );
    if (picked != null) {
      return picked;
    }
    return null;
  }

  static Future<DateTime?> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'select_time_heading'.tr,
      confirmText: 'select_time_ok_button_title'.tr,
      cancelText: 'select_time_cancel_button_title'.tr,
    );
    if (picked != null) {
      final now = DateTime.now();
      final selectedTime = now.copyWith(
        minute: picked.minute,
        hour: picked.hour,
      );

      return selectedTime;
    }
    return null;
  }

  static bool equalsIgnoreCase(String? a, String? b) =>
      (a == null && b == null) ||
      (a != null && b != null && a.toLowerCase() == b.toLowerCase());

  static bool checkNull(String? strString) {
    if (strString != null &&
        strString.isNotEmpty &&
        !GlobalFunctions.equalsIgnoreCase(strString, "null")) {
      return true;
    }
    return false;
  }

  static Future<XFile?> pickMedia(
    AppMediaType mediaType, {
    ImageSource? source,
    bool isRear = false,
    bool showPreview = true,
    bool allowCameraSwitching = true,
  }) async {
    if (source == null) {
      ActionPickerModel? action = await OpenActionSheet<ActionPickerModel>()
          .showActionSheet(items: AppConstants.imageSources, currentItem: null);
      if (action == null) return null;
      if (action.label?.toLowerCase() == 'gallery') {
        source = ImageSource.gallery;
      } else {
        source = ImageSource.camera;
      }
    }
    ImagePicker picker = ImagePicker();

    // if (mediaType == AppMediaType.image) {
    //   if (source == ImageSource.camera) {
    //     String? data = await Get.to(
    //       () => CameraScreen(
    //         showPreview: true,
    //         cameraType: isRear ? CameraType.rear : CameraType.front,
    //       ),
    //     );
    //     if (data == null) return null;

    //     return XFile(data);
    //   } else {
    //     return await picker.pickImage(source: source);
    //   }
    // }

    // if (source == ImageSource.camera) {
    //   String? data = await Get.to(
    //     () => const CameraScreen(
    //       appMediaType: AppMediaType.video,
    //       showPreview: true,
    //     ),
    //   );
    //   if (data == null) return null;

    //   return XFile(data);
    // } else {
    //   return await picker.pickVideo(source: source);
    // }
  }

  static showDialog(Widget body) {
    Get.dialog(GenericDialogTemplate(body: body));
  }

  static String capitalizeFirstLetter(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text[0].toUpperCase() + text.substring(1);
  }

  static handleFCMNotification(String action, Map data) async {
    print(action);
    print(data);
    bool fromPage = Get.currentRoute == '/NotificationsScreen';
    if (action == "edit_profile") {
      EasyLoading.show();
      EasyLoading.dismiss();
    } else if (action == "jobs" || action == 'remove_provider') {
      // GlobalFunctions.showBottomSheet(ProfileVerifyBottomSheet());
    } else {
      // Get.to(() => const NotificationsScreen());
    }
  }

  static showAlert({
    required String strTitle,
    required String strMsg,
    int seconds = 4,
    TOAST_TYPE toastType = TOAST_TYPE.toastSuccess,
  }) {
    Widget widgetM = Container();
    Color bgColor = Colors.green.shade400;
    Icon icon = const Icon(Icons.check, color: Color(0xff1D2939));

    switch (toastType) {
      case TOAST_TYPE.toastInfo:
        bgColor = AppColors.colorFFBF38;
        icon = const Icon(Icons.info, color: Color(0xff1D2939));
        break;

      case TOAST_TYPE.toastSuccess:
        bgColor = AppColors.color32D583;
        icon = const Icon(Icons.check, color: Color(0xff1D2939));
        break;

      case TOAST_TYPE.toastError:
        bgColor = AppColors.colorF04438;
        icon = const Icon(Icons.close, color: Color(0xff1D2939));
        break;
    }

    widgetM = Directionality(
      textDirection: TextDirection.rtl, // Adjust based on your requirement
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xff1D2939),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                ),
                alignment: Alignment.center,
                width: double.infinity,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 12,
                    bottom: 16,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Container(
                          height: 20,
                          width: 20,
                          padding: const EdgeInsets.all(3),
                          child: FittedBox(fit: BoxFit.scaleDown, child: icon),
                        ).bordered(
                          color: bgColor,
                          showBorder: false,
                          radius: 40,
                        ),
                      ).bordered(
                        color: bgColor.withOpacity(0.4),
                        showBorder: false,
                        radius: 40,
                        padding: const EdgeInsets.all(6),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              strTitle.toString().tr,
                              style: stylew600(color: Colors.white, size: 16),
                            ),
                            SizedBox(height: 4),
                            Text(
                              strMsg.toString().tr,
                              style: stylew600(
                                color: AppColors.color98A2B3,
                                size: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Builder(
                builder: (context) {
                  final textDirection = Directionality.of(context);
                  final start = textDirection == TextDirection.rtl ? 1.0 : 0.0;
                  final end = textDirection == TextDirection.rtl ? 0.0 : 1.0;

                  return TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: start, end: end),
                    duration: Duration(seconds: seconds),
                    builder: (context, value, child) {
                      return Container(
                        height: 8,
                        width:
                            MediaQuery.of(context).size.width *
                            (textDirection == TextDirection.rtl
                                ? (1 - value)
                                : value),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(8),
                          ),
                        ),
                      );
                    },
                    onEnd: () {
                      OverlaySupportEntry.of(Get.overlayContext!)?.dismiss();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    showSimpleNotification(
      widgetM,
      background: Colors.transparent,
      elevation: 0,
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      duration: Duration(seconds: seconds),
      slideDismissDirection: DismissDirection.up,
    );
  }

  static removeFocus() {
    FocusScope.of(Get.overlayContext!).requestFocus(FocusNode());
  }

  // static video.UserInfo getUserInfo() {
  //   MyProfileModel? data = LocalGetStorage.getUserProfile();
  //   return video.UserInfo(
  //     id: data?.id?.toString() ?? '',
  //     name: data?.fullName ?? "",
  //     image: data?.profilePicture ?? "",
  //   );
  // }

  // static Future<String?> makeVideoThumbnails(String url) async {
  //   final thumbnailPath = VideoThumbnail.thumbnailFile(
  //     video: url,
  //     thumbnailPath: (await getTemporaryDirectory()).path,
  //     imageFormat: ImageFormat.PNG,
  //     maxHeight: 200,
  //     maxWidth: 200,
  //     quality: 100,
  //   );

  //   return thumbnailPath;
  // }

  // static showVideoThumbnail(String video,
  //     {double height = 72, double width = 72}) {
  //   return FutureBuilder<String?>(
  //       future: makeVideoThumbnails(video),
  //       builder: (_, data) {
  //         if (data.hasData == false || data.hasError || data.data == null) {
  //           return const SizedBox.shrink();
  //         } else {
  //           return SizedBox(
  //             height: height.h,
  //             width: width.h,
  //             child: Image.file(
  //               File(data.data ?? ''),
  //               height: height.h,
  //               width: width.h,
  //             ),
  //           ).bordered(radius: 8, color: Colors.black);
  //         }
  //       });
  // }
}
