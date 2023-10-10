// To parse this JSON data, do
//
//     final downloadlistModel = downloadlistModelFromJson(jsonString);

import 'dart:convert';

DownloadlistModel downloadlistModelFromJson(String str) =>
    DownloadlistModel.fromJson(json.decode(str));

String downloadlistModelToJson(DownloadlistModel data) =>
    json.encode(data.toJson());

class DownloadlistModel {
  DownloadlistModel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<Result>? result;

  factory DownloadlistModel.fromJson(Map<String, dynamic> json) =>
      DownloadlistModel(
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
    this.played,
    this.rating,
    this.isRating,
    this.isBuy,
    this.totalEpisode,
    this.totalReviews,
    this.episode,
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
  int? played;
  int? rating;
  int? isRating;
  int? isBuy;
  int? totalEpisode;
  int? totalReviews;
  List<dynamic>? episode;

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
        played: json["played"],
        rating: json["rating"],
        isRating: json["is_rating"],
        isBuy: json["is_buy"],
        totalEpisode: json["total_episode"],
        totalReviews: json["total_reviews"],
        episode: List<dynamic>.from(json["episode"].map((x) => x)),
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
        "played": played,
        "rating": rating,
        "is_rating": isRating,
        "is_buy": isBuy,
        "total_episode": totalEpisode,
        "total_reviews": totalReviews,
        "episode": List<dynamic>.from(episode!.map((x) => x)),
      };
}
