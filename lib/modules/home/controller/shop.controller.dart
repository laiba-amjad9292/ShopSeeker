import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_seeker/global/others/global_functions.dart';
import 'package:shop_seeker/global/widgets/dialog/dialog_helpers.widget.dart';
import 'package:shop_seeker/modules/bottom_navbar/screens/bottom_nav.screen.dart';
import 'package:shop_seeker/modules/home/models/shop_listing.model.dart';
import 'package:shop_seeker/global/models/translations.model.dart';
import 'package:shop_seeker/modules/home/widget/delete_media_preview_sheet.widget.dart';
import 'package:shop_seeker/services/database.service.dart';
import 'package:shop_seeker/services/user_manager.service.dart';
import 'package:shop_seeker/utils/constants/app_enums.utils.dart';
import 'package:shop_seeker/utils/helpers/easyloading.util.dart';

class ShopAddingController extends GetxController {
  static ShopAddingController get instance => Get.find<ShopAddingController>();
  GlobalKey<FormBuilderState> get addShopFormKey => addUpdateListingInitialKey;
  final addUpdateListingInitialKey = GlobalKey<FormBuilderState>();

  final RxList<String> images = <String>[].obs;
  ListingModel? listingToUpdate_;
  final RxList<ListingModel> myListings = <ListingModel>[].obs;
  final RxBool isLoading = false.obs;

  final RxString selectedCountry = ''.obs;
  final weekdayOpeningController = TextEditingController();
  final weekdayClosingController = TextEditingController();
  final weekendOpeningController = TextEditingController();
  final weekendClosingController = TextEditingController();
  final countryController = TextEditingController();
  final Rx<TimeOfDay?> weekdayOpening = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> weekdayClosing = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> weekendOpening = Rx<TimeOfDay?>(null);
  final Rx<TimeOfDay?> weekendClosing = Rx<TimeOfDay?>(null);

  String get currentLang => UserManager.instance.currentLang;

