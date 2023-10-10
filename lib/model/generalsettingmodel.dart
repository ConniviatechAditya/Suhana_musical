// To parse this JSON data, do
//
//     final generalsettingModel = generalsettingModelFromJson(jsonString);

import 'dart:convert';

GeneralsettingModel generalsettingModelFromJson(String str) =>
    GeneralsettingModel.fromJson(json.decode(str));

String generalsettingModelToJson(GeneralsettingModel data) =>
    json.encode(data.toJson());

class GeneralsettingModel {
  GeneralsettingModel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<Result>? result;

  factory GeneralsettingModel.fromJson(Map<String, dynamic> json) =>
      GeneralsettingModel(
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
    this.key,
    this.value,
  });

  int? id;
  String? key;
  String? value;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        key: json["key"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "key": key,
        "value": value,
      };
}
