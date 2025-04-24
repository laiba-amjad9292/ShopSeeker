import 'package:shop_seeker/modules/auth/models/action_picker.model.dart';
import 'package:shop_seeker/utils/constants/app_enums.utils.dart';

class AppConstants {
  static List<ActionPickerModel> imageSources = [
    ActionPickerModel(label: 'gallery', icon: 'assets/icons/ic_image.png'),
    ActionPickerModel(label: 'camera', icon: 'assets/icons/ic_camera.png'),
  ];
  static List<ActionPickerModel> mediaTypeList = [
    ActionPickerModel(
      label: AppMediaType.video.typeName,
      icon: 'assets/icons/ic_video.png',
    ),
    ActionPickerModel(
      label: AppMediaType.image.typeName,
      icon: 'assets/icons/ic_image.png',
    ),
  ];

  static double scrollbarThinkness = 4.0;

  static int fullnameLength = 60;
  static int firstnameLength = 50;
  static int lastnameLength = 50;
}
