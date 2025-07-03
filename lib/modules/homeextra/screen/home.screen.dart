import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:get/get_utils/src/extensions/export.dart";
import "package:shop_seeker/global/others/global_functions.dart";
import "package:shop_seeker/global/widgets/appbar/appbar.widget.dart";
import "package:shop_seeker/modules/home/widget/account_access.widget.dart";
import "package:shop_seeker/services/user_manager.service.dart";
import "package:shop_seeker/utils/constants/app_colors.utils.dart";
import "package:shop_seeker/utils/extensions/size_extension.util.dart";
import "package:shop_seeker/utils/theme/textStyles.utils.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: "home".tr,
        titleColor: AppColors.primary,
        backButton: false,
        centeredTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (UserManager.instance.name?.isNotEmpty == true) ...[
                10.hp,
                Text(
                  "hello".tr,
                  style: stylew400(size: 16, color: AppColors.color98A2B3),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${UserManager.instance.name.capitalizeFirst}",
                        style: stylew600(
                          size: 18,
                          color: AppColors.color475467,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              20.hp,
              GestureDetector(
                onTap: () {
                  if (FirebaseAuth.instance.currentUser == null) {
                    GlobalFunctions.showBottomSheet(
                      const AccountAccessRequired(),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.colorDDDDDD,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      "assets/images/Falafel.jpg",
                                      width: 130,
                                      height: 108,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  10.hp,
                                  Text(
                                    'Arabian Resturant',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Falafel",
                                    style: stylew500(
                                      size: 14,
                                      color: AppColors.color888888,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
    );
  }
}
