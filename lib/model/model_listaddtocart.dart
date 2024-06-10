// To parse this JSON data, do
//
//     final modelListAddtoCart = modelListAddtoCartFromJson(jsonString);

import 'dart:convert';

ModelListAddtoCart modelListAddtoCartFromJson(String str) => ModelListAddtoCart.fromJson(json.decode(str));

String modelListAddtoCartToJson(ModelListAddtoCart data) => json.encode(data.toJson());

class ModelListAddtoCart {
  bool isSuccess;
  String message;
  List<CardDatum> data;

  ModelListAddtoCart({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelListAddtoCart.fromJson(Map<String, dynamic> json) {
    return ModelListAddtoCart(
      isSuccess: json["isSuccess"],
      message: json["message"],
      data: json["data"] != null
          ? List<CardDatum>.from(json["data"].map((x) => CardDatum.fromJson(x)))
          : [], // Periksa apakah data tidak null sebelum mapping
    );
  }

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CardDatum {
  String productId;
  String productName;
  String productPrice;
  String productStock;
  String productImage;
  int quantity;

  CardDatum({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productStock,
    required this.productImage,
    this.quantity = 1,
  });

  factory CardDatum.fromJson(Map<String, dynamic> json) {
    return CardDatum(
      productId: json["product_id"] ?? "", // Berikan nilai default jika null
      productName: json["product_name"] ?? "", // Berikan nilai default jika null
      productPrice: json["product_price"] ?? "", // Berikan nilai default jika null
      productStock: json["product_stock"] ?? "", // Berikan nilai default jika null
      productImage: json["product_image"] ?? "", // Berikan nilai default jika null
    );
  }

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_name": productName,
        "product_price": productPrice,
        "product_stock": productStock,
        "product_image": productImage,
      };
}
