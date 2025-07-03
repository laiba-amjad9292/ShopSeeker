import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/global/others/global_functions.dart';
import 'package:shop_seeker/global/widgets/image_picker.widget.dart/media_preview.widget.dart';
import 'package:shop_seeker/utils/constants/app_enums.utils.dart';
import 'package:shop_seeker/utils/helpers/easyloading.util.dart';
import 'package:shop_seeker/utils/helpers/hex_color.util.dart';
import 'package:shop_seeker/utils/theme/textStyles.utils.dart';
import 'package:video_player/video_player.dart';
import 'package:image/image.dart' as img;

/// Camera example home widget.
class CameraScreen extends StatefulWidget {
  final Function(String? file)? onDone;
  final CropperScreenType cameraScreenType;
  final CameraType cameraType;
  final AppMediaType appMediaType;
  final bool showPreview;
  const CameraScreen({
    super.key,
    this.onDone,
    this.showPreview = false,
    this.appMediaType = AppMediaType.image,
    this.cameraScreenType = CropperScreenType.full,
    this.cameraType = CameraType.rear,
  });

  @override
  State<CameraScreen> createState() {
    return _CameraScreenState();
  }
}

void _logError(String code, String? message) {
  if (message != null) {
    print('Error: $code\nError Message: $message');
  } else {
    print('Error: $code');
  }
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraType cameraType = CameraType.rear;
  AppMediaType mediaType = AppMediaType.image;
  VideoStates videoState = VideoStates.idle;
  double paddingValue = 0.0;
  late Timer timer;
  int recordedMinutes = 0;
  int recordedSeconds = 0;
  bool get _isImage => mediaType == AppMediaType.image;
  bool get _isRecording => videoState == VideoStates.recording;
  CameraController? controller;
  XFile? imageFile;
  XFile? videoFile;
  VideoPlayerController? videoController;
  VoidCallback? videoPlayerListener;
  bool enableAudio = true;
  bool isInitialized = false;

  recordingTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_isRecording) {
        setState(() {
          recordedSeconds += 1;
          if (recordedSeconds == 60) {
            recordedSeconds = 0;
            recordedMinutes += 1;
          }
        });
      } else {
        setState(() {
          recordedMinutes = 0;
          recordedSeconds = 0;
        });
        t.cancel();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  List<CameraDescription> cameras = [];
  initCameras() async {
    cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      onNewCameraSelected(
        widget.cameraType == CameraType.front ? cameras[1] : cameras[0],
      );
    }
  }

  @override
  void initState() {
    cameraType =
        widget.cameraType == CameraType.any
            ? CameraType.rear
            : CameraType.front;
    mediaType = widget.appMediaType;
    super.initState();
    initCameras();
    _ambiguate(WidgetsBinding.instance)?.addObserver(this);
  }

  @override
  void dispose() {
    _ambiguate(WidgetsBinding.instance)?.removeObserver(this);
    controller?.dispose();

    super.dispose();
  }

  double hightMinue(double height) {
    return (height -
        (height /
            (widget.cameraScreenType == CropperScreenType.full ? 4.5 : 1.5)));
  }

  @override
  Widget build(BuildContext context) {
    print(controller?.value.previewSize?.height.toString() ?? '');
    return Scaffold(
      body:
          (controller?.value.isInitialized == false)
              ? const Center()
              : Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.black,
                child: Stack(
                  children: [
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      child: Center(child: _cameraPreviewWidget()),
                    ),
                    _captureButton(),
                  ],
                ),
              ),
    );
  }

  Positioned _captureButton() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Column(
        children: [
          if (!_isImage)
            Text(
              _getTimeString(),
              style: styleRegular().copyWith(color: Colors.white),
            ),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.20),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: 55,
                  width: 55,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                      margin: const EdgeInsets.all(4),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            _isImage || _isRecording == false
                                ? Colors.white
                                : HexColor('#F15A31'),
                          ),
                          overlayColor: MaterialStateProperty.resolveWith((
                            states,
                          ) {
                            return states.contains(MaterialState.pressed)
                                ? Colors.grey.shade400
                                : null;
                          }),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(200),
                            ),
                          ),
                        ),
                        onPressed: _isImage ? _onPressImage : _onPressVideo,
                        child: const Text(''),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                if (widget.cameraType != CameraType.front &&
                    _isRecording == false) ...[
                  GestureDetector(
                    onTap: () {
                      if (cameraType == CameraType.rear) {
                        onNewCameraSelected(cameras[0]);
                        cameraType = CameraType.front;
                      } else {
                        onNewCameraSelected(cameras[1]);
                        cameraType = CameraType.rear;
                      }
                    },
                    child: Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.20),
                      ),
                      child: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ] else ...[
                  SizedBox(width: 28.w, height: 28.h),
                ],
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _onPressVideo() {
    if (VideoStates.idle == videoState) {
      setState(() {
        paddingValue = 13;
        videoState = VideoStates.recording;
        onVideoRecordButtonPressed();
        recordingTimer();
      });
    } else {
      setState(() {
        paddingValue = 0;
        videoState = VideoStates.idle;
        onStopButtonPressed();
      });
    }
  }

  void _onPressImage() {
    final CameraController? cameraController = controller;
    if (cameraController != null &&
        cameraController.value.isInitialized &&
        !cameraController.value.isRecordingVideo) {
      onTakePictureButtonPressed();
    }
  }

  Widget _cameraPreviewWidget() {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return const Text(
        '',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return CameraPreview(controller!);
    }
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final CameraController cameraController = controller!;

    final Offset offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    try {
      final CameraController? oldController = controller;
      if (oldController != null) {
        controller = null;
        await oldController.dispose();
      }

      final CameraController cameraController = CameraController(
        cameraDescription,
        ResolutionPreset.max,
        enableAudio: enableAudio,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      controller = cameraController;

      // If the controller is updated then update the UI.
      cameraController.addListener(() {
        if (mounted) {
          setState(() {});
        }
        if (cameraController.value.hasError) {
          showInSnackBar(
            'Camera error ${cameraController.value.errorDescription}',
          );
        }
      });

      cameraController
          .initialize()
          .then((_) {
            if (!mounted) {
              return;
            }
            controller?.setFlashMode(FlashMode.off);
            setState(() {});
          })
          .catchError((Object e) {
            Get.back();
            GlobalFunctions.showPermissionFailed('Camera and Audio');
          });

      await Future.wait(<Future<Object?>>[]);
    } on CameraException catch (e) {
      Get.back();
      GlobalFunctions.showPermissionFailed('Camera and Audio');
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> onTakePictureButtonPressed() async {
    EasyLoading.show();
    await takePicture().then((XFile? file) async {
      if (mounted) {
        setState(() {
          imageFile = file;
        });
        if (file != null) {
          EasyLoading.dismiss();
          if (widget.onDone != null) {
            widget.onDone!(file.path);
          }
          if (widget.showPreview) {
            bool? isDone = await Get.to(MediaPreviewPage(filePath: file.path));
            if (isDone == true) {
              Get.back(result: file.path);
            }
          } else {
            Get.back(result: file.path);
          }
        }
      }
    });
    // EasyLoading.dismiss();
  }

  final double containerWidth = 200;
  final double containerHeight = 250;
  final double aspectRatio = 2;
  Future<File?> resizeImage(
    String imagePath,
    int targetWidth,
    int targetHeight,
  ) async {
    File imageFile = File(imagePath);
    Uint8List imageData = await imageFile.readAsBytes();
    img.Image originalImage = img.decodeImage(imageData)!;

    // Crop image
    img.Image croppedImage = img.copyCrop(
      originalImage,
      x: (Get.width / 2).toInt(),
      y: (Get.height / 2).toInt(),
      width: (Get.width - 16).toInt(),
      height: 300,
    );

    return File(imagePath).writeAsBytes(img.encodePng(croppedImage));

    // Calculate the aspect ratio
  }

  void onAudioModeButtonPressed() {
    enableAudio = !enableAudio;
    if (controller != null) {
      onNewCameraSelected(controller!.description);
    }
  }

  Future<void> onCaptureOrientationLockButtonPressed() async {
    try {
      if (controller != null) {
        final CameraController cameraController = controller!;
        if (cameraController.value.isCaptureOrientationLocked) {
          await cameraController.unlockCaptureOrientation();
          showInSnackBar('Capture orientation unlocked');
        } else {
          await cameraController.lockCaptureOrientation();
          showInSnackBar(
            'Capture orientation locked to ${cameraController.value.lockedCaptureOrientation.toString().split('.').last}',
          );
        }
      }
    } on CameraException catch (e) {
      _showCameraException(e);
    }
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((_) {});
  }

  void onStopButtonPressed() {
    stopVideoRecording().then((XFile? file) async {
      if (mounted) {
        setState(() {});
      }
      if (file != null) {
        videoFile = file;
        if (widget.showPreview) {
          bool? isDone = await Get.to(
            MediaPreviewPage(filePath: file.path, isVideo: true),
          );
          if (isDone == true) {
            Get.back(result: file.path);
          }
        } else {
          Get.back(result: file.path);
        }
      }
    });
  }

  void onPauseButtonPressed() {
    pauseVideoRecording().then((_) {
      if (mounted) {
        setState(() {});
      }
      showInSnackBar('Video recording paused');
    });
  }

  void onResumeButtonPressed() {
    resumeVideoRecording().then((_) {
      if (mounted) {
        setState(() {});
      }
      showInSnackBar('Video recording resumed');
    });
  }

  Future<void> startVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return;
    }

    if (cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    try {
      await cameraController.startVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return;
    }
  }

  Future<XFile?> stopVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      return cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  Future<void> pauseVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController.pauseVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController.resumeVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setExposureMode(ExposureMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setExposureMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setExposureOffset(double offset) async {
    if (controller == null) {
      return;
    }

    try {
      offset = await controller!.setExposureOffset(offset);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    _logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  String _getTimeString() {
    if (recordedSeconds < 10) {
      return '0$recordedMinutes:0$recordedSeconds';
    }
    return '0$recordedMinutes:$recordedSeconds';
  }
}

T? _ambiguate<T>(T? value) => value;
