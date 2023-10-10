// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    this.status,
    this.message,
    this.result,
  });

  int? status;
  String? message;
  List<Result>? result;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
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
    this.userName,
    this.fullName,
    this.email,
    this.mobileNumber,
    this.dateOfBirth,
    this.gender,
    this.image,
    this.type,
    this.bio,
    this.deviceToken,
    this.status,
    this.date,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? userName;
  String? fullName;
  String? email;
  String? mobileNumber;
  String? dateOfBirth;
  int? gender;
  String? image;
  int? type;
  String? bio;
  String? deviceToken;
  int? status;
  String? date;
  String? createdAt;
  String? updatedAt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        userName: json["user_name"],
        fullName: json["full_name"],
        email: json["email"],
        mobileNumber: json["mobile_number"],
        dateOfBirth: json["date_of_birth"],
        gender: json["gender"],
        image: json["image"],
        type: json["type"],
        bio: json["bio"],
        deviceToken: json["device_token"],
        status: json["status"],
        date: json["date"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_name": userName,
        "full_name": fullName,
        "email": email,
        "mobile_number": mobileNumber,
        "date_of_birth": dateOfBirth,
        "gender": gender,
        "image": image,
        "type": type,
        "bio": bio,
        "device_token": deviceToken,
        "status": status,
        "date": date,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
