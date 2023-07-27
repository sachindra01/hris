// To parse this JSON data, do
//
//     final logInModel = logInModelFromJson(jsonString);

import 'dart:convert';

LogInModel logInModelFromJson(String str) => LogInModel.fromJson(json.decode(str));

String logInModelToJson(LogInModel data) => json.encode(data.toJson());

class LogInModel {
    LogInModel({
        this.success,
        this.data,
        this.code,
    });

    bool? success;
    Data? data;
    int? code;

    factory LogInModel.fromJson(Map<String, dynamic> json) => LogInModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data!.toJson(),
        "code": code,
    };
}

class Data {
    Data({
        this.id,
        this.fullName,
        this.fullNameNp,
        this.departmentName,
        this.departmentNameNp,
        this.roleName,
        this.officialEmail,
        this.startTime,
        this.endTime,
        this.workingHours,
        this.token,
        this.profileImageUrl,
        this.notification,
    });

    int? id;
    String? fullName;
    String? fullNameNp;
    String? departmentName;
    String? departmentNameNp;
    String? roleName;
    String? officialEmail;
    String? startTime;
    String? endTime;
    String? workingHours;
    String? token;
    String? profileImageUrl;
    bool? notification;


    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        fullName: json["full_name"],
        fullNameNp: json["full_name_np"],
        departmentName: json["department_name"],
        departmentNameNp: json["department_name_np"],
        roleName: json["role_name"],
        officialEmail: json["official_email"],
        startTime: json["start_time"] ?? "10:00",
        endTime: json["end_time"] ?? "19:00",
        workingHours: json["working_hours"] ?? "9",
        token: json["token"],
        notification: json["notification"],
        profileImageUrl: json["profile_image_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "full_name_np": fullNameNp,
        "department_name": departmentName,
        "department_name_np": departmentNameNp,
        "role_name": roleName,
        "official_email": officialEmail,
        "start_time": startTime,
        "end_time": endTime,
        "working_hours": workingHours,
        "token": token,
        "notification": notification,
        "profile_image_url" : profileImageUrl,
    };
}