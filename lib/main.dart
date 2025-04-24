import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shop_seeker/global/widgets/error_handler.widget.dart';

import 'package:shop_seeker/modules/auth/screens/login_or_signUp.screen.dart';
import 'package:shop_seeker/services/user_manager.service.dart';
import 'package:shop_seeker/utils/helpers/easyloading.util.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();

  Get.put(UserManager());

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    EasyLoading.dismiss();
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    Future.delayed(Duration.zero, () {
      EasyLoading.dismiss();
    });
    return true;
  };

  ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
    return CustomError(errorDetails: errorDetails);
  };
  // LocalNotificationChannel.initializer();

  var user = Get.put(UserManager());
  await user.getData();
  // var login = await user.isLogin();
  // log(login.toString());
  // if (login) {
  //   Future.delayed(Duration(seconds: 2), () {
  //     FirebaseUtils.pushNotifications(false);
  //     UserManager.instance.getUser();
  //   });
  // }
  EasyLoading.dismiss();

  runApp(OverlaySupport(child: BoosterMaterialApp()));
}

class BoosterMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: (context, child) {
        return GetMaterialApp(
          title: 'HomePage',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,

          home: LoginOrSignupScreen(),

          // FirebaseAuth.instance.currentUser == null
          //     ? LoginOrSignupScreen()
          //     : BottomNavigationScreen(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.teal),
    );
  }
}
