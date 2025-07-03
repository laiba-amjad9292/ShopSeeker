import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flick_video_player/flick_video_player.dart';

import 'package:shop_seeker/utils/constants/app_enums.utils.dart';

import 'package:video_player/video_player.dart';

class MediaViewer extends StatefulWidget {
  final String attachment;
  final AppMediaType attachmentType;

  MediaViewer({required this.attachment, required this.attachmentType});

  @override
  _MediaViewerState createState() => _MediaViewerState();
}

class _MediaViewerState extends State<MediaViewer> {
  FlickManager? flickManager;

  bool androidExistNotSave = false;
  bool? isGranted;

  @override
  void initState() {
    super.initState();
    if (widget.attachmentType == AppMediaType.video) {
      flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.networkUrl(
          Uri.parse(widget.attachment),
        ),
      );
    }
  }

  @override
  void dispose() {
    flickManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.download),
          //   onPressed: () {
          //     if (widget.attachmentType == AppMediaType.image) {
          //       _downloadAsset();
          //     } else {
          //       _downloadVideo();
          //     }
          //   },
          // ),
        ],
      ),
      body: Center(
        child:
            widget.attachmentType == AppMediaType.video
                ? FlickVideoPlayer(
                  flickManager: flickManager!,
                  preferredDeviceOrientationFullscreen: [
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown,
                  ],
                )
                : ImageViewer(image: widget.attachment),
      ),
    );
  }

  // _downloadAsset() async {
  //   if (Platform.isAndroid) {
  //     final deviceInfoPlugin = DeviceInfoPlugin();
  //     final deviceInfo = await deviceInfoPlugin.androidInfo;
  //     final sdkInt = deviceInfo.version.sdkInt;

  //     if (androidExistNotSave) {
  //       isGranted = await (sdkInt > 33 ? Permission.photos : Permission.storage)
  //           .request()
  //           .isGranted;
  //     } else {
  //       isGranted =
  //           sdkInt < 29 ? await Permission.storage.request().isGranted : true;
  //     }
  //   } else {
  //     isGranted = await Permission.photosAddOnly.request().isGranted;
  //   }

  //   if (isGranted == false) {
  //     showWarning("Please allow storage permission from app settings.");
  //     return;
  //   }

  //   showInfo("Downloading...");
  //   var response = await Dio().get(widget.attachment.imageUrl ?? "",
  //       options: Options(responseType: ResponseType.bytes));
  //   String picturesPath = "${widget.attachment.title ?? "temp.png"}";
  //   debugPrint(picturesPath);
  //   final result = await SaverGallery.saveImage(
  //     Uint8List.fromList(response.data),
  //     quality: 60,
  //     name: picturesPath,
  //     // androidRelativePath: "Pictures/appName/xx",
  //     androidExistNotSave: false,
  //   );
  //   debugPrint(result.toString());
  //   showToast("Image saved to gallery", context);
  // }

  // _downloadVideo() async {
  //   if (Platform.isAndroid) {
  //     final deviceInfoPlugin = DeviceInfoPlugin();
  //     final deviceInfo = await deviceInfoPlugin.androidInfo;
  //     final sdkInt = deviceInfo.version.sdkInt;

  //     if (androidExistNotSave) {
  //       isGranted = await (sdkInt > 33 ? Permission.photos : Permission.storage)
  //           .request()
  //           .isGranted;
  //     } else {
  //       isGranted =
  //           sdkInt < 29 ? await Permission.storage.request().isGranted : true;
  //     }
  //   } else {
  //     isGranted = await Permission.photosAddOnly.request().isGranted;
  //   }
  //   if (isGranted == false) {
  //     showToast("Please allow storage permission from app settings.", context);
  //     return;
  //   }

  //   showToast("Downloading...", context);
  //   var appDocDir = await getTemporaryDirectory();
  //   String savePath = appDocDir.path + "/temp.mp4";
  //   await Dio().download(widget.attachment.assetUrl ?? "", savePath);
  //   final result = await SaverGallery.saveFile(
  //       file: savePath,
  //       androidExistNotSave: true,
  //       name: "${widget.attachment.title ?? "temp.mp4"}",
  //       androidRelativePath: "Movies");
  //   print(result);
  //   if (result.isSuccess) {
  //     showToast("Video saved to gallery", context);
  //   } else {
  //     showToast("Error downloading the video. Please try again", context);
  //   }
  // }

  Future<bool> _requestPermissions() async {
    if (await Permission.storage.request().isGranted) {
      return true;
    } else {
      Map<Permission, PermissionStatus> statuses =
          await [Permission.storage].request();
      return statuses[Permission.storage] == PermissionStatus.granted;
    }
  }
}

class ImageViewer extends StatelessWidget {
  const ImageViewer({super.key, required this.image});
  final String image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          InteractiveViewer(
            panEnabled: false, // Set it to false
            boundaryMargin: EdgeInsets.all(100),
            minScale: 1,
            maxScale: 2,
            child: Image.network(
              height: double.infinity,
              width: double.infinity,
              image,
              errorBuilder:
                  (context, error, stackTrace) =>
                      Image.asset('assets/images/disclaimer.png'),
            ),
          ),
        ],
      ),
    );
  }
}
