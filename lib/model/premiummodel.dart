// To parse this JSON data, do
//
//     final premiumModel = premiumModelFromJson(jsonString);

import 'dart:convert';

PremiumModel premiumModelFromJson(String str) =>
    PremiumModel.fromJson(json.decode(str));

String premiumModelToJson(PremiumModel data) => json.encode(data.toJson());

class PremiumModel {
  PremiumModel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<Result>? result;

  factory PremiumModel.fromJson(Map<String, dynamic> json) => PremiumModel(
        status: json["status"],
        message: json["message"],
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    this.id,
    this.name,
    this.price,
    this.image,
    this.currencyType,
    this.packageType,
    this.time,
    this.type,
    this.status,
    this.date,
    this.createdAt,
    this.updatedAt,
    this.isBuy,
  });

  int? id;
  String? name;
  int? price;
  String? image;
  String? currencyType;
  String? packageType;
  int? time;
  String? type;
  int? status;
  String? date;
  String? createdAt;
  String? updatedAt;
  int? isBuy;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        image: json["image"],
        currencyType: json["currency_type"],
        packageType: json["package_type"],
        time: json["time"],
        type: json["type"],
        status: json["status"],
        date: json["date"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        isBuy: json["is_buy"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
        "image": image,
        "currency_type": currencyType,
        "package_type": packageType,
        "time": time,
        "type": type,
        "status": status,
        "date": date,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "is_buy": isBuy,
      };
}
