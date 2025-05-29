import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/global/others/container_properties.dart';
import 'package:shop_seeker/global/widgets/appbar/appbar.widget.dart';
import 'package:shop_seeker/global/widgets/textfield.widget.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/extensions/size_extension.util.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(backButton: false, centeredTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              20.hp,
              Container(
                height: 59.h,
                decoration: ContainerProperties.shadowDecoration(
                  color: AppColors.white,
                  radius: 11,
                  blurRadius: 20,
                  xd: 0,
                  yd: 5,
                ),
                child: CustomTextField(
                  showTitle: false,
                  hintText: "search_your_shop".tr,
                  keyName: "search",
                  focusedBorderColor: Colors.transparent,
                  enabledBorderColor: Colors.transparent,
                  prefixIcon: Image.asset(
                    'assets/icons/SearchIcon.png',
                    color: AppColors.colorAAAAAA,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
