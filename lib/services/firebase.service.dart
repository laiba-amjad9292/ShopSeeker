import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:petfinder/services/local_notification_helper.service.dart';
import 'package:url_launcher/url_launcher.dart';

class FirebaseUtils {
  static Future<void> pushNotifications(bool firstTime) async {
    // if (await Permission.notification.isPermanentlyDenied) {
    //   Global.showToastAlert(
    //       context: Get.overlayContext!,
    //       strTitle: "ok",
    //       seconds: 6,
    //       strMsg:
    //           'It is recommended you enabled notifications for the Say Hello app in the OS settings',
    //       toastType: TOAST_TYPE.toastInfo);
    //   return;
    // }
    PermissionStatus status = await Permission.notification.request();
    if (status == PermissionStatus.limited ||
        status == PermissionStatus.granted) {
    } else {
      if (firstTime && Platform.isAndroid) {
        // Get.to(() => AllowNotifications());
      } else {
        // Global.showToastAlert(
        //     context: Get.overlayContext!,
        //     strTitle: "ok",
        //     seconds: 6,
        //     strMsg:
        //         'It is recommended you enabled notifications for the Say Hello app in OS settings',
        //     toastType: TOAST_TYPE.toastInfo);
      }
      return;
    }
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    } else {
      print('User declined or has not accepted permission');
    }

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print("${message.data}");
        if (message.data.isNotEmpty) {
          if ((message.data['iosUrl'] as String).contains('http') &&
              Platform.isIOS) {
            launchUrl(Uri.parse(message.data['iosUrl']));
          } else if ((message.data['androidUrl'] as String).contains('http') &&
              Platform.isAndroid) {
            launchUrl(Uri.parse(message.data['androidUrl']));
          }
        }
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("${message.data}");
      // LocalNotificationChannel.display(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("${message.data}");
      if (message.data.isNotEmpty) {
        if ((message.data['iosUrl'] as String).contains('http') &&
            Platform.isIOS) {
          launchUrl(Uri.parse(message.data['iosUrl']));
        } else if ((message.data['androidUrl'] as String).contains('http') &&
            Platform.isAndroid) {
          launchUrl(Uri.parse(message.data['androidUrl']));
        }
      }
    });

    messaging.subscribeToTopic('sayhello');
    // Get.find<NotificationsController>().getNotificationDate();
    // Database.checkVersion();
  }
}
