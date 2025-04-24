import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/modules/auth/screens/extra.screen.dart';

import 'package:shop_seeker/modules/bottom_navbar/controllers/bottom_nav.controller.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/theme/textStyles.utils.dart';

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
  void initState() {
    if (widget.fromLogin == true) {
      controller.changeTab(0);
    }
    super.initState();
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

  Container BottomScreen(BottomNavigationController value) {
    return Container(
      // decoration: ContainerProperties.shadowDecoration(),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        body: Center(
          child: Text(
            "Bottom navigation screen ",
            style: stylew700(color: Colors.red),
          ),
        ),
        // body: SafeArea(
        //   top: false,
        //   child: Center(
        //     child: IndexedStack(
        //       index: value.currentIndex,
        //       children: [
        //         Visibility(
        //           maintainState: true,
        //           visible: value.currentIndex == 0,
        //           child: extra(),
        //         ),
        //         Visibility(
        //           maintainState: true,
        //           visible: value.currentIndex == 1,
        //           child: const extra(),
        //         ),
        //         Visibility(
        //           maintainState: false,
        //           visible: value.currentIndex == 2,
        //           child: extra(),
        //         ),
        //         Visibility(
        //           maintainState: false,
        //           visible: value.currentIndex == 3,
        //           child: extra(),
        //         ),
        //         Visibility(
        //           maintainState: false,
        //           visible: value.currentIndex == 4,
        //           child: const extra(),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        // extendBody: true,
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: Container(
        //   width: double.infinity,
        //   height: 85.h,
        //   child: Stack(
        //     children: [
        //       Align(
        //         alignment: Alignment.bottomCenter,
        //         child: Container(
        //           padding: EdgeInsets.symmetric(horizontal: 10.w),
        //           decoration: BoxDecoration(
        //             color: AppColors.scaffoldColor,
        //             border: Border(
        //               top: BorderSide(
        //                 color: AppColors.primary.withOpacity(0.4),
        //               ),
        //             ),
        //             borderRadius: const BorderRadius.only(
        //               topLeft: Radius.circular(16),
        //               topRight: Radius.circular(16),
        //             ),
        //             boxShadow: [
        //               BoxShadow(
        //                 color: AppColors.disabledColor.withOpacity(0.1),
        //                 offset: const Offset(0, -12),
        //                 spreadRadius: 4,
        //                 blurRadius: 40,
        //               ),
        //             ],
        //           ),
        //           height: 60.h,
        //           child: Row(
        //             children: [
        //               Expanded(
        //                 child: GestureDetector(
        //                   onTap: () {
        //                     value.changeTab(0);
        //                   },
        //                   child: Container(
        //                     color: Colors.transparent,
        //                     alignment: Alignment.center,
        //                     child: Image.asset(
        //                       'assets/icons/ic_home.png',
        //                       height: 22,
        //                       color: _iconColor(0, value),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //               Expanded(
        //                 child: GestureDetector(
        //                   onTap: () {
        //                     value.changeTab(1);
        //                   },
        //                   child: Container(
        //                     color: Colors.transparent,
        //                     alignment: Alignment.center,
        //                     child: Image.asset(
        //                       "assets/icons/ic_chat.png",
        //                       height: 24,
        //                       color: _iconColor(1, value),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //               Expanded(
        //                 child: GestureDetector(
        //                   onTap: () {
        //                     value.changeTab(2);
        //                   },
        //                   child: Container(
        //                     color: Colors.transparent,
        //                     alignment: Alignment.center,
        //                     child: Image.asset(
        //                       'assets/icons/ic_products.png',
        //                       height: 24,
        //                       color: _iconColor(2, value),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //               Expanded(
        //                 child: GestureDetector(
        //                   onTap: () {
        //                     value.changeTab(3);
        //                   },
        //                   child: Container(
        //                     color: Colors.transparent,
        //                     alignment: Alignment.center,
        //                     child: Image.asset(
        //                       'assets/icons/ic_heart.png',
        //                       height: 24,
        //                       color: _iconColor(3, value),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //               Expanded(
        //                 child: GestureDetector(
        //                   onTap: () {
        //                     value.changeTab(4);
        //                   },
        //                   child: Container(
        //                     color: Colors.transparent,
        //                     alignment: Alignment.center,
        //                     child: Image.asset(
        //                       'assets/icons/ic_profile.png',
        //                       height: 24,
        //                       color: _iconColor(4, value),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }

  // Color _iconColor(int index, BottomNavigationController value) =>
  //     controller.currentIndex != index
  //         ? AppColors.disabledColor
  //         : AppColors.primary;
}
