// To parse this JSON data, do
//
//     final modelEditProfile = modelEditProfileFromJson(jsonString);

import 'dart:convert';

ModelEditProfile modelEditProfileFromJson(String str) =>
    ModelEditProfile.fromJson(json.decode(str));

String modelEditProfileToJson(ModelEditProfile data) =>
    json.encode(data.toJson());

class ModelEditProfile {
  final bool isSuccess;
  final int value;
  final String message;
  final UserInfo userInfo;

  ModelEditProfile({
    required this.isSuccess,
    required this.value,
    required this.message,
    required this.userInfo,
  });

  factory ModelEditProfile.fromJson(Map<String, dynamic> json) =>
      ModelEditProfile(
        isSuccess: json["isSuccess"],
        value: json["value"],
        message: json["message"],
        userInfo: UserInfo.fromJson(json["user_info"]),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "value": value,
        "message": message,
        "user_info": userInfo.toJson(),
      };
}

class UserInfo {
  final String id;
  final String username;
  final String email;
  final String address;

  UserInfo({
    required this.id,
    required this.username,
    required this.email,
    required this.address,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "address": address,
      };
}
