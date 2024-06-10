// To parse this JSON data, do
//
//     final modelCategorySneaker = modelCategorySneakerFromJson(jsonString);

import 'dart:convert';

ModelCategorySneaker modelCategorySneakerFromJson(String str) => ModelCategorySneaker.fromJson(json.decode(str));

String modelCategorySneakerToJson(ModelCategorySneaker data) => json.encode(data.toJson());

class ModelCategorySneaker {
    bool isSuccess;
    String message;
    List<Datum> data;

    ModelCategorySneaker({
        required this.isSuccess,
        required this.message,
        required this.data,
    });

    factory ModelCategorySneaker.fromJson(Map<String, dynamic> json) => ModelCategorySneaker(
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
    String id;
    String productName;
    String productPrice;
    String productStock;
    String productImage;
    String productDescription;
    ProductCategory productCategory;

    Datum({
        required this.id,
        required this.productName,
        required this.productPrice,
        required this.productStock,
        required this.productImage,
        required this.productDescription,
        required this.productCategory,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        productName: json["product_name"],
        productPrice: json["product_price"],
        productStock: json["product_stock"],
        productImage: json["product_image"],
        productDescription: json["product_description"],
        productCategory: productCategoryValues.map[json["product_category"]]!,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "product_name": productName,
        "product_price": productPrice,
        "product_stock": productStock,
        "product_image": productImage,
        "product_description": productDescription,
        "product_category": productCategoryValues.reverse[productCategory],
    };
}

enum ProductCategory {
    SNEAKER
}

final productCategoryValues = EnumValues({
    "sneaker": ProductCategory.SNEAKER
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
