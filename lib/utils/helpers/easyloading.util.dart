import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';

class EasyLoading {
  static bool isShow = false;

  static Future<void> show() async {
    isShow = true;
    SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light);
    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black);
    SVProgressHUD.setHapticsEnabled(false);
    SVProgressHUD.show();
  }

  static Future<void> dismiss() async {
    isShow = false;
    SVProgressHUD.dismiss(delay: const Duration(milliseconds: 100));
  }
}
