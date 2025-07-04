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
  final controller = Get.put(ShopAddingController());
  @override
  void initState() {
    ShopAddingController.upsertData(widget.listing, controller);
    super.initState();
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
            key: logic.addShopFormKey,
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
                  // if (widget.listing != null)
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
                        controller:
                            logic.countryController, // Use declared controller
                        onTap: () {
                          GlobalFunctions.countryCodePickerWidget(context, (
                            Country country,
                          ) {
                            final flag = GlobalFunctions.getFlagEmoji(
                              country.countryCode,
                            );
                            final selected = "${flag} ${country.name}";

                            logic.selectedCountry.value = selected;
                            logic.countryController.text = selected;

                            // 🔥 Required line for FormBuilder validation
                            controller
                                .addShopFormKey
                                .currentState
                                ?.fields['country']
                                ?.didChange(selected);

                            logic.update();
                          });
                        },
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
                              keyName: 'postal_code',
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
                              keyName: 'opening_time',
                              heading: 'opening_time'.tr,
                              hintText: 'select_opening_time'.tr,
                              readOnly: true,
                              onTap: () async {
                                final picked = await GlobalFunctions.selectTime(
                                  context,
                                );
                                if (picked != null) {
                                  controller
                                      .weekdayOpening
                                      .value = TimeOfDay.fromDateTime(picked);
                                  controller
                                      .weekdayOpeningController
                                      .text = controller.formatTime(
                                    controller.weekdayOpening.value,
                                  );
                                }
                              },
                              controller: controller.weekdayOpeningController,
                            ),
                          ),
                          12.wp,
                          Expanded(
                            child: CustomTextField(
                              validator: ValidatorUtils.req,
                              keyName: 'closing_time',
                              heading: 'closing_time'.tr,
                              hintText: 'select_closing_time'.tr,
                              readOnly: true,
                              onTap: () async {
                                final picked = await GlobalFunctions.selectTime(
                                  context,
                                );
                                if (picked != null) {
                                  controller
                                      .weekdayClosing
                                      .value = TimeOfDay.fromDateTime(picked);
                                  controller
                                      .weekdayClosingController
                                      .text = controller.formatTime(
                                    controller.weekdayClosing.value,
                                  );
                                }
                              },
                              controller: controller.weekdayClosingController,
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
                              keyName: 'opening_time',
                              heading: 'opening_time'.tr,
                              hintText: 'select_opening_time'.tr,
                              readOnly: true,
                              onTap: () async {
                                final picked = await GlobalFunctions.selectTime(
                                  context,
                                );
                                if (picked != null) {
                                  controller
                                      .weekendOpening
                                      .value = TimeOfDay.fromDateTime(picked);
                                  controller
                                      .weekendOpeningController
                                      .text = controller.formatTime(
                                    controller.weekendOpening.value,
                                  );
                                }
                              },
                              controller: controller.weekendOpeningController,
                            ),
                          ),
                          12.wp,
                          Expanded(
                            child: CustomTextField(
                              validator: ValidatorUtils.req,
                              keyName: 'closing_time',
                              heading: 'closing_time'.tr,
                              hintText: 'select_closing_time'.tr,
                              readOnly: true,
                              onTap: () async {
                                final picked = await GlobalFunctions.selectTime(
                                  context,
                                );
                                if (picked != null) {
                                  controller
                                      .weekendClosing
                                      .value = TimeOfDay.fromDateTime(picked);
                                  controller
                                      .weekendClosingController
                                      .text = controller.formatTime(
                                    controller.weekendClosing.value,
                                  );
                                }
                              },
                              controller: controller.weekendClosingController,
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
                        images: [...logic.images],
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
                    onTap: () {
                      if (FirebaseAuth.instance.currentUser == null) {
                        GlobalFunctions.showBottomSheet(
                          const AccountAccessRequired(),
                        );
                      } else {
                        if (widget.listing == null) {
                          logic.handleCreateShopListing();
                        } else {
                          logic.handleUpdateShopListing();
                        }
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
