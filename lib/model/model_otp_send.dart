// To parse this JSON data, do
//
//     final modelOtpSend = modelOtpSendFromJson(jsonString);

import 'dart:convert';

ModelOtpSend modelOtpSendFromJson(String str) => ModelOtpSend.fromJson(json.decode(str));

String modelOtpSendToJson(ModelOtpSend data) => json.encode(data.toJson());

class ModelOtpSend {
    int value;
    String message;

    ModelOtpSend({
        required this.value,
        required this.message,
    });

    factory ModelOtpSend.fromJson(Map<String, dynamic> json) => ModelOtpSend(
        value: json["value"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "value": value,
        "message": message,
    };
}
