// To parse this JSON data, do
//
//     final addreviewModel = addreviewModelFromJson(jsonString);

import 'dart:convert';

AddreviewModel addreviewModelFromJson(String str) =>
    AddreviewModel.fromJson(json.decode(str));

String addreviewModelToJson(AddreviewModel data) => json.encode(data.toJson());

class AddreviewModel {
  AddreviewModel({
    this.status,
    this.message,
  });

  int? status;
  String? message;

  factory AddreviewModel.fromJson(Map<String, dynamic> json) => AddreviewModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
