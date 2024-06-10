// To parse this JSON data, do
//
//     final modelRegister = modelRegisterFromJson(jsonString);

import 'dart:convert';

ModelRegister modelRegisterFromJson(String str) => ModelRegister.fromJson(json.decode(str));

String modelRegisterToJson(ModelRegister data) => json.encode(data.toJson());

class ModelRegister {
    int value;
    String username;
    String email;
    String address;
    String password;
    String status;
    String message;

    ModelRegister({
        required this.value,
        required this.username,
        required this.email,
        required this.address,
        required this.password,
        required this.status,
        required this.message,
    });

    factory ModelRegister.fromJson(Map<String, dynamic> json) => ModelRegister(
        value: json["value"],
        username: json["username"],
        email: json["email"],
        address: json["address"],
        password: json["password"],
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "value": value,
        "username": username,
        "email": email,
        "address": address,
        "password": password,
        "status": status,
        "message": message,
    };
}