  String formatTime(TimeOfDay? time) {
    if (time == null) return '';
    final hour = time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> handleCreateShopListing() async {
    try {
      if (addShopFormKey.currentState?.validate() != true) return;
      if (images.isEmpty) {
        showError("Please add at least one image.");
        return;
      }

      EasyLoading.show();

      final listingModel = ListingModel.fromMap({
        "name": addShopFormKey.currentState?.getRawValue("name") ?? "",
        "category": Tr(
          translations: {
            'en': addShopFormKey.currentState?.getRawValue("category") ?? "",
          },
        ),
        "address": addShopFormKey.currentState?.getRawValue("address") ?? "",
        "country": addShopFormKey.currentState?.getRawValue("country") ?? "",
        "city": addShopFormKey.currentState?.getRawValue("city") ?? "",
        "postalCode":
            addShopFormKey.currentState?.getRawValue("postal_code") ?? "",
        "description":
            addShopFormKey.currentState?.getRawValue("description") ?? "",
        "timingWeekdays":
            '${formatTime(weekdayOpening.value)} - ${formatTime(weekdayClosing.value)}',
        "timingWeekends":
            '${formatTime(weekendOpening.value)} - ${formatTime(weekendClosing.value)}',
        "image": images,
        "mainImage": images.isNotEmpty ? images[0] : null,
        "type": Tr(translations: {'en': 'shop'}),
        "userId": FirebaseAuth.instance.currentUser?.uid,
        "createdAt": Timestamp.now(),
      });

      await Database.createListing(listingModel);

      EasyLoading.dismiss();
      showSuccess('Shop created successfully');
      Get.off(() => BottomNavigationScreen(fromLogin: false));
    } catch (e) {
      EasyLoading.dismiss();
      print("Error in create: $e");
      showError(e.toString());
    }
  }

  Future<void> handleUpdateShopListing() async {
    try {
      if (addShopFormKey.currentState?.validate() != true) return;
      if (images.isEmpty) {
        showError("add_at_least_one_image".tr);
        return;
      }

      EasyLoading.show();

      final updatedListing = ListingModel.fromMap({
        'id': listingToUpdate_?.id,
        'name': addShopFormKey.currentState?.getRawValue("name") ?? "",
        'category': Tr(
          translations: {
            'en': addShopFormKey.currentState?.getRawValue("category") ?? "",
          },
        ),
        'address': addShopFormKey.currentState?.getRawValue("address") ?? "",
        'country': addShopFormKey.currentState?.getRawValue("country") ?? "",
        'city': addShopFormKey.currentState?.getRawValue("city") ?? "",
        'postalCode':
            addShopFormKey.currentState?.getRawValue("postal_code") ?? "",
        'weekdayTiming': {
          'opening': weekdayOpeningController.text,
          'closing': weekdayClosingController.text,
        },
        'weekendTiming': {
          'opening': weekendOpeningController.text,
          'closing': weekendClosingController.text,
        },
        'description':
            addShopFormKey.currentState?.getRawValue("description") ?? "",
        'image': images,
        'mainImage': images.isNotEmpty ? images[0] : null,
        'userId': UserManager.instance.userId,
      });

      await Database.updateShopListing(updatedListing);

      EasyLoading.dismiss();
      showSuccess('Listing updated successfully'.tr);
      Get.back();
    } catch (e) {
      EasyLoading.dismiss();
      print("Error in update: $e");
      showError(e.toString());
    }
  }

  Future<void> handleDeleteShopListing() async {
    try {
      EasyLoading.show();
      await Database.handleDeleteShopListing(listingToUpdate_?.id ?? "");
      EasyLoading.dismiss();
      showSuccess('Listing deleted successfully');
      Get.back();
      Get.back();
    } catch (e) {
      EasyLoading.dismiss();
      print("Error in delete: $e");
      showError(e.toString());
    }
  }

  Future<void> handleDeleteMedia(int i, AppMediaType type) async {
    GlobalFunctions.showBottomSheet(
      ImageDeletePreviewBottomSheet(() {
        try {
          images.removeAt(i);
          update();
        } catch (e) {
          print("Error deleting media: $e");
        }
        Get.back();
      }, images[i]),
    );
  }

  void clearImages() {
    images.clear();
    update();
  }

  static void upsertData(
    ListingModel? listingToUpdate,
    ShopAddingController controller,
  ) {
    controller.images.clear();
    if (listingToUpdate != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        for (var i in listingToUpdate.image) {
          controller.images.add(i);
        }
        controller.listingToUpdate_ = listingToUpdate;
        controller.addShopFormKey.currentState?.patchValue({
          'name': listingToUpdate.name,
          'category':
              listingToUpdate.category.translations[controller.currentLang],
          'address': listingToUpdate.address,
          'country': listingToUpdate.country,
          'city': listingToUpdate.city,
          'postal_code': listingToUpdate.postalCode,
          'description': listingToUpdate.description,
        });
        controller.weekdayOpeningController.text =
            listingToUpdate.timingWeekdays.split(" - ").first.trim();
        controller.weekdayClosingController.text =
            listingToUpdate.timingWeekdays.split(" - ").last.trim();
        controller.weekendOpeningController.text =
            listingToUpdate.timingWeekends.split(" - ").first.trim();
        controller.weekendClosingController.text =
            listingToUpdate.timingWeekends.split(" - ").last.trim();
        controller.update();
      });
    } else {
      controller.addShopFormKey.currentState?.patchValue({
        'category': 'General',
      });
    }
    print(listingToUpdate?.id ?? "Creating new shop listing");
  }

  uploadFile(XFile file, AppMediaType type) async {
    try {
      EasyLoading.show();
      final response = await Database.uploadFileToFirebaseStorage(
        file: file,
        folderName: StorageFolders.listings.name,
        type: type,
      );
      if (response != null && type == AppMediaType.image) {
        images.add(response);
        update();
      }
    } catch (e) {
      print("Upload error: $e");
      showError(e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }
}
