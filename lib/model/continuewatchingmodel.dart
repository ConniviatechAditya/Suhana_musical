// To parse this JSON data, do
//
//     final continuewatchingModel = continuewatchingModelFromJson(jsonString);

import 'dart:convert';

ContinuewatchingModel continuewatchingModelFromJson(String str) =>
    ContinuewatchingModel.fromJson(json.decode(str));

String continuewatchingModelToJson(ContinuewatchingModel data) =>
    json.encode(data.toJson());

class ContinuewatchingModel {
  ContinuewatchingModel({
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

  factory ContinuewatchingModel.fromJson(Map<String, dynamic> json) =>
      ContinuewatchingModel(
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
    this.stopTime,
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
  dynamic rating;
  double? isRating;
  int? isBuy;
  int? totalEpisode;
  int? totalReviews;
  int? stopTime;
  Episode? episode;

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
        isRating: json["is_rating"]?.toDouble(),
        isBuy: json["is_buy"],
        totalEpisode: json["total_episode"],
        totalReviews: json["total_reviews"],
        stopTime: json["stop_time"],
        episode: Episode.fromJson(json["episode"]),
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
        "stop_time": stopTime,
        "episode": episode!.toJson(),
      };
}

class Episode {
  Episode({
    this.id,
    this.audioId,
    this.name,
    this.image,
    this.type,
    this.audio,
    this.audioDuration,
    this.description,
    this.isPremium,
    this.played,
    this.status,
    this.date,
    this.createdAt,
    this.updatedAt,
    this.isDownload,
    this.stopTime,
  });

  int? id;
  int? audioId;
  String? name;
  String? image;
  int? type;
  String? audio;
  int? audioDuration;
  String? description;
  String? isPremium;
  int? played;
  int? status;
  String? date;
  String? createdAt;
  String? updatedAt;
  int? isDownload;
  int? stopTime;

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
        id: json["id"],
        audioId: json["audio_id"],
        name: json["name"],
        image: json["image"],
        type: json["type"],
        audio: json["audio"],
        audioDuration: json["audio_duration"],
        description: json["description"],
        isPremium: json["is_premium"],
        played: json["played"],
        status: json["status"],
        date: json["date"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        isDownload: json["is_download"],
        stopTime: json["stop_time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "audio_id": audioId,
        "name": name,
        "image": image,
        "type": type,
        "audio": audio,
        "audio_duration": audioDuration,
        "description": description,
        "is_premium": isPremium,
        "played": played,
        "status": status,
        "date": date,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "is_download": isDownload,
        "stop_time": stopTime,
      };
}
