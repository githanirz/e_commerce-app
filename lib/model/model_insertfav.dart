// To parse this JSON data, do
//
//     final modelInsertFavorite = modelInsertFavoriteFromJson(jsonString);

import 'dart:convert';

ModelInsertFavorite modelInsertFavoriteFromJson(String str) =>
    ModelInsertFavorite.fromJson(json.decode(str));

String modelInsertFavoriteToJson(ModelInsertFavorite data) =>
    json.encode(data.toJson());

class ModelInsertFavorite {
  final bool isSuccess;
  final String message;
  final List<dynamic> data;

  ModelInsertFavorite({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelInsertFavorite.fromJson(Map<String, dynamic> json) =>
      ModelInsertFavorite(
        isSuccess: json["isSuccess"],
        message: json["message"],
        data: List<dynamic>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x)),
      };
}
