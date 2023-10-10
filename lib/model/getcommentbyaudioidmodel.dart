// To parse this JSON data, do
//
//     final getcommentbyaudioidModel = getcommentbyaudioidModelFromJson(jsonString);

import 'dart:convert';

GetcommentbyaudioidModel getcommentbyaudioidModelFromJson(String str) =>
    GetcommentbyaudioidModel.fromJson(json.decode(str));

String getcommentbyaudioidModelToJson(GetcommentbyaudioidModel data) =>
    json.encode(data.toJson());

class GetcommentbyaudioidModel {
  GetcommentbyaudioidModel({
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

  factory GetcommentbyaudioidModel.fromJson(Map<String, dynamic> json) =>
      GetcommentbyaudioidModel(
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
    this.userId,
    this.audioId,
    this.comment,
    this.status,
    this.date,
    this.createdAt,
    this.updatedAt,
    this.fullName,
    this.image,
    this.isRating,
  });

  int? id;
  int? userId;
  int? audioId;
  String? comment;
  int? status;
  String? date;
  String? createdAt;
  String? updatedAt;
  String? fullName;
  String? image;
  dynamic isRating;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        userId: json["user_id"],
        audioId: json["audio_id"],
        comment: json["comment"],
        status: json["status"],
        date: json["date"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        fullName: json["full_name"],
        image: json["image"],
        isRating: json["is_rating"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "audio_id": audioId,
        "comment": comment,
        "status": status,
        "date": date,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "full_name": fullName,
        "image": image,
        "is_rating": isRating,
      };
}
