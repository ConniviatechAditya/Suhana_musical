// To parse this JSON data, do
//
//     final readnotificationModel = readnotificationModelFromJson(jsonString);

import 'dart:convert';

ReadnotificationModel readnotificationModelFromJson(String str) =>
    ReadnotificationModel.fromJson(json.decode(str));

String readnotificationModelToJson(ReadnotificationModel data) =>
    json.encode(data.toJson());

class ReadnotificationModel {
  int? status;
  String? message;
  List<dynamic>? result;

  ReadnotificationModel({
    this.status,
    this.message,
    this.result,
  });

  factory ReadnotificationModel.fromJson(Map<String, dynamic> json) =>
      ReadnotificationModel(
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
