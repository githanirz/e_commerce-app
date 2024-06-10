// To parse this JSON data, do
//
//     final modelListCart = modelListCartFromJson(jsonString);

import 'dart:convert';

ModelListCart modelListCartFromJson(String str) => ModelListCart.fromJson(json.decode(str));

String modelListCartToJson(ModelListCart data) => json.encode(data.toJson());

class ModelListCart {
    bool isSuccess;
    String message;
    List<Datum> data;

    ModelListCart({
        required this.isSuccess,
        required this.message,
        required this.data,
    });

    factory ModelListCart.fromJson(Map<String, dynamic> json) => ModelListCart(
        isSuccess: json["isSuccess"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String productId;
    String productName;
    String productPrice;
    int productStock;
    String productImage;

    Datum({
        required this.productId,
        required this.productName,
        required this.productPrice,
        this.productStock = 1,
        required this.productImage,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        productId: json["product_id"],
        productName: json["product_name"],
        productPrice: json["product_price"],
        productStock: json["product_stock"]??1,
        productImage: json["product_image"],
    );

    Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_name": productName,
        "product_price": productPrice,
        "product_stock": productStock,
        "product_image": productImage,
    };
}
