// To parse this JSON data, do
//
//     final addaudioplaymodel = addaudioplaymodelFromJson(jsonString);

import 'dart:convert';

Addaudioplaymodel addaudioplaymodelFromJson(String str) =>
    Addaudioplaymodel.fromJson(json.decode(str));

String addaudioplaymodelToJson(Addaudioplaymodel data) =>
    json.encode(data.toJson());

class Addaudioplaymodel {
  Addaudioplaymodel({
    this.status,
    this.message,
  });

  int? status;
  String? message;

  factory Addaudioplaymodel.fromJson(Map<String, dynamic> json) =>
      Addaudioplaymodel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
