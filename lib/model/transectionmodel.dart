// To parse this JSON data, do
//
//     final transectionModel = transectionModelFromJson(jsonString);

import 'dart:convert';

TransectionModel transectionModelFromJson(String str) =>
    TransectionModel.fromJson(json.decode(str));

String transectionModelToJson(TransectionModel data) =>
    json.encode(data.toJson());

class TransectionModel {
  TransectionModel({
    this.status,
    this.message,
  });

  int? status;
  String? message;

  factory TransectionModel.fromJson(Map<String, dynamic> json) =>
      TransectionModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
