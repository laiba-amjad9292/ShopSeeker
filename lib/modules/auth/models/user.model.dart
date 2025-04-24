// To parse this JSON data, do
//
//     final userModel = userModelFromMap(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

UserModel userModelFromMap(String str) => UserModel.fromMap(json.decode(str));

String userModelToMap(UserModel data) => json.encode(data.toMap());

class UserModel {
  String name;
  String email;
  String id;
  String phone;
  bool approved;
  String profileImage;
  String signInMethod;
  String? token;
  String? gender;
  List? permissions;

  UserModel({
    required this.name,
    required this.email,
    required this.id,
    required this.phone,
    required this.approved,
    required this.profileImage,
    required this.signInMethod,
    this.token,
    this.gender,
    this.permissions,
  });

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
    name: json["name"] ?? "",
    email: json["email"] ?? "",
    id: json["id"] ?? "",
    phone: json["phone"] ?? "",
    approved: json["approved"] ?? false,
    profileImage: json["profileImage"] ?? "",
    signInMethod: json["signInMethod"] ?? "",
    token: json["token"] ?? "",
    gender: json["gender"] ?? "",
    permissions: json["permissions"] ?? [],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "email": email,
    "id": id,
    "phone": phone,
    "approved": approved,
    "profileImage": profileImage,
    "signInMethod": signInMethod,
    "token": token,
    "gender": gender,
    "permissions": permissions,
  };

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) => UserModel(
    name: doc["name"] ?? "",
    email: doc["email"] ?? "",
    id: doc["id"] ?? "",
    phone: doc["phone"] ?? "",
    approved: doc["approved"] ?? false,
    profileImage: doc["profileImage"] ?? "",
    signInMethod: doc["signInMethod"] ?? "",
    token: doc["token"] ?? "",
    gender: doc["gender"] ?? "",
    permissions: doc["permissions"] ?? [],
  );
}
