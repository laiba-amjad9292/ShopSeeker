import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shop_seeker/global/widgets/button.widget.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/extensions/size_extension.util.dart';
import 'package:video_player/video_player.dart';

class MediaPreviewPage extends StatefulWidget {
  final String filePath;
  bool isVideo;

  MediaPreviewPage({required this.filePath, this.isVideo = false});

  @override
  _MediaPreviewPageState createState() => _MediaPreviewPageState();
}

class _MediaPreviewPageState extends State<MediaPreviewPage> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    if (widget.isVideo) {
      _videoController = VideoPlayerController.file(File(widget.filePath));
      _videoController?.addListener(() {
        setState(() {});
      });
      _videoController?.setLooping(true);
      _videoController?.initialize().then((_) => setState(() {}));
      _videoController?.play();
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            children: [
              Expanded(
                child: AppButton(
                  title: "ok".tr,
                  onTap: () {
                    Get.back(result: true);
                  },
                ),
              ),
              12.wp,
              Expanded(
                child: AppButton(
                  title: "cancel".tr,
                  elevation: 0,
                  borderSide: const BorderSide(color: AppColors.colorEAECF0),
                  color: AppColors.colorF2F4F7,
                  fontColor: AppColors.color1D2939,
                  onTap: () {
                    Get.back();
                  },
                ),
              ),
            ],
          ).paddingAll(16),
        ),
      ),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child:
              widget.isVideo
                  ? _videoController?.value.isInitialized == true
                      ? AspectRatio(
                        aspectRatio: _videoController?.value.aspectRatio ?? 1,
                        child: VideoPlayer(_videoController!),
                      )
                      : CircularProgressIndicator()
                  : Image.file(File(widget.filePath)),
        ),
      ),
    );
  }
}
