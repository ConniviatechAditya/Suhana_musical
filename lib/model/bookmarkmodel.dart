// To parse this JSON data, do
//
//     final bookmarkModel = bookmarkModelFromJson(jsonString);

import 'dart:convert';

BookmarkModel bookmarkModelFromJson(String str) =>
    BookmarkModel.fromJson(json.decode(str));

String bookmarkModelToJson(BookmarkModel data) => json.encode(data.toJson());

class BookmarkModel {
  BookmarkModel({
    this.status,
    this.message,
  });

  int? status;
  String? message;

  factory BookmarkModel.fromJson(Map<String, dynamic> json) => BookmarkModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
