// To parse this JSON data, do
//
//     final topsearchModel = topsearchModelFromJson(jsonString);

import 'dart:convert';

TopsearchModel topsearchModelFromJson(String str) =>
    TopsearchModel.fromJson(json.decode(str));

String topsearchModelToJson(TopsearchModel data) => json.encode(data.toJson());

class TopsearchModel {
  int? status;
  String? message;
  List<Result>? result;
  int? totalRows;
  int? totalPage;
  String? currentPage;
  bool? morePage;

  TopsearchModel({
    this.status,
    this.message,
    this.result,
    this.totalRows,
    this.totalPage,
    this.currentPage,
    this.morePage,
  });

  factory TopsearchModel.fromJson(Map<String, dynamic> json) => TopsearchModel(
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
  int? count;
  int? status;
  String? createdAt;
  String? updatedAt;

  Result({
    this.id,
    this.title,
    this.count,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        title: json["title"],
        count: json["count"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "count": count,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
