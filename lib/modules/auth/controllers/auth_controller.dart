import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shop_seeker/global/widgets/dialog/dialog_helpers.widget.dart';
import 'package:shop_seeker/modules/auth/models/user.model.dart';
import 'package:shop_seeker/modules/auth/screens/signUp_success.screen.dart';
import 'package:shop_seeker/modules/bottom_navbar/screens/bottom_nav.screen.dart';
import 'package:shop_seeker/services/database.service.dart';
import 'package:shop_seeker/services/user_manager.service.dart';
import 'package:shop_seeker/utils/helpers/easyloading.util.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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

      showInfo('password_recovery'.tr);

      // forgotPasswordInitialKey.currentState?.patchValue({'email': ""});

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
        showError('Email or Password are incorrect. Please try again');
      }
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      if (e.code == 'user-not-found') {
        showError('No user found with the provided email address');
      } else if (e.code == 'wrong-password') {
        showError('Email or Password are incorrect. Please try again');
      } else {
        showError('Email or Password are incorrect. Please try again');
      }
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
      showError('Email or Password are incorrect. Please try again');
    }
  }

  Future<void> loginWithGoogle() async {
    print("========> loginWithGoogle Start");

    try {
      EasyLoading.show();
      var googleSign = GoogleSignIn(scopes: ["email"]);
      final user = await googleSign.signIn();
      if (user == null) {
        EasyLoading.dismiss();
        print("========> Google Sign-In canceled");
        return;
      }

      print("========> Google User: ${user.email}");
      final googleAuth = await user.authentication;
      print("========> Google Auth: ${googleAuth.accessToken}");

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final authResult = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      print("========> Firebase Sign-In Success: ${authResult.user?.uid}");

      var isUserExist = await Database.isUserExist(authResult.user!.uid);
      print("========> isUserExist: $isUserExist");

      if (!isUserExist) {
        UserModel userModel = UserModel.fromMap({
          "email": authResult.additionalUserInfo?.profile?['email'] ?? "",
          "id": authResult.user?.uid ?? "",
          "name": authResult.additionalUserInfo?.profile?['name'] ?? "",
          "profileImage":
              authResult.additionalUserInfo?.profile?['picture'] ?? "",
          "phone": "",
          "approved": false,
          "signInMethod": "google.com",
        });

        bool userCreated = await Database.createUserInDatabase(userModel);
        print("========> User Created: $userCreated");

        if (userCreated) {
          await UserManager.instance.setData(userModel);
          EasyLoading.dismiss();
          Get.offAll(() => SignupSuccessScreen());
        } else {
          EasyLoading.dismiss();
          showError("something_went_wrong_try_again".tr);
        }
      } else {
        var user = await Database.getUser(authResult.user!.uid);
        if (user == null) {
          EasyLoading.dismiss();
          return;
        }
        await UserManager.instance.setData(user);
        EasyLoading.dismiss();
        Get.offAll(() => BottomNavigationScreen());
      }
    } catch (e, stackTrace) {
      EasyLoading.dismiss();
      print("========> Error: $e\n$stackTrace");
      showError("something_went_wrong_try_again".tr);
    }
  }

  Future<void> loginWithApple() async {
    print("========> loginWithApple");
    try {
      // if (!await Database.connectionStatus.checkConnection()) return;
      EasyLoading.show();
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final oAuthProvider = OAuthProvider('apple.com');
      final cred = oAuthProvider.credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      await FirebaseAuth.instance.signInWithCredential(cred).then((
        value,
      ) async {
        var isUserExist = await Database.isUserExist(value.user!.uid);
        print("isUserExist ========>>>> ${isUserExist}");
        if (!isUserExist) {
          if (value.user != null) {
            UserModel userModel = UserModel.fromMap({
              "email": value.additionalUserInfo!.profile!['email'] ?? "",
              "id": value.user?.uid ?? "",
              "name": value.additionalUserInfo!.profile!['name'] ?? "",
              "profileImage": value.additionalUserInfo!.profile!['image'] ?? "",
              "phone": "",
              "approved": false,
              'signInMethod': "apple.com",
            });
            if (await Database.createUserInDatabase(userModel)) {
              await UserManager.instance.setData(userModel);
              await UserManager.instance.getData();
              await UserManager.instance.getUser();

              EasyLoading.dismiss();
              if (isUserExist) {
                Get.offAll(() => BottomNavigationScreen());
              } else {
                Get.offAll(() => SignupSuccessScreen());
              }

              // FirebaseUtils.pushNotifications(true);
            } else {
              EasyLoading.dismiss();
              showError("something_went_wrong_try_again".tr);
            }
          } else {
            EasyLoading.dismiss();
            showError("something_went_wrong_try_again".tr);
          }
        } else {
          var detail = Get.put(UserManager());
          var user = await Database.getUser(value.user!.uid);
          if (user == null) {
            EasyLoading.dismiss();
            return;
          }
          await UserManager.instance.setData(user);
          await detail.setData(user);
          await detail.getData();
          await UserManager.instance.getUser();

          EasyLoading.dismiss();
          Get.offAll(() => BottomNavigationScreen());
          // FirebaseUtils.pushNotifications(true);
        }
      });
    } catch (e) {
      EasyLoading.dismiss();
      log(e.toString());
      showError(e.toString());
    }
  }
}
