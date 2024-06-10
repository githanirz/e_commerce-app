import 'dart:convert';

ModelListFavorite modelListFavoriteFromJson(String str) =>
    ModelListFavorite.fromJson(json.decode(str));

String modelListFavoriteToJson(ModelListFavorite data) =>
    json.encode(data.toJson());

class ModelListFavorite {
  final bool isSuccess;
  final String message;
  final List<Datum> data;

  ModelListFavorite({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelListFavorite.fromJson(Map<String, dynamic> json) =>
      ModelListFavorite(
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
  final String productId;
  final String productName;
  final String productPrice;
  final String productStock;
  final String productImage;

  Datum({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productStock,
    required this.productImage,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        productId: json["product_id"],
        productName: json["product_name"],
        productPrice: json["product_price"],
        productStock: json["product_stock"],
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
