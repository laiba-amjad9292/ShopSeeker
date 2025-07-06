import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/global/widgets/appbar/appbar.widget.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';

class AddUpdateProductScreen extends StatefulWidget {
  const AddUpdateProductScreen({super.key});

  @override
  State<AddUpdateProductScreen> createState() => _AddUpdateProductScreenState();
}

class _AddUpdateProductScreenState extends State<AddUpdateProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "add_Product_Listing".tr,
        titleColor: AppColors.white,
        appBarColor: AppColors.primary,
      ),
    );
  }
}
