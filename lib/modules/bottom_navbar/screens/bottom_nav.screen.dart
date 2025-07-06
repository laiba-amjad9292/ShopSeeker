import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/global/others/container_properties.dart';
import 'package:shop_seeker/modules/bottom_navbar/controllers/bottom_nav.controller.dart';
import 'package:shop_seeker/modules/chat/screen/all_chat_room.screen.dart';
import 'package:shop_seeker/modules/notifications/screen/notification.screen.dart';
import 'package:shop_seeker/modules/profile/screens/profile.screen.dart';
import 'package:shop_seeker/modules/home/screen/shop.screen.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/theme/textStyles.utils.dart';

// ignore: must_be_immutable
class BottomNavigationScreen extends StatefulWidget {
  bool? fromLogin;
  BottomNavigationScreen({super.key, this.fromLogin = true});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen>
    with SingleTickerProviderStateMixin {
  var controller = Get.put(BottomNavigationController());
  // var myListingsController = Get.put(MyListingsController());

  // var user = Get.put(OrderController());

  @override
  @override
  void initState() {
    super.initState();

    // ✅ Delay tab change until after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.fromLogin == true) {
        controller.changeTab(0);
      }
    });

    controller.animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavigationController>(
      init: BottomNavigationController(),

      builder: (value) {
        return BottomScreen(value);
      },
    );
  }

  // ignore: non_constant_identifier_names
  Container BottomScreen(BottomNavigationController value) {
    return Container(
      decoration: ContainerProperties.shadowDecoration(),
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: Center(
            child: IndexedStack(
              index: value.currentIndex,
              children: [
                Visibility(
                  maintainState: true,
                  visible: value.currentIndex == 0,
                  child: const ShopScreen(),
                ),
                Visibility(
                  maintainState: true,
                  visible: value.currentIndex == 1,
                  child: const ChatScreen(),
                ),

                Visibility(
                  maintainState: false,
                  visible: value.currentIndex == 2,
                  child: const NotificationScreen(),
                ),
                Visibility(
                  maintainState: false,
                  visible: value.currentIndex == 3,
                  child: const ProfileScreen(),
                ),
              ],
            ),
          ),
        ),
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          width: double.infinity,
          height: 85.h,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldColor,
                    border: Border(
                      top: BorderSide(
                        color: AppColors.primary.withOpacity(0.1),
                      ),
                    ),
                    // borderRadius: const BorderRadius.only(
                    //   topLeft: Radius.circular(16),
                    //   topRight: Radius.circular(16),
                    // ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.disabledColor.withOpacity(0.1),
                        offset: const Offset(0, -12),
                        spreadRadius: 0,
                        blurRadius: 40,
                      ),
                    ],
                  ),
                  height: 60.h,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            value.changeTab(0);
                          },
                          child: Container(
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/HomeIcon.png',
                                  height: 22,
                                  color: _iconColor(0, value),
                                ),
                                AutoSizeText(
                                  "home".tr,
                                  style: bottomNavTextStyle(0, value),
                                  maxLines: 1,
                                  minFontSize: 9,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            value.changeTab(1);
                          },
                          child: Container(
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/chat.png',
                                  height: 24,
                                  color: _iconColor(1, value),
                                ),
                                AutoSizeText(
                                  "chats".tr,
                                  style: bottomNavTextStyle(1, value),
                                  maxLines: 1,
                                  minFontSize: 9,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            value.changeTab(2);
                          },
                          child: Container(
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/Notification.png',
                                  height: 24,
                                  color: _iconColor(2, value),
                                ),
                                AutoSizeText(
                                  "notification".tr,
                                  style: bottomNavTextStyle(2, value),
                                  maxLines: 1,
                                  minFontSize: 9,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            value.changeTab(3);
                          },
                          child: Container(
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icons/profile.png',
                                  height: 24,
                                  color: _iconColor(3, value),
                                ),
                                AutoSizeText(
                                  "profile".tr,
                                  style: bottomNavTextStyle(3, value),
                                  maxLines: 1,
                                  minFontSize: 9,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _iconColor(int index, BottomNavigationController value) =>
      controller.currentIndex != index
          ? AppColors.colorAAAAAA
          : AppColors.primary;

  TextStyle bottomNavTextStyle(int index, BottomNavigationController value) {
    return styleRegular(size: 12, color: _iconColor(index, value)).copyWith(
      fontWeight:
          value.currentIndex == index ? FontWeight.bold : FontWeight.normal,
    );
  }
}
