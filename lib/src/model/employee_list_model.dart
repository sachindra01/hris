// To parse this JSON data, do
//
//     final employeeListModel = employeeListModelFromJson(jsonString);

import 'dart:convert';

EmployeeListModel employeeListModelFromJson(String str) => EmployeeListModel.fromJson(json.decode(str));

String employeeListModelToJson(EmployeeListModel data) => json.encode(data.toJson());

class EmployeeListModel {
    EmployeeListModel({
        this.success,
        this.data,
        this.code,
    });

    bool? success;
    List<Datum>? data;
    int? code;

    factory EmployeeListModel.fromJson(Map<String, dynamic> json) => EmployeeListModel(
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
    Datum({
        this.id,
        this.officialEmail,
        this.gender,
        this.phoneNo,
        this.birthdayBs,
        this.joinDateBs,
        this.leftDateBs,
        this.reportsTo,
        this.roleName,
        this.fullName,
        this.fullNameNp,
        this.profileImageUrl,
    });

    int? id;
    String? officialEmail;
    String? gender;
    String? phoneNo;
    String? birthdayBs;
    String? joinDateBs;
    String? leftDateBs;
    String? reportsTo;
    String? roleName;
    String? fullName;
    String? fullNameNp;
    String? profileImageUrl;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        officialEmail: json["official_email"],
        gender: json["gender"],
        phoneNo: json["phone_no"],
        birthdayBs: json["birthday_bs"],
        joinDateBs: json["join_date_bs"],
        leftDateBs: json["left_date_bs"],
        reportsTo: json["reports_to"],
        roleName: json["role_name"] ?? "",
        fullName: json["full_name"],
        fullNameNp: json["full_name_np"],
        profileImageUrl: json["profile_image_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "official_email": officialEmail,
        "gender": gender,
        "phone_no": phoneNo,
        "birthday_bs": birthdayBs,
        "join_date_bs": joinDateBs,
        "left_date_bs": leftDateBs,
        "reports_to": reportsTo,
        "role_name": roleName,
        "full_name": fullName,
        "full_name_np": fullNameNp,
        "profile_image_url": profileImageUrl,
    };
}