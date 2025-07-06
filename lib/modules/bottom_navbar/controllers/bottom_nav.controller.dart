import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/modules/bottom_navbar/screens/bottom_nav.screen.dart';

class BottomNavigationController extends GetxController {
  int currentIndex = 0;
  static BottomNavigationController get instance =>
      Get.find<BottomNavigationController>();

  changeTab(int index) {
    currentIndex = index;
    update();
  }

  gotoHome() {
    changeTab(0);
    Get.offAll(() => BottomNavigationScreen(fromLogin: false));
  }

  gotoMyListingsScreen() {
    changeTab(2);
    Get.off(() => BottomNavigationScreen(fromLogin: false));
  }

  gotoMyChatScreen() {
    changeTab(1);
    Get.off(() => BottomNavigationScreen(fromLogin: false));
  }

  onChangeBottomBar(int index) {
    update();
    switch (index) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
    }
  }

  late AnimationController animationController;
  double maxSlide = 225.0;

  void toggle() =>
      animationController.isDismissed
          ? animationController.forward()
          : animationController.reverse();
}
