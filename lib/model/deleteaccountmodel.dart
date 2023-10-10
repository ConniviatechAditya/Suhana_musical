// To parse this JSON data, do
//
//     final deleteaccountModel = deleteaccountModelFromJson(jsonString);

import 'dart:convert';

DeleteaccountModel deleteaccountModelFromJson(String str) =>
    DeleteaccountModel.fromJson(json.decode(str));

String deleteaccountModelToJson(DeleteaccountModel data) =>
    json.encode(data.toJson());

class DeleteaccountModel {
  int? status;
  String? message;
  List<dynamic>? result;

  DeleteaccountModel({
    this.status,
    this.message,
    this.result,
  });

  factory DeleteaccountModel.fromJson(Map<String, dynamic> json) =>
      DeleteaccountModel(
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
