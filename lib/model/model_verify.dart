// To parse this JSON data, do
//
//     final modelVerify = modelVerifyFromJson(jsonString);

import 'dart:convert';

ModelVerify modelVerifyFromJson(String str) => ModelVerify.fromJson(json.decode(str));

String modelVerifyToJson(ModelVerify data) => json.encode(data.toJson());

class ModelVerify {
    int value;
    String message;

    ModelVerify({
        required this.value,
        required this.message,
    });

    factory ModelVerify.fromJson(Map<String, dynamic> json) => ModelVerify(
        value: json["value"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "value": value,
        "message": message,
    };
}
