// To parse this JSON data, do
//
//     final addcontinuewatchingModel = addcontinuewatchingModelFromJson(jsonString);

import 'dart:convert';

AddcontinuewatchingModel addcontinuewatchingModelFromJson(String str) =>
    AddcontinuewatchingModel.fromJson(json.decode(str));

String addcontinuewatchingModelToJson(AddcontinuewatchingModel data) =>
    json.encode(data.toJson());

class AddcontinuewatchingModel {
  int? status;
  String? message;
  List<dynamic>? result;

  AddcontinuewatchingModel({
    this.status,
    this.message,
    this.result,
  });

  factory AddcontinuewatchingModel.fromJson(Map<String, dynamic> json) =>
      AddcontinuewatchingModel(
        status: json["status"],
        message: json["message"],
        result: json["result"] == null
            ? []
            : List<dynamic>.from(json["result"]?.map((x) => x) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result == null
            ? []
            : List<dynamic>.from(result?.map((x) => x) ?? []),
      };
}
