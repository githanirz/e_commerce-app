// To parse this JSON data, do
//
//     final modelForgetPass = modelForgetPassFromJson(jsonString);

import 'dart:convert';

ModelForgetPass modelForgetPassFromJson(String str) =>
    ModelForgetPass.fromJson(json.decode(str));

String modelForgetPassToJson(ModelForgetPass data) =>
    json.encode(data.toJson());

class ModelForgetPass {
  int value;
  String message;

  ModelForgetPass({
    required this.value,
    required this.message,
  });

  factory ModelForgetPass.fromJson(Map<String, dynamic> json) =>
      ModelForgetPass(
        value: json["value"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "message": message,
      };
}
