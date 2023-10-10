// To parse this JSON data, do
//
//     final getnotificationModel = getnotificationModelFromJson(jsonString);

import 'dart:convert';

GetnotificationModel getnotificationModelFromJson(String str) =>
    GetnotificationModel.fromJson(json.decode(str));

String getnotificationModelToJson(GetnotificationModel data) =>
    json.encode(data.toJson());

class GetnotificationModel {
  int? status;
  String? message;
  List<Result>? result;
  int? totalRows;
  int? totalPage;
  String? currentPage;
  bool? morePage;

  GetnotificationModel({
    this.status,
    this.message,
    this.result,
    this.totalRows,
    this.totalPage,
    this.currentPage,
    this.morePage,
  });

  factory GetnotificationModel.fromJson(Map<String, dynamic> json) =>
      GetnotificationModel(
        status: json["status"],
        message: json["message"],
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
        totalRows: json["total_rows"],
        totalPage: json["total_page"],
        currentPage: json["current_page"],
        morePage: json["more_page"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": List<dynamic>.from(result!.map((x) => x.toJson())),
        "total_rows": totalRows,
        "total_page": totalPage,
        "current_page": currentPage,
        "more_page": morePage,
      };
}

class Result {
  int? id;
  String? title;
  String? message;
  String? image;
  String? createdAt;
  String? updatedAt;

  Result({
    this.id,
    this.title,
    this.message,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        title: json["title"],
        message: json["message"],
        image: json["image"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "message": message,
        "image": image,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
