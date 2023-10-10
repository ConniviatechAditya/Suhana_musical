// To parse this JSON data, do
//
//     final getepisodebyaudioidModel = getepisodebyaudioidModelFromJson(jsonString);

import 'dart:convert';

GetepisodebyaudioidModel getepisodebyaudioidModelFromJson(String str) =>
    GetepisodebyaudioidModel.fromJson(json.decode(str));

String getepisodebyaudioidModelToJson(GetepisodebyaudioidModel data) =>
    json.encode(data.toJson());

class GetepisodebyaudioidModel {
  GetepisodebyaudioidModel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<Result>? result;

  factory GetepisodebyaudioidModel.fromJson(Map<String, dynamic> json) =>
      GetepisodebyaudioidModel(
        status: json["status"],
        message: json["message"],
        result: json["result"] == null
            ? []
            : List<Result>.from(
                json["result"]?.map((x) => Result.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "result": result == null
            ? []
            : List<dynamic>.from(result?.map((x) => x.toJson()) ?? []),
      };
}

class Result {
  Result({
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
  String? createdAt;
  String? updatedAt;
  int? isDownload;
  int? stopTime;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
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
        "created_at": createdAt,
        "updated_at": updatedAt,
        "is_download": isDownload,
        "stop_time": stopTime,
      };
}
