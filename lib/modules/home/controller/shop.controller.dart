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
      images.isNotEmpty
          ? images
          : [
            'https://firebasestorage.googleapis.com/v0/b/flutter-app-default.appspot.com/o/defaults%2Fshop_placeholder.png?alt=media',
          ];

  ListingModel? listingToUpdate_;
  final RxList<ListingModel> myListings = <ListingModel>[].obs;
  final RxBool isLoading = false.obs;
  ListingModel? selectedListing;
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

  String formatTime(TimeOfDay? time) {
    if (time == null) return 'N/A';
    final hour = time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> handleCreateShopListing() async {
    try {
      if (addUpdateListingInitialKey.currentState?.validate() != true) return;

      EasyLoading.show();

      if (images.isEmpty) {
        images.add('https://via.placeholder.com/300x200.png?text=Shop+Image');
      }

      String weekdayOpeningStr =
          weekdayOpeningController.text.isNotEmpty
              ? weekdayOpeningController.text
              : formatTime(weekdayOpening.value);

      String weekdayClosingStr =
          weekdayClosingController.text.isNotEmpty
              ? weekdayClosingController.text
              : formatTime(weekdayClosing.value);

      String weekendOpeningStr =
          weekendOpeningController.text.isNotEmpty
              ? weekendOpeningController.text
              : formatTime(weekendOpening.value);

      String weekendClosingStr =
          weekendClosingController.text.isNotEmpty
              ? weekendClosingController.text
              : formatTime(weekendClosing.value);

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
              "postal_code",
            ) ??
            "",
        "description":
            addUpdateListingInitialKey.currentState?.getRawValue(
              "description",
            ) ??
            "",
        "timingWeekdays": '$weekdayOpeningStr - $weekdayClosingStr',
        "timingWeekends": '$weekendOpeningStr - $weekendClosingStr',
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

  Future<void> handleUpdateShopListing() async {
    if (!addUpdateListingInitialKey.currentState!.saveAndValidate()) return;

    final data = addUpdateListingInitialKey.currentState!.value;

    final listingId = selectedListing?.id;
    if (listingId == null) {
      showError("No listing selected");
      return;
    }

    try {
      EasyLoading.show();

      await FirebaseFirestore.instance
          .collection("shop_listings")
          .doc(listingId)
          .update({
            "name": data["name"],
            "category": data["category"],
            "address": data["address"],
            "country": data["country"],
            "city": data["city"],
            "postalCode": data["postal_code"], // 🔁 fixed key name
            "timingWeekdays":
                "${data["weekday_opening_time"]} - ${data["weekday_closing_time"]}",
            "timingWeekends":
                "${data["weekend_opening_time"]} - ${data["weekend_closing_time"]}",
            "description": data["description"],
            "image": images,
            "mainImage": images.isNotEmpty ? images[0] : null,
            "updatedAt": FieldValue.serverTimestamp(),
          });

      EasyLoading.dismiss();
      showSuccess("Listing updated successfully");
      Get.back(); // or Get.offIfNeeded()
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

  static void upsertData(
    ListingModel? listingToUpdate,
    ShopAddingController controller,
  ) {
    controller.selectedListing = listingToUpdate;
    controller.images.clear();
    if (listingToUpdate != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        for (var i in listingToUpdate.image) {
          controller.images.add(i);
        }
        controller.listingToUpdate_ = listingToUpdate;

        controller.addUpdateListingInitialKey.currentState?.patchValue({
          'name': listingToUpdate.name,
          'category': listingToUpdate.category,
          'address': listingToUpdate.address,
          'country': listingToUpdate.country,
          'city': listingToUpdate.city,
          'postal_code': listingToUpdate.postalCode,
          'description': listingToUpdate.description,
          'weekday_opening_time':
              listingToUpdate.timingWeekdays.split(" - ").first.trim(),
          'weekday_closing_time':
              listingToUpdate.timingWeekdays.split(" - ").last.trim(),
          'weekend_opening_time':
              listingToUpdate.timingWeekends.split(" - ").first.trim(),
          'weekend_closing_time':
              listingToUpdate.timingWeekends.split(" - ").last.trim(),
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
      controller.addUpdateListingInitialKey.currentState?.patchValue({
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
