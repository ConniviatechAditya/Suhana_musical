// To parse this JSON data, do
//
//     final updateprofileModel = updateprofileModelFromJson(jsonString);

import 'dart:convert';

UpdateprofileModel updateprofileModelFromJson(String str) =>
    UpdateprofileModel.fromJson(json.decode(str));

String updateprofileModelToJson(UpdateprofileModel data) =>
    json.encode(data.toJson());

class UpdateprofileModel {
  UpdateprofileModel({
    this.status,
    this.message,
  });

  int? status;
  String? message;

  factory UpdateprofileModel.fromJson(Map<String, dynamic> json) =>
      UpdateprofileModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
