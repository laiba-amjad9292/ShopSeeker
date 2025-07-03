import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/global/widgets/button.widget.dart';
import 'package:shop_seeker/global/widgets/media_attachments/media_viewer.widget.dart';
import 'package:shop_seeker/global/widgets/network_image/custom_network_image.widget.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/constants/app_enums.utils.dart';
import 'package:shop_seeker/utils/extensions/container_extension.util.dart';
import 'package:shop_seeker/utils/extensions/size_extension.util.dart';
import 'package:shop_seeker/utils/extensions/string_extension.utils.dart';
import 'package:shop_seeker/utils/theme/textStyles.utils.dart';

class ImagePreviewDialog extends StatelessWidget {
  final List<String> imageUrls;
  final String initialImageUrl;

  const ImagePreviewDialog({
    super.key,
    required this.imageUrls,
    required this.initialImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    int initialIndex = imageUrls.indexOf(initialImageUrl);
    PageController pageController = PageController(initialPage: initialIndex);

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    imageUrls[0].isVideoUrl
                        ? 'video_preview_dialog_heading'.tr
                        : 'image_preview_dialog_heading'.tr,
                    textAlign: TextAlign.right,
                    style: stylew700(size: 14, color: AppColors.color101828),
                  ),
                ],
              ),
            ),
            Container(
              height: 320.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.w),
              ),
              child: PageView.builder(
                controller: pageController,
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    child:
                        imageUrls[index].isVideoUrl
                            ? MediaViewer(
                              attachment: imageUrls[index],
                              attachmentType: AppMediaType.video,
                            )
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(8.w),
                              child: InteractiveViewer(
                                child: NetworkImageCustom(
                                  image: imageUrls[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                  );
                },
              ),
            ),
            16.hp,
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    imageUrls.map((url) {
                      int index = imageUrls.indexOf(url);
                      return GestureDetector(
                        onTap: () {
                          pageController.jumpToPage(index);
                        },
                        child: Padding(
                          padding:
                              index == 0
                                  ? EdgeInsets.only(left: 16.w, right: 4.w)
                                  : index == imageUrls.length - 1
                                  ? EdgeInsets.only(left: 4.w, right: 16.w)
                                  : EdgeInsets.symmetric(horizontal: 4.w),
                          child:
                              url.isVideoUrl
                                  ? Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // GlobalFunctions.showVideoThumbnail(
                                      //   url,
                                      //   height: 50,
                                      //   width: 50,
                                      // ),
                                      SizedBox(
                                        height: 50.h,
                                        width: 50.h,
                                      ).bordered(
                                        radius: 8,
                                        color: Colors.black26,
                                      ),
                                      const Icon(
                                        Icons.play_arrow,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    ],
                                  )
                                  : ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    child: NetworkImageCustom(
                                      image: url,
                                      width: 50.h,
                                      height: 50.h,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                        ),
                      );
                    }).toList(),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.h),
              child: AppButton(
                title: "go_back".tr,
                onTap: () {
                  Get.back();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
