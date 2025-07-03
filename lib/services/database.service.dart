import 'dart:developer';
import 'dart:math' as math;
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:camera/camera.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shop_seeker/global/widgets/dialog/dialog_helpers.widget.dart';
import 'package:shop_seeker/modules/auth/models/user.model.dart';
import 'package:shop_seeker/modules/shops/models/shop_listing.model.dart';
import 'package:shop_seeker/services/connection.service.dart';
import 'package:shop_seeker/services/user_manager.service.dart';
import 'package:shop_seeker/utils/constants/app_enums.utils.dart';
import 'package:shop_seeker/utils/helpers/easyloading.util.dart';

class Database {
  static FirebaseFirestore instance = FirebaseFirestore.instance;
  static String userId = UserManager.instance.userId;
  static ConnectionStatusSingleton connectionStatus =
      ConnectionStatusSingleton.getInstance();

  static createUserInDatabase(UserModel user) async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    var token = await firebaseMessaging.getToken() ?? '';
    return await instance
        .collection('users')
        .doc(user.id)
        .set({...user.toMap(), 'token': token})
        .then((value) {
          return true;
        })
        .catchError((e) {
          return false;
        });
  }

  static Future<bool> updateUser(UserModel userModel) async {
    try {
      FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      var token = await firebaseMessaging.getToken() ?? '';
      if (userModel.id.isNotEmpty) {
        await instance.collection("users").doc(userModel.id).set({
          ...userModel.toMap(),
          'token': token,
        });
        return true;
      }
      return false;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  static Future<UserModel?> getUser(String uid) async {
    DocumentSnapshot doc = await instance.collection("users").doc(uid).get();
    UserModel userModel = UserModel.fromDocumentSnapshot(doc);
    return userModel;
  }

  static Future<bool> isUserExist(String id) async {
    var docs =
        await instance.collection("users").where('id', isEqualTo: id).get();
    return docs.docs.isNotEmpty;
  }

  static Future<bool> createListing(ListingModel listing) async {
    try {
      // Add the document and get the reference
      DocumentReference docRef = await instance
          .collection("listings")
          .add(listing.toMap());

      // Update the listing with the document ID
      await docRef.update({"id": docRef.id});

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  static Future<String?> uploadFileToFirebaseStorage({
    required XFile file,
    required String folderName,
    required AppMediaType type,
  }) async {
    try {
      EasyLoading.show();
      File file_ = File(file.path);
      print('file ========> $file_');
      if (!await file_.exists()) {
        showError("File does not exist at path: $file_");
        return null;
      }

      // Extract the original file name
      final fileName = path.basename(file.path);

      // Generate some random characters
      final randomString = math.Random().nextInt(100000).toString();

      // Retrieve the user ID
      final userId = UserManager.instance.userId;

      // Combine to create a unique file name
      final uniqueFileName = "${userId}_$randomString\_$fileName";

      final storageRef = FirebaseStorage.instance.ref();
      final imagesRef = storageRef.child("$folderName/$uniqueFileName");

      final UploadTask uploadTask = imagesRef.putFile(file_);
      final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

      final url = await taskSnapshot.ref.getDownloadURL();

      print("url =======> $url");

      EasyLoading.dismiss();
      return url;
    } on FirebaseException catch (e) {
      showError(e.message);
      print("Firebase Storage Error: ${e.code} - ${e.message}");
      return null;
    } catch (e) {
      print("General Error: $e");
      return null;
    }
  }
}
