// To parse this JSON data, do
//
//     final getcastbyaudioidModel = getcastbyaudioidModelFromJson(jsonString);

import 'dart:convert';

GetcastbyaudioidModel getcastbyaudioidModelFromJson(String str) =>
    GetcastbyaudioidModel.fromJson(json.decode(str));

String getcastbyaudioidModelToJson(GetcastbyaudioidModel data) =>
    json.encode(data.toJson());

class GetcastbyaudioidModel {
  GetcastbyaudioidModel({
    this.status,
    this.message,
    this.result,
    this.totalRows,
    this.totalPage,
    this.currentPage,
    this.morePage,
  });

  int? status;
  String? message;
  List<Result>? result;
  int? totalRows;
  int? totalPage;
  String? currentPage;
  bool? morePage;

  factory GetcastbyaudioidModel.fromJson(Map<String, dynamic> json) =>
      GetcastbyaudioidModel(
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
  Result({
    this.id,
    this.name,
    this.image,
    this.type,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? image;
  int? type;
  int? status;
  String? createdAt;
  String? updatedAt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        type: json["type"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "type": type,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
