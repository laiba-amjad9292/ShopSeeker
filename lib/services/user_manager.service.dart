import 'dart:developer';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_seeker/modules/auth/models/user.model.dart';
import 'package:shop_seeker/services/database.service.dart';
import 'package:shop_seeker/utils/storage/local_storage.utils.dart';


class UserManager extends GetxController {
  static UserManager get instance => Get.find<UserManager>();

  String userId = '';
  String name = '';
  String profileImage = '';
  String email = '';
  String phone = '';
  String token = '';
  bool islogin = false;
  String signInMethod = '';
  String currentLang = 'de';
  UserModel? user;

  Future<void> getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    name = sharedPreferences.getString('name') ?? '';
    userId = sharedPreferences.getString('id') ?? '';
    email = sharedPreferences.getString('email') ?? '';
    profileImage = sharedPreferences.getString('profileImage') ?? '';
    phone = sharedPreferences.getString('phone') ?? '';
    token = sharedPreferences.getString('token') ?? '';
    signInMethod = sharedPreferences.getString('signInMethod') ?? '';
    islogin = sharedPreferences.getBool('islogin') ?? false;
    update();
  }

  Future<void> changeLanguage(String value) async {
    Get.updateLocale(Locale(value));
    LocalGetStorage.setEnglishLanguage(value == 'en');
    currentLang = value;
    update(['lang']);
  }

  Future<void> getUser() async {
    user = await Database.getUser(FirebaseAuth.instance.currentUser?.uid ?? "");
    update();

    log('user?.permissions?[0] =>>>>>>>>>>>>>>> ${user?.permissions}');
  }

  Future<void> setData(UserModel user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('name', user.name);
    await sharedPreferences.setString('id', user.id);
    await sharedPreferences.setString('email', user.email);
    await sharedPreferences.setString('profileImage', user.profileImage);
    await sharedPreferences.setString('phone', user.phone);
    await sharedPreferences.setString('token', user.token ?? "");
    await sharedPreferences.setString('signInMethod', user.signInMethod);
    await sharedPreferences.setBool('islogin', true);
    await sharedPreferences.setString('gender', user.gender ?? "");
    await getData();
    update();
  }

  Future<bool> isLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool('islogin') ?? false;
  }

  Future<void> logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    await sharedPreferences.remove('islogin');

    // await FirebaseAuth.instance.currentUser!.delete();
    await FirebaseAuth.instance.signOut();
    // Get.offAll(() => const LoginScreen());
  }

  Future<void> updateImage(String n) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('profileImage', n);
    profileImage = n;
    update();
  }

  Future<void> updateProfile(String ln, img) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('name', name);
    await sharedPreferences.setString('profileImage', img);
    profileImage = img;
    name = name;
    update();
  }

  @override
  void onInit() {
    currentLang = LocalGetStorage.getUserLanguage();
    super.onInit();
  }
}
