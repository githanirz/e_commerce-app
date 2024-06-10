// To parse this JSON data, do
//
//     final modelAddtoCart = modelAddtoCartFromJson(jsonString);

import 'dart:convert';

ModelAddtoCart modelAddtoCartFromJson(String str) => ModelAddtoCart.fromJson(json.decode(str));

String modelAddtoCartToJson(ModelAddtoCart data) => json.encode(data.toJson());

class ModelAddtoCart {
    bool isSuccess;
    String message;
    List<dynamic> data;

    ModelAddtoCart({
        required this.isSuccess,
        required this.message,
        required this.data,
    });

    factory ModelAddtoCart.fromJson(Map<String, dynamic> json) => ModelAddtoCart(
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
