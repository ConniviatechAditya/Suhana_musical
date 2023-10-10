// To parse this JSON data, do
//
//     final getpagesModel = getpagesModelFromJson(jsonString);

import 'dart:convert';

GetpagesModel getpagesModelFromJson(String str) =>
    GetpagesModel.fromJson(json.decode(str));

String getpagesModelToJson(GetpagesModel data) => json.encode(data.toJson());

class GetpagesModel {
  int? status;
  String? message;
  List<Result>? result;

  GetpagesModel({
    this.status,
    this.message,
    this.result,
  });

  factory GetpagesModel.fromJson(Map<String, dynamic> json) => GetpagesModel(
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
  String? pageName;
  String? url;

  Result({
    this.pageName,
    this.url,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        pageName: json["page_name"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "page_name": pageName,
        "url": url,
      };
}
