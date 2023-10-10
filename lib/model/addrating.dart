// To parse this JSON data, do
//
//     final addratingModel = addratingModelFromJson(jsonString);

import 'dart:convert';

AddratingModel addratingModelFromJson(String str) =>
    AddratingModel.fromJson(json.decode(str));

String addratingModelToJson(AddratingModel data) => json.encode(data.toJson());

class AddratingModel {
  AddratingModel({
    this.status,
    this.message,
  });

  int? status;
  String? message;

  factory AddratingModel.fromJson(Map<String, dynamic> json) => AddratingModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
