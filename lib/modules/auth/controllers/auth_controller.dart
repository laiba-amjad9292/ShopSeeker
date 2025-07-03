import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/global/widgets/dialog/dialog_helpers.widget.dart';
import 'package:shop_seeker/modules/auth/models/user.model.dart';
import 'package:shop_seeker/modules/auth/screens/signUp_success.screen.dart';
import 'package:shop_seeker/modules/bottom_navbar/screens/bottom_nav.screen.dart';
import 'package:shop_seeker/services/database.service.dart';
import 'package:shop_seeker/services/user_manager.service.dart';
import 'package:shop_seeker/utils/helpers/easyloading.util.dart';

class SignUpController extends GetxController {
  final signupInitialKey = GlobalKey<FormBuilderState>();
  final forgotPasswordInitialKey = GlobalKey<FormBuilderState>();
  final loginInitialKey = GlobalKey<FormBuilderState>();

  bool terms = false;

  void changeTerms(bool? val) {
    terms = !terms;
    update();
  }

  Future<void> handleSignup() async {
    try {
      if (signupInitialKey.currentState?.validate() != true) return;
      EasyLoading.show();
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: signupInitialKey.currentState?.getRawValue("email") ?? "",
            password:
                signupInitialKey.currentState?.getRawValue("password") ?? "",
          );

      if (userCredential.user != null) {
        UserModel userModel = UserModel.fromMap({
          "email": signupInitialKey.currentState?.getRawValue("email") ?? "",
          "id": userCredential.user?.uid ?? "",
          "phone": "",
          "approved": false,
          "name": signupInitialKey.currentState?.getRawValue("name") ?? "",
          "profileImage": "",
          'signInMethod': "email",
        });
        await Database.createUserInDatabase(userModel);
        await UserManager.instance.setData(userModel);
        await UserManager.instance.getData();
        await UserManager.instance.getUser();
        Get.offAll(() => const SignupSuccessScreen());

        EasyLoading.dismiss();
        update();
      } else {
        update();
        showError("something_went_wrong_try_again".tr);
      }
      EasyLoading.dismiss();
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      if (e.code == 'weak-password') {
        showError('password_too_weak'.tr);
      } else if (e.code == 'email-already-in-use') {
        showError('email_already_in_use'.tr);
      }
    } catch (e) {
      EasyLoading.dismiss();
      showError(e.toString());
    }
  }

  Future<void> handleResetPassowrd() async {
    if (forgotPasswordInitialKey.currentState?.validate() != true) return;
    try {
      EasyLoading.show();
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email:
            forgotPasswordInitialKey.currentState?.getRawValue("email") ?? "",
      );

      showInfo('password_recovery'.tr, okText: 'thanks'.tr);

      EasyLoading.dismiss();
      update();
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      if (e.code == 'user-not-found') {
        showError("email_not_found".tr);
      }
    }
  }

  Future<void> handleLogin() async {
    print("========> handleLogin");

    if (loginInitialKey.currentState?.validate() != true) return;

    try {
      EasyLoading.show();
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: loginInitialKey.currentState?.getRawValue("email") ?? "",
            password:
                loginInitialKey.currentState?.getRawValue("password") ?? "",
          );

      if (userCredential.user != null) {
        var user = await Database.getUser(userCredential.user?.uid ?? "");
        if (user == null) {
          EasyLoading.dismiss();
          return;
        }
        print(user);

        await UserManager.instance.getUser();
        await UserManager.instance.setData(user);
        await UserManager.instance.getData();
        await Database.createUserInDatabase(user);

        Get.offAll(() => BottomNavigationScreen());

        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        showError('email_or_password_are_incorrect'.tr);
      }
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      if (e.code == 'user-not-found') {
        showError('no_user_found_with_provided_email'.tr);
      } else if (e.code == 'wrong-password') {
        showError('email_or_password_are_incorrect'.tr);
      } else {
        showError('email_or_password_are_incorrect'.tr);
      }
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
      showError('email_or_password_are_incorrect'.tr);
    }
  }
}
