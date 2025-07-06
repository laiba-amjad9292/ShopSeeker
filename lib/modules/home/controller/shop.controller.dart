import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop_seeker/global/others/global_functions.dart';
import 'package:shop_seeker/global/widgets/dialog/dialog_helpers.widget.dart';
import 'package:shop_seeker/modules/bottom_navbar/screens/bottom_nav.screen.dart';
import 'package:shop_seeker/modules/home/models/shop_listing.model.dart';
import 'package:shop_seeker/modules/home/widget/delete_media_preview_sheet.widget.dart';
import 'package:shop_seeker/services/database.service.dart';
import 'package:shop_seeker/utils/constants/app_enums.utils.dart';
import 'package:shop_seeker/utils/helpers/easyloading.util.dart';
import 'package:shop_seeker/utils/helpers/type_translation.utils.dart';

class ShopAddingController extends GetxController {
  static ShopAddingController get instance => Get.find<ShopAddingController>();

  final addUpdateListingInitialKey = GlobalKey<FormBuilderState>();

  final RxList<String> images = <String>[].obs;
  List<String> get displayImages =>
      images.isNotEmpty ? images : ['https://picsum.photos/200/300'];

  ListingModel? listingToUpdate_;
  final RxList<ListingModel> myListings = <ListingModel>[].obs;
  final RxBool isLoading = false.obs;
  ListingModel? selectedListing;
  final RxString selectedCountry = ''.obs;

  final countryController = TextEditingController();

  // Store picked times
  TimeOfDay? weekdayOpeningTime;
  TimeOfDay? weekdayClosingTime;
  TimeOfDay? weekendOpeningTime;
  TimeOfDay? weekendClosingTime;

  // Format time
  String formatTime(TimeOfDay? time) {
    if (time == null) return '';
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  // --- Selectors ---

  Future<void> selectWeekdayOpeningTime(BuildContext context) async {
    final picked = await GlobalFunctions.selectTime(context);
    if (picked != null) {
      final time = TimeOfDay.fromDateTime(picked);
      weekdayOpeningTime = time;
      addUpdateListingInitialKey.currentState?.fields['weekdayOpeningTime']
          ?.didChange(formatTime(time));
    }
  }

  Future<void> selectWeekdayClosingTime(BuildContext context) async {
    final picked = await GlobalFunctions.selectTime(context);
    if (picked != null) {
      final time = TimeOfDay.fromDateTime(picked);
      weekdayClosingTime = time;
      addUpdateListingInitialKey.currentState?.fields['weekdayClosingTime']
          ?.didChange(formatTime(time));
    }
  }

  Future<void> selectWeekendOpeningTime(BuildContext context) async {
    final picked = await GlobalFunctions.selectTime(context);
    if (picked != null) {
      final time = TimeOfDay.fromDateTime(picked);
      weekendOpeningTime = time;
      addUpdateListingInitialKey.currentState?.fields['weekendOpeningTime']
          ?.didChange(formatTime(time));
    }
  }

  Future<void> selectWeekendClosingTime(BuildContext context) async {
    final picked = await GlobalFunctions.selectTime(context);
    if (picked != null) {
      final time = TimeOfDay.fromDateTime(picked);
      weekendClosingTime = time;
      addUpdateListingInitialKey.currentState?.fields['weekendClosingTime']
          ?.didChange(formatTime(time));
    }
  }

  void handleCountryPicker(BuildContext context) {
    GlobalFunctions.countryCodePickerWidget(context, (Country country) {
      final formState = addUpdateListingInitialKey.currentState;
      if (formState != null && formState.mounted) {
        formState.patchValue({'country': country.name});
      }
      update();
    });
  }

  Future<void> handleCreateShopListing() async {
    try {
      if (addUpdateListingInitialKey.currentState?.validate() != true) return;

      EasyLoading.show();

      if (images.isEmpty) {
        images.add('https://picsum.photos/200/300');
      }

      final listingModel = ListingModel.fromMap({
        "name":
            addUpdateListingInitialKey.currentState?.getRawValue("name") ?? "",
        "category":
            addUpdateListingInitialKey.currentState?.getRawValue("category") ??
            "",
        "address":
            addUpdateListingInitialKey.currentState?.getRawValue("address") ??
            "",
        "country":
            addUpdateListingInitialKey.currentState?.getRawValue("country") ??
            "",
        "city":
            addUpdateListingInitialKey.currentState?.getRawValue("city") ?? "",
        "postalCode":
            addUpdateListingInitialKey.currentState?.getRawValue(
              "postalCode",
            ) ??
            "",
        "description":
            addUpdateListingInitialKey.currentState?.getRawValue(
              "description",
            ) ??
            "",
        "timingWeekdays":
            "${formatTime(weekdayOpeningTime)} - ${formatTime(weekdayClosingTime)}",
        "timingWeekends":
            "${formatTime(weekendOpeningTime)} - ${formatTime(weekendClosingTime)}",
        "image": images,
        "mainImage": images[0],
        "type": getTranslatedType("shop"),
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

  Future<void> handleGetShopListing() async {
    try {
      isLoading.value = true;

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final response = await Database.getMyShopListing(user.uid);
        myListings.assignAll(response);
      } else {
        final response = await Database.getAllShopListings();
        myListings.assignAll(response);
      }
    } catch (e) {
      print("Error fetching shops: $e");
      showError('Failed to fetch shops');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> handleUpdateShopListing(id) async {
    if (!addUpdateListingInitialKey.currentState!.saveAndValidate()) return;

    final data = addUpdateListingInitialKey.currentState!.value;

    try {
      EasyLoading.show();

      await FirebaseFirestore.instance.collection("listings").doc(id).update({
        "name": data["name"],
        "category": data["category"],
        "address": data["address"],
        "country": data["country"],
        "city": data["city"],
        "postalCode": data["postalCode"],
        "timingWeekdays":
            "${formatTime(weekdayOpeningTime)} - ${formatTime(weekdayClosingTime)}",
        "timingWeekends":
            "${formatTime(weekendOpeningTime)} - ${formatTime(weekendClosingTime)}",
        "description": data["description"],
        "image": images,
        "mainImage": images.isNotEmpty ? images[0] : null,
        "updatedAt": FieldValue.serverTimestamp(),
      });

      EasyLoading.dismiss();
      showSuccess("Listing updated successfully");
      Get.back();
    } catch (e) {
      EasyLoading.dismiss();
      print("Update error: $e");
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

  void upsertData(ListingModel? listing) {
    if (listing != null) {
      selectedListing = listing;
      listingToUpdate_ = listing;
      log("${selectedListing?.id ?? ''} usama");

      countryController.text = listing.country ?? "";

      images.clear();
      images.addAll(listing.image ?? []);

      final weekdayTimes = listing.timingWeekdays?.split(' - ');
      if (weekdayTimes != null && weekdayTimes.length == 2) {
        weekdayOpeningTime = GlobalFunctions.parseTimeOfDay(weekdayTimes[0]);
        weekdayClosingTime = GlobalFunctions.parseTimeOfDay(weekdayTimes[1]);
      }

      final weekendTimes = listing.timingWeekends?.split(' - ');
      if (weekendTimes != null && weekendTimes.length == 2) {
        weekendOpeningTime = GlobalFunctions.parseTimeOfDay(weekendTimes[0]);
        weekendClosingTime = GlobalFunctions.parseTimeOfDay(weekendTimes[1]);
      }

      update();
    }
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
