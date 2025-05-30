import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shop_seeker/global/widgets/error_handler.widget.dart';
import 'package:shop_seeker/modules/auth/screens/login_or_signUp.screen.dart';
import 'package:shop_seeker/services/user_manager.service.dart';
import 'package:shop_seeker/utils/bindings/initial_bindings.util.dart';
import 'package:shop_seeker/utils/helpers/easyloading.util.dart';
import 'package:shop_seeker/utils/storage/local_storage.utils.dart';
import 'package:shop_seeker/utils/theme/app_theme.util.dart';
import 'package:shop_seeker/utils/translation/app_translation.util.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      designSize: const Size(360, 690),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: GetMaterialApp(
          title: 'Sooqi',
          themeMode: ThemeMode.light,
          theme: AppTheme.lightTheme(),
          translations: AppTranslations(), // Your translations
          locale:
              LocalGetStorage.getUserLanguage() == 'en'
                  ? const Locale('en')
                  : LocalGetStorage.getUserLanguage() == 'de'
                  ? const Locale('de')
                  : const Locale('ar'),
          fallbackLocale: Locale('en', 'US'), // Fallback locale
          // Add the localizations delegates
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          // Define supported locales
          supportedLocales: const [
            Locale('en', 'US'), // English
            Locale('de', 'DE'), // German
            Locale('ar', 'AR'), //Arabic
          ],
          defaultTransition: Transition.cupertino,
          debugShowCheckedModeBanner: false,
          initialBinding: InitialBinding(),
          home: LoginOrSignupScreen(),
          // FirebaseAuth.instance.currentUser == null
          //     ? LoginOrSignupScreen()
          //     : BottomNavigationScreen(),
        ),
      ),
    );
  }
}
