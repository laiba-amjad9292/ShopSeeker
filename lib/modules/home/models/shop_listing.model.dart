import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_seeker/global/models/translations.model.dart';

class ListingModel {
  final String userId;
  final String id;
  final String name;
  final String category;
  final String address;
  final String country;
  final String city;
  final String postalCode;
  final String timingWeekdays;
  final String timingWeekends;
  final String description;
  final List<String> image;
  final String mainImage;
  final Tr type;
  Timestamp? createdAt;

  ListingModel({
    required this.userId,
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.country,
    required this.city,
    required this.postalCode,
    required this.timingWeekdays,
    required this.timingWeekends,
    required this.description,
    required this.image,
    required this.mainImage,
    required this.type,
    this.createdAt,
  });

  factory ListingModel.fromMap(Map<String, dynamic> map) {
    return ListingModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      address: map['address'] ?? '',
      country: map['country'] ?? '',
      city: map['city'] ?? '',
      postalCode: map['postalCode'] ?? '',
      timingWeekdays: map['timingWeekdays'] ?? '',
      timingWeekends: map['timingWeekends'] ?? '',
      description: map['description'] ?? '',
      image: List<String>.from(map['image'] ?? []),
      mainImage: map['mainImage'] ?? '',
      type: Tr.fromMap(map['type'] ?? {}),
      // type: Tr(map['type'] ?? 'shop'),
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'id': id,
      'name': name,
      'category': category,
      'address': address,
      'country': country,
      'city': city,
      'postalCode': postalCode,
      'timingWeekdays': timingWeekdays,
      'timingWeekends': timingWeekends,
      'description': description,
      'image': image,
      'mainImage': mainImage,
      'type': type.translations,
      'createdAt': createdAt,
    };
  }

  factory ListingModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ListingModel.fromMap(data);
  }
}
