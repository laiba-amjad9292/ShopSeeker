import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_seeker/modules/auth/models/user.model.dart';
import 'package:shop_seeker/services/connection.service.dart';
import 'package:shop_seeker/services/user_manager.service.dart';

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

  // static Future<List<QuestionModel>> getAllQuestions() async {
  //   final querySnapshot = await instance
  //       .collection('questions')
  //       .withConverter<QuestionModel>(
  //         fromFirestore: (snapshot, _) => QuestionModel.fromSnapshot(snapshot),
  //         toFirestore: (questionModel, _) => questionModel.toMap(),
  //       )
  //       .get();

  //   return querySnapshot.docs.map((doc) => doc.data()).toList();
  // }

  // static Future<bool> createListing(ListingModel listing) async {
  //   try {
  //     // Add the document and get the reference
  //     DocumentReference docRef =
  //         await instance.collection("listings").add(listing.toMap());

  //     // Update the listing with the document ID
  //     await docRef.update({"id": docRef.id});

  //     return true;
  //   } catch (e) {
  //     log(e.toString());
  //     return false;
  //   }
  // }

  // static Future<bool> blockUser({
  //   required String chatRoomId,
  //   required List blockedBy,
  // }) async {
  //   try {
  //     await instance
  //         .collection('chats')
  //         .doc(chatRoomId)
  //         .update({'blockedBy': blockedBy});
  //     return true;
  //   } catch (e) {
  //     print("General Error: $e");
  //     return false;
  //   }
  // }

  // static Future<String?> uploadFileToFirebaseStorage({
  //   required XFile file,
  //   required String folderName,
  //   required AppMediaType type,
  // }) async {
  //   try {
  //     EasyLoading.show();
  //     File file_ = File(file.path);
  //     print('file ========> $file_');
  //     if (!await file_.exists()) {
  //       showError("File does not exist at path: $file_");
  //       return null;
  //     }

  //     // Extract the original file name
  //     final fileName = path.basename(file.path);

  //     // Generate some random characters
  //     final randomString = math.Random().nextInt(100000).toString();

  //     // Retrieve the user ID
  //     final userId = UserManager.instance.userId;

  //     // Combine to create a unique file name
  //     final uniqueFileName = "${userId}_$randomString\_$fileName";

  //     final storageRef = FirebaseStorage.instance.ref();
  //     final imagesRef = storageRef.child("$folderName/$uniqueFileName");

  //     final UploadTask uploadTask = imagesRef.putFile(file_);
  //     final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

  //     final url = await taskSnapshot.ref.getDownloadURL();

  //     print("url =======> $url");

  //     EasyLoading.dismiss();
  //     return url;
  //   } on FirebaseException catch (e) {
  //     showError(e.message);
  //     print("Firebase Storage Error: ${e.code} - ${e.message}");
  //     return null;
  //   } catch (e) {
  //     print("General Error: $e");
  //     return null;
  //   }
  // }

  // static Future<List<ListingModel>> getMyListing() async {
  //   final querySnapshot = await instance
  //       .collection('listings')
  //       .withConverter<ListingModel>(
  //         fromFirestore: (snapshot, _) =>
  //             ListingModel.fromDocumentSnapshot(snapshot),
  //         toFirestore: (questionModel, _) => questionModel.toMap(),
  //       )
  //       .where(
  //         'userId',
  //         isEqualTo: UserManager.instance.userId,
  //       )
  //       .orderBy('createdAt', descending: true)
  //       .get();

  //   return querySnapshot.docs.map((doc) => doc.data()).toList();
  // }

  // static Future<List<ListingModel>> getListings({
  //   String? categoryEN,
  //   String? typeEN,
  //   bool mine = true,
  // }) async {
  //   final collectionRef = instance.collection('listings');

  //   // Use a different userId filter based on whether we're showing "my" listings.
  //   Query<Map<String, dynamic>> query =
  //       mine
  //           ? collectionRef.where(
  //             'userId',
  //             isEqualTo: UserManager.instance.userId,
  //           )
  //           : collectionRef.where(
  //             'userId',
  //             isNotEqualTo: UserManager.instance.userId,
  //           );

  //   // Optional filtering by category.
  //   if (categoryEN != null) {
  //     query = query.where('category.en', isEqualTo: categoryEN);
  //   }

  //   // Optional filtering by type.
  //   if (typeEN != null) {
  //     query = query.where('type.en', isEqualTo: typeEN);
  //   }

  //   // Order by createdAt for current user's listings.

  //   query = query.orderBy('createdAt', descending: true);

  //   final querySnapshot =
  //       await query
  //           .withConverter<ListingModel>(
  //             fromFirestore:
  //                 (snapshot, _) => ListingModel.fromDocumentSnapshot(snapshot),
  //             toFirestore: (listingModel, _) => listingModel.toMap(),
  //           )
  //           .get();

  //   List<ListingModel> listings =
  //       querySnapshot.docs.map((doc) => doc.data()).toList();

  //   // For listings from other users, apply additional filtering to remove any
  //   // listings whose type (from translations) is 'animal' (case-insensitive).
  //   if (!mine) {
  //     listings =
  //         listings
  //             .where(
  //               (listing) =>
  //                   listing.type.translations['en']?.toLowerCase() != 'animal',
  //             )
  //             .toList();
  //   }

  //   return listings;
  // }

  // static Future<List<ConsultancyModel>> getAllConsultancy() async {
  //   final querySnapshot = await instance
  //       .collection('consultancy')
  //       .withConverter<ConsultancyModel>(
  //         fromFirestore: (snapshot, _) =>
  //             ConsultancyModel.fromDocumentSnapshot(snapshot),
  //         toFirestore: (consultancyModel, _) => consultancyModel.toMap(),
  //       )
  //       .get();

  //   return querySnapshot.docs.map((doc) => doc.data()).toList();
  // }

  // static Future<bool> createConsultancy(ConsultancyModel consultancy) async {
  //   try {
  //     // Add the document and get the reference
  //     DocumentReference docRef =
  //         await instance.collection("consultancy").add(consultancy.toMap());

  //     // Update the listing with the document ID
  //     await docRef.update({"id": docRef.id});

  //     return true;
  //   } catch (e) {
  //     log(e.toString());
  //     return false;
  //   }
  // }

  // static Future<bool> updateConsultancy(ConsultancyModel listingModel) async {
  //   try {
  //     if (listingModel.id.isNotEmpty) {
  //       await instance
  //           .collection("consultancy")
  //           .doc(listingModel.id)
  //           .update(listingModel.toMap());
  //       return true;
  //     }
  //     return false;
  //   } catch (e) {
  //     log(e.toString());
  //     return false;
  //   }
  // }

  // static Future<List<ListingModel>> getAllListings() async {
  //   final querySnapshot =
  //       await instance
  //           .collection('listings')
  //           .where('userId', isNotEqualTo: UserManager.instance.userId)
  //           .withConverter<ListingModel>(
  //             fromFirestore:
  //                 (snapshot, _) => ListingModel.fromDocumentSnapshot(snapshot),
  //             toFirestore: (listingModel, _) => listingModel.toMap(),
  //           )
  //           .get();

  //   return querySnapshot.docs.map((doc) => doc.data()).toList();
  // }

  // static Future<bool> deleteConsultancy(String id) async {
  //   try {
  //     await instance.collection("consultancy").doc(id).delete();

  //     return true;
  //   } catch (e) {
  //     log(e.toString());
  //     return false;
  //   }
  // }

  // static Future<List<ListingModel>> getAllListingsByCategory(
  //   String? categoryEN,
  // ) async {
  //   final collectionRef = instance.collection('listings');

  //   Query<Map<String, dynamic>> query = collectionRef;

  //   if (categoryEN != null) {
  //     query = query.where('category.en', isEqualTo: categoryEN);
  //   }

  //   query = query.where('type.en', isEqualTo: 'Animal');

  //   final querySnapshot =
  //       await query
  //           .withConverter<ListingModel>(
  //             fromFirestore:
  //                 (snapshot, _) => ListingModel.fromDocumentSnapshot(snapshot),
  //             toFirestore: (listingModel, _) => listingModel.toMap(),
  //           )
  //           .get();

  //   return querySnapshot.docs.map((doc) => doc.data()).toList();
  // }

  // static Future<List<ListingModel>> getAllListingsByType(String? typeEN) async {
  //   final collectionRef = instance.collection('listings');
  //   print('typeEN =====> $typeEN');

  //   Query<Map<String, dynamic>> query = collectionRef;

  //   // Start building the query to exclude listings from the current user
  //   // var query = collectionRef.where(
  //   //   'userId',
  //   //   isNotEqualTo: UserManager.instance.userId,
  //   // );

  //   // Add the type filter if typeEN is not null
  //   if (typeEN != null) {
  //     query = query.where('type.en', isEqualTo: typeEN);
  //   }

  //   // Apply the converter and get the data
  //   final querySnapshot =
  //       await query
  //           .withConverter<ListingModel>(
  //             fromFirestore:
  //                 (snapshot, _) => ListingModel.fromDocumentSnapshot(snapshot),
  //             toFirestore: (listingModel, _) => listingModel.toMap(),
  //           )
  //           .get();

  //   // Filter out listings where type.en is 'animal'
  //   return querySnapshot.docs
  //       .map((doc) => doc.data())
  //       .where(
  //         (listing) =>
  //             listing.type.translations['en']?.toLowerCase() != 'animal',
  //       )
  //       .toList();
  // }

  // static Future<List<ListingModel>> getMyListingsByCategory(
  //   String? categoryEN,
  // ) async {
  //   final collectionRef = instance.collection('listings');

  //   // Start building the query to include only listings from the current user
  //   Query<Map<String, dynamic>> query = collectionRef.where(
  //     'userId',
  //     isEqualTo: UserManager.instance.userId,
  //   );

  //   // Filter by category if provided
  //   if (categoryEN != null) {
  //     query = query.where('category.en', isEqualTo: categoryEN);
  //   }

  //   // Additional filter to show listings where type.en is "Animal"
  //   query = query.where('type.en', isEqualTo: 'Animal');

  //   final querySnapshot =
  //       await query
  //           .withConverter<ListingModel>(
  //             fromFirestore:
  //                 (snapshot, _) => ListingModel.fromDocumentSnapshot(snapshot),
  //             toFirestore: (listingModel, _) => listingModel.toMap(),
  //           )
  //           .get();

  //   return querySnapshot.docs.map((doc) => doc.data()).toList();
  // }

  // static Future<List<ListingModel>> getMyListingsByType(String? typeEN) async {
  //   final collectionRef = instance.collection('listings');
  //   print('typeEN =====> $typeEN');

  //   // Exclude listings from the current user by adding a filter
  //   Query<Map<String, dynamic>> query = collectionRef.where(
  //     'userId',
  //     isNotEqualTo: UserManager.instance.userId,
  //   );

  //   // Add the type filter if typeEN is provided
  //   if (typeEN != null) {
  //     query = query.where('type.en', isEqualTo: typeEN);
  //   }

  //   // Apply the converter and fetch the query results
  //   final querySnapshot =
  //       await query
  //           .withConverter<ListingModel>(
  //             fromFirestore:
  //                 (snapshot, _) => ListingModel.fromDocumentSnapshot(snapshot),
  //             toFirestore: (listingModel, _) => listingModel.toMap(),
  //           )
  //           .get();

  //   // Filter out any listings where type.en (from translations) is 'animal'
  //   return querySnapshot.docs
  //       .map((doc) => doc.data())
  //       .where(
  //         (listing) =>
  //             listing.type.translations['en']?.toLowerCase() != 'animal',
  //       )
  //       .toList();
  // }

  // static Future<List<ListingModel>> getAllListingsByTypeAndCategory({
  //   String? typeEN,
  //   String? categoryEN,
  // }) async {
  //   final collectionRef = instance.collection('listings');
  //   print('typeEN =====> $typeEN, categoryEN =====> $categoryEN');

  //   Query<Map<String, dynamic>> query = collectionRef;

  //   if (typeEN != null) {
  //     query = query.where('type.en', isEqualTo: typeEN);
  //   }

  //   if (categoryEN != null) {
  //     query = query.where('category.en', isEqualTo: categoryEN);
  //   }

  //   final querySnapshot =
  //       await query
  //           .withConverter<ListingModel>(
  //             fromFirestore:
  //                 (snapshot, _) => ListingModel.fromDocumentSnapshot(snapshot),
  //             toFirestore: (listingModel, _) => listingModel.toMap(),
  //           )
  //           .get();

  //   return querySnapshot.docs
  //       .map((doc) => doc.data())
  //       .where(
  //         (listing) =>
  //             listing.type.translations['en']?.toLowerCase() != 'animal',
  //       )
  //       .toList();
  // }

  // static Future<bool> updateListing(ListingModel listingModel) async {
  //   try {
  //     if (listingModel.id.isNotEmpty) {
  //       await instance
  //           .collection("listings")
  //           .doc(listingModel.id)
  //           .update(listingModel.toMap());
  //       return true;
  //     }
  //     return false;
  //   } catch (e) {
  //     log(e.toString());
  //     return false;
  //   }
  // }

  // static Future<ListingModel?> getSingleListing(String listingId) async {
  //   try {
  //     // Get the document snapshot with the converter
  //     final docSnapshot =
  //         await instance
  //             .collection('listings')
  //             .doc(listingId)
  //             .withConverter<ListingModel>(
  //               fromFirestore:
  //                   (snapshot, _) =>
  //                       ListingModel.fromDocumentSnapshot(snapshot),
  //               toFirestore: (listingModel, _) => listingModel.toMap(),
  //             )
  //             .get();

  //     // Check if the document exists and return the data as ListingModel
  //     return docSnapshot.data();
  //   } catch (e) {
  //     log(e.toString());
  //     return null; // Return null if there's an error or the document doesn't exist
  //   }
  // }

  // static Future<bool> deleteListing(String id) async {
  //   try {
  //     await instance.collection("listings").doc(id).delete();

  //     return true;
  //   } catch (e) {
  //     log(e.toString());
  //     return false;
  //   }
  // }

  // static Future<Map> createChatRoom(
  //     {required String otherUserId,
  //     required String listingId,
  //     required String listingName,
  //     required String listingPrice}) async {
  //   try {
  //     String currentUserId = Get.find<UserManager>().userId;

  //     // Check if chat room already exists for the same users and listing
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('chats')
  //         .where('check', arrayContains: '$otherUserId$currentUserId')
  //         .where('listing.listingId', isEqualTo: listingId)
  //         .get();

  //     if (querySnapshot.docs.isNotEmpty) {
  //       var chatDoc = querySnapshot.docs[0];

  //       // Fetch the latest user details
  //       ChatRoomUser user1 = await getFirebaseUser(chatDoc['user1']['id']);
  //       ChatRoomUser user2 = await getFirebaseUser(chatDoc['user2']['id']);

  //       // Update existing chat room details
  //       // await chatDoc.reference.update({
  //       //   'timestamp': Timestamp.now(),
  //       // });

  //       return {
  //         'room': chatDoc.id,
  //         'id': chatDoc.id,
  //         'listing': {
  //           "listingId": listingId,
  //           "listingName": listingName,
  //           "listingPrice": listingPrice
  //         },
  //         "blockedBy": chatDoc['blockedBy'] ?? [],
  //         'users': [chatDoc['user1']['id'], chatDoc['user2']['id']],
  //         'user1': UserManager.instance.userId == user1.id
  //             ? user1.toMap()
  //             : user2.toMap(),
  //         'user2': UserManager.instance.userId == user1.id
  //             ? user2.toMap()
  //             : user1.toMap(),
  //       };
  //     }

  //     // Create a new chat room if none exists
  //     DocumentReference df =
  //         await FirebaseFirestore.instance.collection('chats').add({
  //       'user1': {"id": currentUserId},
  //       'user2': {"id": otherUserId},
  //       'lastMessage': "",
  //       'listing': {
  //         "listingId": listingId,
  //         "listingName": listingName,
  //         "listingPrice": listingPrice
  //       },
  //       "blockedBy": [],
  //       'lastMessageBy': currentUserId,
  //       'unreadCount': 0,
  //       'check': ['$otherUserId$currentUserId', '$currentUserId$otherUserId'],
  //       'users': [currentUserId, otherUserId],
  //       'timestamp': Timestamp.now(),
  //     });

  //     // Fetch the latest user details after creating the chat room
  //     ChatRoomUser currentUser = await getFirebaseUser(currentUserId);
  //     ChatRoomUser otherUser = await getFirebaseUser(otherUserId);

  //     return {
  //       'room': df.id,
  //       'id': df.id,
  //       'listing': {
  //         "listingId": listingId,
  //         "listingName": listingName,
  //         "listingPrice": listingPrice
  //       },
  //       "blockedBy": [],
  //       'users': [currentUserId, otherUserId],
  //       'user1': currentUser.toMap(),
  //       'user2': otherUser.toMap(),
  //     };
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return {};
  //   }
  // }

  // static Future<Map> createSupportRoom() async {
  //   try {
  //     // log('${supportId}${Get.find<UserManager>().userId}');
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('supportChats')
  //         .where('check', arrayContains: '111${Get.find<UserManager>().userId}')
  //         .get();
  //     if (querySnapshot.docs.isNotEmpty) {
  //       return {
  //         'room': querySnapshot.docs[0].id,
  //         'id': querySnapshot.docs[0]['user2']['id'],
  //       };
  //     }
  //     DocumentReference df =
  //         await Database.instance.collection('supportChats').add({
  //       'users': [111, Get.find<UserManager>().userId],
  //       'lastMessage': "",
  //       'lastMessageBy': Get.find<UserManager>().userId,
  //       'unreadCount': 0,
  //       'user1': {
  //         'id': Get.find<UserManager>().userId,
  //         'name': Get.find<UserManager>().name,
  //         'image': Get.find<UserManager>().profileImage,
  //       },
  //       'user2': {'id': 111},
  //       'check': [
  //         '111${Get.find<UserManager>().userId}',
  //         '${Get.find<UserManager>().userId}111'
  //       ],
  //       'timestamp': Timestamp.now()
  //     });

  //     return {
  //       'room': df.id,
  //       'id': 111,
  //     };
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return {};
  //   }
  // }

  // static Future<bool> addMessage(String docId, ChatModel chat) async {
  //   try {
  //     // log(chat.to.isNegative.toString());
  //     await Database.instance
  //         .collection(chat.to == 111 ? 'supportChats' : 'chats')
  //         .doc(docId)
  //         .collection('messages')
  //         .add({
  //       "from": Get.find<UserManager>().userId,
  //       "to": chat.to,
  //       "message": chat.files.isNotEmpty && chat.message.isEmpty
  //           ? "Attachment"
  //           : chat.message,
  //       "files": chat.files,
  //       "timestamp": chat.timeStamp,
  //     });
  //     await Database.instance
  //         .collection(chat.to.isEmpty ? 'supportChats' : 'chats')
  //         .doc(docId)
  //         .update({
  //       'lastMessageBy': Get.find<UserManager>().userId,
  //       'unreadCount': FieldValue.increment(1),
  //       'lastMessage': chat.message,
  //       'timestamp': Timestamp.now(),
  //     });
  //     return true;
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return false;
  //   }
  // }

  // static Future<bool> updateWali(String docId, bool status) async {
  //   try {
  //     await Database.instance
  //         .collection('chats')
  //         .doc(docId)
  //         .update({'wali': status});
  //     return true;
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return false;
  //   }
  // }

  // static Future<bool> updateChaperon(String docId, bool status) async {
  //   try {
  //     await Database.instance
  //         .collection('chats')
  //         .doc(docId)
  //         .update({'chaperon': status});
  //     return true;
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     return false;
  //   }
  // }

  // static setFirebaseUser() async {
  //   var token = await FirebaseMessaging.instance.getToken();
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(Get.find<UserManager>().userId.toString())
  //       .set({
  //     'online': true,
  //     'image': Get.find<UserManager>().profileImage,
  //     'name': Get.find<UserManager>().name,
  //     'token': token ?? ''
  //   });
  // }

  // static Future<ChatRoomUser> getFirebaseUser(String id) async {
  //   var doc = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(id.toString())
  //       .get();
  //   if (doc.exists) {
  //     return ChatRoomUser.fromMap(doc.data() as Map<String, dynamic>);
  //   } else {
  //     return ChatRoomUser(
  //         id: id, name: 'User', profileImage: '', token: '', gender: '');
  //   }
  // }

  // static changeUserAvailability(bool val) async {
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(Get.find<UserManager>().userId.toString())
  //       .update({'online': val});
  // }

  // // fav listings
  // static Future<List<FavListingModel>> getFavListings() async {
  //   final querySnapshot = await instance
  //       .collection('fav_listings')
  //       .where('userId', isEqualTo: UserManager.instance.userId)
  //       .withConverter<FavListingModel>(
  //         fromFirestore: (snapshot, _) =>
  //             FavListingModel.fromDocumentSnapshot(snapshot),
  //         toFirestore: (favListingModel, _) => favListingModel.toMap(),
  //       )
  //       .get();

  //   return querySnapshot.docs.map((doc) => doc.data()).toList();
  // }

  // static Stream<bool> isFavoriteStream(String listingId) {
  //   return FirebaseFirestore.instance
  //       .collection('fav_listings')
  //       .where('userId', isEqualTo: UserManager.instance.userId)
  //       .where('listingId', isEqualTo: listingId)
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs.isNotEmpty);
  // }

  // /// **Check if a Listing is Favorited**
  // static Future<bool> isListingFavorited(String listingId) async {
  //   try {
  //     final querySnapshot =
  //         await instance
  //             .collection('fav_listings')
  //             .where('userId', isEqualTo: userId)
  //             .where('listingIds', arrayContains: listingId)
  //             .get();

  //     return querySnapshot.docs.isNotEmpty;
  //   } catch (e) {
  //     log("Error checking favorite status: $e");
  //     return false;
  //   }
  // }

  // /// **Add Listing to Favorites**
  // static Future<bool> addToFavorites(String listingId) async {
  //   try {
  //     final existingDocs =
  //         await instance
  //             .collection('fav_listings')
  //             .where('userId', isEqualTo: userId)
  //             .get();

  //     if (existingDocs.docs.isNotEmpty) {
  //       final docRef = existingDocs.docs.first.reference;
  //       await docRef.update({
  //         'listingIds': FieldValue.arrayUnion([listingId]),
  //       });
  //     } else {
  //       await instance.collection('fav_listings').add({
  //         'userId': userId,
  //         'listingIds': [listingId],
  //         'createdAt': FieldValue.serverTimestamp(),
  //       });
  //     }
  //     return true;
  //   } catch (e) {
  //     log("Error adding to favorites: $e");
  //     return false;
  //   }
  // }

  // /// **Remove Listing from Favorites**
  // static Future<bool> removeFromFavorites(String listingId) async {
  //   try {
  //     final querySnapshot =
  //         await instance
  //             .collection('fav_listings')
  //             .where('userId', isEqualTo: userId)
  //             .where('listingIds', arrayContains: listingId)
  //             .get();

  //     if (querySnapshot.docs.isNotEmpty) {
  //       final docRef = querySnapshot.docs.first.reference;
  //       await docRef.update({
  //         'listingIds': FieldValue.arrayRemove([listingId]),
  //       });
  //     }

  //     return true;
  //   } catch (e) {
  //     log("Error removing from favorites: $e");
  //     return false;
  //   }
  // }

  //////             stop

  // static Future<bool> submitOrder(OrderModel orderModel) async {
  //   try {
  //     await instance.collection("orders").add(orderModel.toMap());

  //     return true;
  //   } catch (e) {
  //     log(e.toString());
  //     return false;
  //   }
  // }

  // static Future<bool> submitRequest(RequestModel requestModel) async {
  //   try {
  //     await instance.collection("requests").add(requestModel.toMap());

  //     return true;
  //   } catch (e) {
  //     log(e.toString());
  //     return false;
  //   }
  // }

  // static Future<bool> addToWishlist(String itemId) async {
  //   try {
  //     EasyLoading.show();
  //     await instance
  //         .collection("wishlist")
  //         .add({'itemId': itemId, 'userId': Get.find<UserManager>().userId});
  //     EasyLoading.dismiss();
  //     return true;
  //   } catch (e) {
  //     EasyLoading.dismiss();
  //     log(e.toString());
  //     return false;
  //   }
  // }

  // static Future<bool> removeWishlist(String id) async {
  //   try {
  //     EasyLoading.show();
  //     await instance.collection("wishlist").doc(id).delete();
  //     EasyLoading.dismiss();
  //     return true;
  //   } catch (e) {
  //     EasyLoading.dismiss();
  //     log(e.toString());
  //     return false;
  //   }
  // }

  // static Future<bool> updateRequesStatus(String id, String status) async {
  //   try {
  //     EasyLoading.show();
  //     await instance.collection("requests").doc(id).update({'status': status});
  //     EasyLoading.dismiss();

  //     return true;
  //   } catch (e) {
  //     EasyLoading.dismiss();
  //     log(e.toString());
  //     return false;
  //   }
  // }

  // static Future<bool> updateOrderStatus(
  //     String id, String status, List picture) async {
  //   try {
  //     EasyLoading.show();
  //     if (status == OrderStatus.ordered) {
  //       await instance
  //           .collection("orders")
  //           .doc(id)
  //           .update({'status': status, 'pictures': picture});
  //     } else {
  //       await instance
  //           .collection("orders")
  //           .doc(id)
  //           .update({'status': status, 'dropPicture': picture});
  //     }
  //     EasyLoading.dismiss();
  //     return true;
  //   } catch (e) {
  //     EasyLoading.dismiss();
  //     log(e.toString());
  //     return false;
  //   }
  // }

  // static Future<bool> updateReviewStatus(String id) async {
  //   try {
  //     EasyLoading.show();

  //     await instance.collection("orders").doc(id).update({
  //       'ratingDone': true,
  //     });

  //     EasyLoading.dismiss();
  //     return true;
  //   } catch (e) {
  //     EasyLoading.dismiss();
  //     log(e.toString());
  //     return false;
  //   }
  // }

  // static Future<OrderModel?> checkPreviousReviews() async {
  //   try {
  //     var query = await instance
  //         .collection('orders')
  //         .withConverter<OrderModel>(
  //             fromFirestore: (r, _) => OrderModel.fromDocumentSnapshot(r),
  //             toFirestore: (r, _) => r.toMap())
  //         .where(
  //           'ratingDone',
  //           isEqualTo: false,
  //         )
  //         .limit(1)
  //         .get();
  //     if (query.docs.isNotEmpty) {
  //       return query.docs.first.data();
  //     }
  //     return null;
  //   } catch (e) {
  //     EasyLoading.dismiss();
  //     log(e.toString());
  //     return null;
  //   }
  // }

  // static Stream<QuerySnapshot<DocModel>> getMyDocs(String type) {
  //   return instance
  //       .collection('users')
  //       .doc(userId)
  //       .collection('data')
  //       .withConverter<DocModel>(
  //           fromFirestore: (r, _) => DocModel.fromDocumentSnapshot(r),
  //           toFirestore: (r, _) => r.toMap())
  //       .where(
  //         'type',
  //         isEqualTo: type,
  //       )
  //       .snapshots();
  // }

  // static Future<QuerySnapshot<DocModel>> getMyDocsFuture(String type) {
  //   return instance
  //       .collection('users')
  //       .doc(userId)
  //       .collection('data')
  //       .withConverter<DocModel>(
  //           fromFirestore: (r, _) => DocModel.fromDocumentSnapshot(r),
  //           toFirestore: (r, _) => r.toMap())
  //       .where(
  //         'type',
  //         isEqualTo: type,
  //       )
  //       .get();
  // }

  // static Stream<QuerySnapshot<ItemModel>> getMyListing() {
  //   return instance
  //       .collection('items')
  //       .withConverter<ItemModel>(
  //           fromFirestore: (r, _) => ItemModel.fromDocumentSnapshot(r),
  //           toFirestore: (r, _) => r.toMap())
  //       .where(
  //         'userId',
  //         isEqualTo: Get.find<UserManager>().userId,
  //       )
  //       .where('status',
  //           whereIn: [ItemStatus.available, ItemStatus.inUse]).snapshots();
  // }

  // static Stream<QuerySnapshot<Map<String, dynamic>>> checkWishlist(String id) {
  //   return instance
  //       .collection('wishlist')
  //       .where(
  //         'userId',
  //         isEqualTo: Get.find<UserManager>().userId,
  //       )
  //       .where('itemId', isEqualTo: id)
  //       .snapshots();
  // }

  // static Stream<QuerySnapshot<Map<String, dynamic>>> getMyWishlist() {
  //   return instance
  //       .collection('wishlist')
  //       .where(
  //         'userId',
  //         isEqualTo: Get.find<UserManager>().userId,
  //       )
  //       .snapshots();
  // }

  // static Stream<QuerySnapshot<RequestModel>> getMyRequest() {
  //   return instance
  //       .collection('requests')
  //       .withConverter<RequestModel>(
  //           fromFirestore: (r, _) => RequestModel.fromDocumentSnapshot(r),
  //           toFirestore: (r, _) => r.toMap())
  //       .where(
  //         'requestBy',
  //         isEqualTo: Get.find<UserManager>().userId,
  //       )
  //       .where('status', whereIn: [
  //     RequestStatus.requested,
  //     RequestStatus.accepted
  //   ]).snapshots();
  // }

  // static Stream<QuerySnapshot<OrderModel>> getMyOrder(int status,
  //     {bool getIncoming = false}) {
  //   String key = getIncoming ? 'requestTo' : 'requestBy';
  //   if (status == 0) {
  //     return instance
  //         .collection('orders')
  //         .withConverter<OrderModel>(
  //             fromFirestore: (r, _) => OrderModel.fromDocumentSnapshot(r),
  //             toFirestore: (r, _) => r.toMap())
  //         .where(
  //           key,
  //           isEqualTo: Get.find<UserManager>().userId,
  //         )
  //         .snapshots();
  //   } else if (status == 1) {
  //     return instance
  //         .collection('orders')
  //         .withConverter<OrderModel>(
  //             fromFirestore: (r, _) => OrderModel.fromDocumentSnapshot(r),
  //             toFirestore: (r, _) => r.toMap())
  //         .where(
  //           key,
  //           isEqualTo: Get.find<UserManager>().userId,
  //         )
  //         .where('status', isEqualTo: OrderStatus.picked)
  //         .snapshots();
  //   } else {
  //     return instance
  //         .collection('orders')
  //         .withConverter<OrderModel>(
  //             fromFirestore: (r, _) => OrderModel.fromDocumentSnapshot(r),
  //             toFirestore: (r, _) => r.toMap())
  //         .where(
  //           key,
  //           isEqualTo: Get.find<UserManager>().userId,
  //         )
  //         .where('status', isEqualTo: OrderStatus.drop)
  //         .snapshots();
  //   }
  // }

  // static Stream<QuerySnapshot<RequestModel>> getIncomingRequest() {
  //   return instance
  //       .collection('requests')
  //       .withConverter<RequestModel>(
  //           fromFirestore: (r, _) => RequestModel.fromDocumentSnapshot(r),
  //           toFirestore: (r, _) => r.toMap())
  //       .where(
  //         'requestTo',
  //         isEqualTo: Get.find<UserManager>().userId,
  //       )
  //       .where('status', whereIn: [
  //     RequestStatus.requested,
  //     RequestStatus.accepted
  //   ]).snapshots();
  // }

  // static deleteRequest(id) {
  //   return instance.collection('requests').doc(id).delete();
  // }

  // static Stream<DocumentSnapshot<ItemModel>> getSingleItemStream(String id) {
  //   return instance
  //       .collection('items')
  //       .withConverter<ItemModel>(
  //           fromFirestore: (r, _) => ItemModel.fromDocumentSnapshot(r),
  //           toFirestore: (r, _) => r.toMap())
  //       .doc(id)
  //       .snapshots();
  // }

  // static Future<DocumentSnapshot<ItemModel>> getSingleItemSnap(String id) {
  //   return instance
  //       .collection('items')
  //       .withConverter<ItemModel>(
  //           fromFirestore: (r, _) => ItemModel.fromDocumentSnapshot(r),
  //           toFirestore: (r, _) => r.toMap())
  //       .doc(id)
  //       .get();
  // }

  // static Stream<QuerySnapshot<Map<String, dynamic>>> getSingleRating(
  //     String id) {
  //   return instance
  //       .collection('rating')
  //       .where('userId', isEqualTo: Get.find<UserManager>().userId)
  //       .where('orderId', isEqualTo: id)
  //       .snapshots();
  // }

  // static Stream<QuerySnapshot<Map<String, dynamic>>> getSingleRatingUser(
  //     String id) {
  //   return instance
  //       .collection('userRating')
  //       .where('fromUser', isEqualTo: Get.find<UserManager>().userId)
  //       .where('orderId', isEqualTo: id)
  //       .snapshots();
  // }

  // static Future<QuerySnapshot<Map<String, dynamic>>> getItemRatingsFuture(
  //     String id) {
  //   return instance.collection('rating').where('itemId', isEqualTo: id).get();
  // }

  // static Future<QuerySnapshot<Map<String, dynamic>>> getUserRatingsFuture(
  //     String id) {
  //   return instance
  //       .collection('userRating')
  //       .where('toUser', isEqualTo: id)
  //       .get();
  // }

  // static Stream<DocumentSnapshot<UserModel>> getSingleUser(String id) {
  //   return instance
  //       .collection('users')
  //       .withConverter<UserModel>(
  //           fromFirestore: (r, _) => UserModel.fromDocumentSnapshot(r),
  //           toFirestore: (r, _) => r.toMap())
  //       .doc(id)
  //       .snapshots();
  // }

  // static Future<DocumentSnapshot<ChatGroupModel>> getSingleChat(String id) {
  //   return FirebaseFirestore.instance
  //       .collection('chats')
  //       .withConverter<ChatGroupModel>(
  //           fromFirestore: (r, _) => ChatGroupModel.fromMap(r),
  //           toFirestore: (r, _) => r.toMap())
  //       .doc(id)
  //       .get();
  // }

  // static Stream<QuerySnapshot<ChatGroupModel>> getChatRoomStatus(
  //     String userId) {
  //   return instance
  //       .collection('chats')
  //       .withConverter<ChatGroupModel>(
  //           fromFirestore: (r, _) => ChatGroupModel.fromMap(r),
  //           toFirestore: (r, _) => r.toMap())
  //       .where('check',
  //           arrayContains: '${userId}${Get.find<UserManager>().userId}')
  //       // .where('jobId', isEqualTo: jobId)
  //       .snapshots();
  //   // .data();
  // }

  // static Stream<QuerySnapshot<ApplicantModel>> getAppliedJobs() {
  //   return instance
  //       .collection('applicants')
  //       .withConverter<ApplicantModel>(
  //           fromFirestore: (r, _) => ApplicantModel.fromDocumentSnapshot(r),
  //           toFirestore: (r, _) => r.toMap())
  //       .where('userId', isEqualTo: userId)
  //       .snapshots();
  // }

  // static Stream<QuerySnapshot<ApplicantModel>> checkJobAppliedOrNot(jobId) {
  //   return instance
  //       .collection('applicants')
  //       .withConverter<ApplicantModel>(
  //           fromFirestore: (r, _) => ApplicantModel.fromDocumentSnapshot(r),
  //           toFirestore: (r, _) => r.toMap())
  //       .where('userId', isEqualTo: userId)
  //       .where('jobId', isEqualTo: jobId)
  //       .snapshots();
  // }

  // static Stream<List<ApplicantModel>> getAppliedJobs() {
  //   return FirebaseFirestore.instance
  //       .collection('applicants')
  //       .where('userId', isEqualTo: userId)
  //       .snapshots()
  //       .asyncMap((querySnapshot) async {
  //     List<ApplicantModel> applicants = [];

  //     for (QueryDocumentSnapshot applicantSnapshot in querySnapshot.docs) {
  //       ApplicantModel applicant = ApplicantModel.fromDocumentSnapshot(applicantSnapshot);

  //       // Retrieve the job document using jobId
  //       DocumentSnapshot jobSnapshot = await FirebaseFirestore.instance
  //           .collection('jobs')
  //           .doc(applicant.jobId)
  //           .get();

  //       if (jobSnapshot.exists) {
  //         // Add the job data to the applicant
  //         ItemModel job = JobModel.fromDocumentSnapshot(jobSnapshot);
  //         applicant.job = job;
  //         applicants.add(applicant);
  //       }
  //     }

  //     return applicants;
  //   });
  // }

  // static Stream<QuerySnapshot<ItemModel>> getAllJobs() {
  //   return instance
  //       .collection('items')
  //       .withConverter<ItemModel>(
  //           fromFirestore: (r, _) => ItemModel.fromDocumentSnapshot(r),
  //           toFirestore: (r, _) => r.toMap())
  //       .where(
  //         'userId',
  //         isNotEqualTo: userId,
  //       )
  //       .snapshots();
  // }

  // static Stream<List<DocumentSnapshot<ItemModel>>> getNearByItems(
  //     LatLng latLng, String search,
  //     {int radius = 50}) {
  //   GeoPoint tokyoStation = GeoPoint(latLng.latitude, latLng.longitude);
  //   final GeoFirePoint center = GeoFirePoint(tokyoStation);
  //   double radiusInKm = radius.toDouble();
  //   const String field = 'geo';

  //   Query<ItemModel> queryBuilderAll(Query<ItemModel> query) =>
  //       query.where('nameArray', arrayContainsAny: ['']);

  //   final CollectionReference<ItemModel> collectionReference =
  //       FirebaseFirestore.instance.collection('items').withConverter(
  //           fromFirestore: (u, _) => ItemModel.fromDocumentSnapshot(u),
  //           toFirestore: (u, _) => u.toMap());
  //   return GeoCollectionReference<ItemModel>(collectionReference)
  //       .subscribeWithin(
  //     center: center,
  //     radiusInKm: radiusInKm,
  //     field: field,
  //     strictMode: true,
  //     geopointFrom: (ItemModel userModel) => userModel.geo,
  //     // queryBuilder: queryBuilderAll
  //   );
  // }

  // static Future<List<DocumentSnapshot<ItemModel>>> getNearByItemsOnTim(
  //     LatLng latLng, String search,
  //     {int radius = 50}) {
  //   GeoPoint tokyoStation = GeoPoint(latLng.latitude, latLng.longitude);
  //   final GeoFirePoint center = GeoFirePoint(tokyoStation);
  //   double radiusInKm = radius.toDouble();
  //   const String field = 'geo';

  //   Query<ItemModel> queryBuilderAll(Query<ItemModel> query) =>
  //       query.where('nameArray', arrayContainsAny: ['']);

  //   final CollectionReference<ItemModel> collectionReference =
  //       FirebaseFirestore.instance.collection('items').withConverter(
  //           fromFirestore: (u, _) => ItemModel.fromDocumentSnapshot(u),
  //           toFirestore: (u, _) => u.toMap());
  //   return GeoCollectionReference<ItemModel>(collectionReference).fetchWithin(
  //     center: center,
  //     radiusInKm: radiusInKm,
  //     field: field,
  //     strictMode: true,
  //     geopointFrom: (ItemModel userModel) => userModel.geo,
  //     // queryBuilder: queryBuilderAll
  //   );
  // }

  // static Stream<List<DocumentSnapshot<ItemModel>>> getNearByJobs(LatLng latLng,
  //     {int radius = 50}) {
  //   GeoPoint tokyoStation = GeoPoint(latLng.latitude, latLng.longitude);
  //   final GeoFirePoint center = GeoFirePoint(tokyoStation);
  //   double radiusInKm = radius.toDouble();
  //   const String field = 'geo';
  //   Query<ItemModel> queryBuilder(Query<ItemModel> query) => query
  //       .where('category', isEqualTo: 'job')
  //       .where('nameArray', arrayContainsAny: ['']);
  //   final CollectionReference<ItemModel> collectionReference =
  //       FirebaseFirestore.instance.collection('items').withConverter(
  //           fromFirestore: (u, _) => ItemModel.fromDocumentSnapshot(u),
  //           toFirestore: (u, _) => u.toMap());
  //   return GeoCollectionReference<ItemModel>(collectionReference)
  //       .subscribeWithin(
  //     center: center,
  //     radiusInKm: radiusInKm,
  //     field: field,
  //     strictMode: true,
  //     geopointFrom: (ItemModel userModel) => userModel.geo,
  //     // queryBuilder: queryBuilder
  //   );
  // }

  // static Stream<List<DocumentSnapshot<UserModel>>> getNearByBuddies(
  //     LatLng latLng, String search,
  //     {int radius = 50}) {
  //   GeoPoint tokyoStation = GeoPoint(latLng.latitude, latLng.longitude);
  //   final GeoFirePoint center = GeoFirePoint(tokyoStation);
  //   double radiusInKm = radius.toDouble();
  //   const String field = 'geo';
  //   // Query<UserModel> queryBuilder(Query<UserModel> query) =>
  //   //     query.where('email', : [Get.find<UserManager>().email]);
  //   final CollectionReference<UserModel> collectionReference =
  //       FirebaseFirestore.instance.collection('users').withConverter(
  //           fromFirestore: (u, _) => UserModel.fromDocumentSnapshot(u),
  //           toFirestore: (u, _) => u.toMap());
  //   return GeoCollectionReference<UserModel>(collectionReference)
  //       .subscribeWithin(
  //     center: center,
  //     radiusInKm: radiusInKm,
  //     field: field,
  //     strictMode: true,
  //     geopointFrom: (UserModel userModel) => userModel.geo as GeoPoint,
  //     // queryBuilder: queryBuilder
  //   );
  // }

  // static Future<List<DocumentSnapshot<UserModel>>> getNearByBuddiesOneTime(
  //     LatLng latLng, String search,
  //     {int radius = 50}) {
  //   GeoPoint tokyoStation = GeoPoint(latLng.latitude, latLng.longitude);
  //   final GeoFirePoint center = GeoFirePoint(tokyoStation);
  //   double radiusInKm = radius.toDouble();
  //   const String field = 'geo';
  //   // Query<UserModel> queryBuilder(Query<UserModel> query) =>
  //   //     query.where('email', : [Get.find<UserManager>().email]);
  //   final CollectionReference<UserModel> collectionReference =
  //       FirebaseFirestore.instance.collection('users').withConverter(
  //           fromFirestore: (u, _) => UserModel.fromDocumentSnapshot(u),
  //           toFirestore: (u, _) => u.toMap());
  //   return GeoCollectionReference<UserModel>(collectionReference).fetchWithin(
  //     center: center,
  //     radiusInKm: radiusInKm,
  //     field: field,
  //     strictMode: true,
  //     geopointFrom: (UserModel userModel) => userModel.geo as GeoPoint,
  //     // queryBuilder: queryBuilder
  //   );
  // }

  // static Future<int> getListCount() async {
  //   var count = await instance
  //       .collection('items')
  //       .where('userId', isEqualTo: Get.find<UserManager>().userId)
  //       .where('status', whereNotIn: [ItemStatus.removed])
  //       .count()
  //       .get();
  //   return count.count ?? 0;
  // }

  // static Future<int> myOrderCount() async {
  //   var count = await instance
  //       .collection('orders')
  //       .withConverter<OrderModel>(
  //           fromFirestore: (r, _) => OrderModel.fromDocumentSnapshot(r),
  //           toFirestore: (r, _) => r.toMap())
  //       .where(
  //         'requestBy',
  //         isEqualTo: Get.find<UserManager>().userId,
  //       )
  //       .count()
  //       .get();

  //   return count.count ?? 0;
  // }

  // static deleteItem(String id) {
  //   return instance
  //       .collection('items')
  //       .doc(id)
  //       .update({'status': ItemStatus.removed});
  // }

  // static deleteDoc(String id) {
  //   return instance
  //       .collection('users')
  //       .doc(userId)
  //       .collection('data')
  //       .doc(id)
  //       .delete();
  // }

  // static Future addDoc(String name, String type, String url) {
  //   return instance
  //       .collection('users')
  //       .doc(userId)
  //       .collection('data')
  //       .add({'name': name, 'type': type, 'url': url});
  // }

  // static Future giveRating(
  //     {required String orderId,
  //     required String itemId,
  //     required String comment,
  //     required int rate}) async {
  //   await instance.collection('rating').add({
  //     'orderId': orderId,
  //     'itemId': itemId,
  //     'createdAt': Timestamp.now(),
  //     'userId': Get.find<UserManager>().userId,
  //     'comment': comment,
  //     'rate': rate,
  //   });
  // }

  // static Future giveUserRating(
  //     {required String orderId,
  //     required String itemId,
  //     required String userId,
  //     required String comment,
  //     required int rate}) async {
  //   await instance.collection('userRating').add({
  //     'orderId': orderId,
  //     'itemId': itemId,
  //     'createdAt': Timestamp.now(),
  //     'fromUser': Get.find<UserManager>().userId,
  //     'toUser': userId,
  //     'comment': comment,
  //     'rate': rate,
  //   });
  // }
}
