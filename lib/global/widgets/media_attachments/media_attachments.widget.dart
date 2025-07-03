import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_seeker/global/others/global_functions.dart';
import 'package:shop_seeker/global/widgets/dropdown_sheet.widget.dart';
import 'package:shop_seeker/global/widgets/media_attachments/image_preview_dialog.widget.dart';
import 'package:shop_seeker/global/widgets/network_image/custom_network_image.widget.dart';
import 'package:shop_seeker/modules/auth/models/action_picker.model.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/constants/app_constants.util.dart';
import 'package:shop_seeker/utils/constants/app_enums.utils.dart';
import 'package:shop_seeker/utils/extensions/container_extension.util.dart';
import 'package:shop_seeker/utils/extensions/size_extension.util.dart';
import 'package:shop_seeker/utils/extensions/string_extension.utils.dart';
import 'package:shop_seeker/utils/theme/textStyles.utils.dart';

class AttachmentsWidget extends StatefulWidget {
  final List<String> images;
  final List<String> videos;
  final String? heading;
  final int minimumAttachments;
  final bool? onlyImage;
  final Function(XFile file, AppMediaType type)? handleUploadFile;
  final Function(int i, AppMediaType typ)? handleDeleteMedia;

  const AttachmentsWidget({
    super.key,
    required this.images,
    required this.videos,
    this.handleUploadFile,
    this.minimumAttachments = 0,
    this.handleDeleteMedia,
    this.onlyImage = false,
    this.heading,
  });

  @override
  State<AttachmentsWidget> createState() => _AttachmentsWidgetState();
}

class _AttachmentsWidgetState extends State<AttachmentsWidget> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickMedia() async {
    if (widget.onlyImage == true) {
      XFile? file = await GlobalFunctions.pickMedia(
        AppMediaType.image,
        isRear: true,
      );
      if (file != null) {
        widget.handleUploadFile!(file, AppMediaType.image);
      }
    } else {
      AppMediaType selectedMedia = AppMediaType.image;

      ActionPickerModel? action = await OpenActionSheet<ActionPickerModel>()
          .showActionSheet(
            items: AppConstants.mediaTypeList,
            currentItem: null,
          );
      if (action == null) return;
      if (action.label == AppMediaType.video.value) {
        selectedMedia = AppMediaType.video;
      } else {
        selectedMedia = AppMediaType.image;
      }
      XFile? file = await GlobalFunctions.pickMedia(
        selectedMedia,
        isRear: true,
      );
      if (file != null) {
        widget.handleUploadFile!(file, selectedMedia);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.heading ?? 'attachment_preview_heading'.tr,
            style: stylew600(size: 14),
          ),
          12.hp,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (widget.handleUploadFile != null)
                GestureDetector(
                  onTap: _pickMedia,
                  child: DottedBorder(
                    color: AppColors.primary,
                    strokeWidth: 2,
                    dashPattern: const [5, 5],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(8),
                    child: Container(
                      width: 68.w,
                      height: 68.h,
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          size: 30,
                          color: AppColors.primary,
                        ),
                      ),
                    ).bordered(
                      color: AppColors.primary.withOpacity(0.2),
                      showBorder: false,
                      radius: 8,
                    ),
                  ),
                ),
              ...List.generate(widget.images.length, (i) {
                return Stack(
                  children: [
                    GestureDetector(
                      onTap:
                          () => showDialog(
                            context: context,
                            builder:
                                (context) => ImagePreviewDialog(
                                  imageUrls: widget.images,
                                  initialImageUrl: widget.images[i],
                                ),
                          ),
                      child:
                          widget.images[i].isVideoUrl
                              ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  // GlobalFunctions.showVideoThumbnail(
                                  //     widget.images[i]),
                                  SizedBox(
                                    height: 72.h,
                                    width: 72.h,
                                  ).bordered(radius: 8, color: Colors.black26),
                                  const Icon(
                                    Icons.play_arrow,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ],
                              )
                              : ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                child: NetworkImageCustom(
                                  image: widget.images[i],
                                  height: 72.h,
                                  width: 72.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                    ),
                    if (widget.handleDeleteMedia != null &&
                        [...widget.images, ...widget.videos].length >
                            widget.minimumAttachments) ...[
                      GestureDetector(
                        onTap:
                            () => widget.handleDeleteMedia!(
                              i,
                              widget.images[i].isVideoUrl
                                  ? AppMediaType.video
                                  : AppMediaType.image,
                            ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.grey,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              }),
            ],
          ),
          10.hp,
        ],
      ),
    );
  }
}
