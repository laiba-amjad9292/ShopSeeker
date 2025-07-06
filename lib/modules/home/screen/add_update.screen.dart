import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_seeker/global/others/global_functions.dart';
import 'package:shop_seeker/global/widgets/appbar/appbar.widget.dart';
import 'package:shop_seeker/global/widgets/button.widget.dart';
import 'package:shop_seeker/global/widgets/media_attachments/media_attachments.widget.dart';
import 'package:shop_seeker/global/widgets/textfield.widget.dart';
import 'package:shop_seeker/modules/home/controller/shop.controller.dart';
import 'package:shop_seeker/modules/home/models/shop_listing.model.dart';
import 'package:shop_seeker/modules/home/widget/account_access.widget.dart';
import 'package:shop_seeker/modules/home/widget/confirm_delete_listing_bottomsheet_body.widget.dart';
import 'package:shop_seeker/modules/home/widget/unsaved_changes_bottomsheet_body.widget.dart';
import 'package:shop_seeker/utils/constants/app_colors.utils.dart';
import 'package:shop_seeker/utils/extensions/size_extension.util.dart';
import 'package:shop_seeker/utils/helpers/textfield_validators.utils.dart';
import 'package:shop_seeker/utils/theme/textStyles.utils.dart';

class AddUpdateScreen extends StatefulWidget {
  final ListingModel? listing;
  const AddUpdateScreen({super.key, this.listing});

  @override
  State<AddUpdateScreen> createState() => _AddUpdateScreenState();
}

class _AddUpdateScreenState extends State<AddUpdateScreen> {
  final controller = Get.find<ShopAddingController>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      controller.upsertData(widget.listing);
    });
  }

  @override
  void dispose() {
    controller.images.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShopAddingController>(
      builder: (logic) {
        return PopScope(
          canPop: false,
          onPopInvoked: (a) {
            logic.images.clear();
          },

          child: FormBuilder(
            key: logic.addUpdateListingInitialKey,
            initialValue: widget.listing?.initialValues() ?? {},
            child: Scaffold(
              appBar: CustomAppBar(
                title:
                    widget.listing == null
                        ? "Add_Listing".tr
                        : "Update_Listing".tr,
                backButton: true,
                titleColor: AppColors.white,
                appBarColor: AppColors.primary,
                onPop: () {
                  GlobalFunctions.showBottomSheet(
                    const UnSavedChangesBottomSheet(),
                  );
                },
                actions: [
                  if (widget.listing != null)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.h),
                      child: IconButton(
                        onPressed: () {
                          GlobalFunctions.showBottomSheet(
                            const ConfirmDeleteBottomSheet(),
                          );
                        },
                        icon: Image.asset(
                          "assets/icons/ic_bin.png",
                          width: 20.w,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.hp,
                      CustomTextField(
                        validator: ValidatorUtils.req,
                        keyName: 'name',
                        heading: 'shop_name'.tr,
                        hintText: 'enter_shop_name'.tr,
                        isRequired: true,
                      ),
                      16.hp,
                      CustomTextField(
                        validator: ValidatorUtils.req,
                        keyName: 'category',
                        heading: 'category'.tr,
                        hintText: 'enter_shop_category'.tr,
                        isRequired: true,
                      ),
                      16.hp,
                      CustomTextField(
                        validator: ValidatorUtils.req,
                        keyName: 'address',
                        heading: 'street_and_house_no.'.tr,
                        hintText: 'enter_street_and_house_no.'.tr,
                        isRequired: true,
                      ),
                      16.hp,
                      CustomTextField(
                        validator: ValidatorUtils.req,
                        keyName: 'country',
                        heading: 'country'.tr,
                        hintText: 'enter_country'.tr,
                        isRequired: true,
                        readOnly: true,

                        onTap: () => logic.handleCountryPicker(context),
                      ),
                      16.hp,
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              validator: ValidatorUtils.req,
                              keyName: 'city',
                              heading: 'city'.tr,
                              hintText: 'enter_city'.tr,
                              isRequired: true,
                            ),
                          ),
                          12.wp,
                          Expanded(
                            child: CustomTextField(
                              validator: ValidatorUtils.req,
                              keyName: 'postalCode',
                              heading: 'postal_code'.tr,
                              hintText: 'postal_code'.tr,
                              isRequired: true,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      16.hp,
                      Text(
                        "timing_weekdays".tr,
                        style: stylew700(color: AppColors.black),
                      ),
                      11.hp,
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              validator: ValidatorUtils.req,
                              keyName: 'weekdayOpeningTime',
                              heading: 'opening_time'.tr,
                              hintText: 'select_opening_time'.tr,
                              readOnly: true,
                              onTap:
                                  () => logic.selectWeekdayOpeningTime(context),
                            ),
                          ),
                          12.wp,
                          Expanded(
                            child: CustomTextField(
                              validator: ValidatorUtils.req,
                              keyName: 'weekdayClosingTime',
                              heading: 'closing_time'.tr,
                              hintText: 'select_closing_time'.tr,
                              readOnly: true,
                              onTap:
                                  () => logic.selectWeekdayClosingTime(context),
                            ),
                          ),
                        ],
                      ),
                      16.hp,
                      Text(
                        "timing_weekends".tr,
                        style: stylew700(color: AppColors.black),
                      ),
                      11.hp,
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              validator: ValidatorUtils.req,
                              keyName: 'weekendOpeningTime',
                              heading: 'opening_time'.tr,
                              hintText: 'select_opening_time'.tr,
                              readOnly: true,
                              onTap:
                                  () => logic.selectWeekendOpeningTime(context),
                            ),
                          ),
                          12.wp,
                          Expanded(
                            child: CustomTextField(
                              validator: ValidatorUtils.req,
                              keyName: 'weekendClosingTime',
                              heading: 'closing_time'.tr,
                              hintText: 'select_closing_time'.tr,
                              readOnly: true,
                              onTap:
                                  () => logic.selectWeekendClosingTime(context),
                            ),
                          ),
                        ],
                      ),
                      16.hp,
                      CustomTextField(
                        validator: ValidatorUtils.description,
                        keyName: 'description',
                        heading: 'description'.tr,
                        hintText: 'write_here'.tr,
                        isRequired: true,
                        maxLines: 7,
                        minLines: 5,
                      ),
                      16.hp,
                      AttachmentsWidget(
                        heading: 'Add_images'.tr,
                        images: [...logic.displayImages],
                        onlyImage: true,
                        minimumAttachments: 1,
                        videos: const [],
                        handleUploadFile: logic.uploadFile,
                        handleDeleteMedia: logic.handleDeleteMedia,
                      ),
                      20.hp,
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: AppButton(
                    title:
                        widget.listing == null
                            ? "Add_Listing".tr
                            : "Update_Listing".tr,
                    onTap: () async {
                      await Future.delayed(const Duration(seconds: 1));

                      if (widget.listing == null) {
                        logic.handleCreateShopListing();
                      } else {
                        logic.handleUpdateShopListing(widget.listing?.id);
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
