// To parse this JSON data, do
//
//     final detailModel = detailModelFromJson(jsonString);

import 'dart:convert';

DetailModel detailModelFromJson(String str) =>
    DetailModel.fromJson(json.decode(str));

String detailModelToJson(DetailModel data) => json.encode(data.toJson());

class DetailModel {
  DetailModel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<Result>? result;

  factory DetailModel.fromJson(Map<String, dynamic> json) => DetailModel(
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
    this.categoryId,
    this.languageId,
    this.castId,
    this.title,
    this.image,
    this.type,
    this.description,
    this.isPremium,
    this.ageRestriction,
    this.status,
    this.date,
    this.createdAt,
    this.updatedAt,
    this.categoryName,
    this.languageName,
    this.played,
    this.rating,
    this.isRating,
    this.isBookmark,
    this.isBuy,
    this.totalEpisode,
    this.totalReviews,
    this.totalTime,
  });

  int? id;
  int? categoryId;
  int? languageId;
  String? castId;
  String? title;
  String? image;
  int? type;
  String? description;
  String? isPremium;
  String? ageRestriction;
  int? status;
  String? date;
  String? createdAt;
  String? updatedAt;
  String? categoryName;
  String? languageName;
  int? played;
  dynamic rating;
  double? isRating;
  int? isBookmark;
  int? isBuy;
  int? totalEpisode;
  int? totalReviews;
  int? totalTime;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        categoryId: json["category_id"],
        languageId: json["language_id"],
        castId: json["cast_id"],
        title: json["title"],
        image: json["image"],
        type: json["type"],
        description: json["description"],
        isPremium: json["is_premium"],
        ageRestriction: json["age_restriction"],
        status: json["status"],
        date: json["date"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        categoryName: json["category_name"],
        languageName: json["language_name"],
        played: json["played"],
        rating: json["rating"],
        isRating: json["is_rating"].toDouble(),
        isBookmark: json["is_bookmark"],
        isBuy: json["is_buy"],
        totalEpisode: json["total_episode"],
        totalReviews: json["total_reviews"],
        totalTime: json["total_time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "language_id": languageId,
        "cast_id": castId,
        "title": title,
        "image": image,
        "type": type,
        "description": description,
        "is_premium": isPremium,
        "age_restriction": ageRestriction,
        "status": status,
        "date": date,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "category_name": categoryName,
        "language_name": languageName,
        "played": played,
        "rating": rating,
        "is_rating": isRating,
        "is_bookmark": isBookmark,
        "is_buy": isBuy,
        "total_episode": totalEpisode,
        "total_reviews": totalReviews,
        "total_time": totalTime,
      };
}
