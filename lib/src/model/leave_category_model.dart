// To parse this JSON data, do
//
//     final leaveCategoryModel = leaveCategoryModelFromJson(jsonString);

import 'dart:convert';

LeaveCategoryModel leaveCategoryModelFromJson(String str) => LeaveCategoryModel.fromJson(json.decode(str));

String leaveCategoryModelToJson(LeaveCategoryModel data) => json.encode(data.toJson());

class LeaveCategoryModel {
    bool? success;
    List<Datum>? data;
    int? code;

    LeaveCategoryModel({
        this.success,
        this.data,
        this.code,
    });

    factory LeaveCategoryModel.fromJson(Map<String, dynamic> json) => LeaveCategoryModel(
        success: json["success"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "code": code,
    };
}

class Datum {
    String? code;
    String? name;
    String? nameNp;
    dynamic noOfDays;
    dynamic assignedDays;
    dynamic remainingDays;
    String? usedDays;

    Datum({
        this.code,
        this.name,
        this.nameNp,
        this.noOfDays,
        this.assignedDays,
        this.remainingDays,
        this.usedDays,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        code: json["code"],
        name: json["name"],
        nameNp: json["name_np"],
        noOfDays: json["no_of_days"],
        assignedDays: json["assigned_days"],
        remainingDays: json["remaining_days"],
        usedDays: json["used_days"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "name_np": nameNp,
        "no_of_days": noOfDays,
        "assigned_days": assignedDays,
        "remaining_days": remainingDays,
        "used_days": usedDays,
    };
}