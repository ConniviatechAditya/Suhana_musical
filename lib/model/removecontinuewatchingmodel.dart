// To parse this JSON data, do
//
//     final removecontinuewatchingModel = removecontinuewatchingModelFromJson(jsonString);

import 'dart:convert';

RemovecontinuewatchingModel removecontinuewatchingModelFromJson(String str) =>
    RemovecontinuewatchingModel.fromJson(json.decode(str));

String removecontinuewatchingModelToJson(RemovecontinuewatchingModel data) =>
    json.encode(data.toJson());

class RemovecontinuewatchingModel {
  int? status;
  String? message;
  List<dynamic>? result;

  RemovecontinuewatchingModel({
    this.status,
    this.message,
    this.result,
  });

  factory RemovecontinuewatchingModel.fromJson(Map<String, dynamic> json) =>
      RemovecontinuewatchingModel(
        status: json["status"],
        message: json["message"],
        result: List<dynamic>.from(json["result"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(result!.map((x) => x)),
      };
}
