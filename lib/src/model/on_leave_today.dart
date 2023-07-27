// To parse this JSON data, do
//
//     final employeeOnLeaveModel = employeeOnLeaveModelFromJson(jsonString);

import 'dart:convert';

EmployeeOnLeaveModel employeeOnLeaveModelFromJson(String str) => EmployeeOnLeaveModel.fromJson(json.decode(str));

String employeeOnLeaveModelToJson(EmployeeOnLeaveModel data) => json.encode(data.toJson());

class EmployeeOnLeaveModel {
    bool? success;
    List<Datum>? data;
    int? code;

    EmployeeOnLeaveModel({
        this.success,
        this.data,
        this.code,
    });

    factory EmployeeOnLeaveModel.fromJson(Map<String, dynamic> json) => EmployeeOnLeaveModel(
        success: json["success"],
        data: json["data"] is List ? List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))) : [],
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "code": code,
    };
}

class Datum {
    int? id;
    int? empId;
    String? leaveCategory;
    String? leaveDayName;
    String? leaveReason;
    String? leaveFromAd;
    String? leaveToAd;
    String? fullName;
    String? fullNameNp;
    String? phoneNo;
    String? officialEmail;
    String? roleName;
    String? profileImage;

    Datum({
        this.id,
        this.empId,
        this.leaveCategory,
        this.leaveDayName,
        this.leaveReason,
        this.leaveFromAd,
        this.leaveToAd,
        this.fullName,
        this.fullNameNp,
        this.phoneNo,
        this.officialEmail,
        this.roleName,
        this.profileImage,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        empId: json["emp_id"],
        leaveCategory: json["leave_category"],
        leaveDayName: json["leave_day_name"],
        leaveReason: json["leave_reason"],
        leaveFromAd: json["leave_from_ad"],
        leaveToAd: json["leave_to_ad"],
        fullName: json["full_name"],
        fullNameNp: json["full_name_np"],
        phoneNo: json["phone_no"],
        officialEmail: json["official_email"],
        roleName: json["role_name"],
        profileImage: json["profile_image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "emp_id": empId,
        "leave_category": leaveCategory,
        "leave_day_name": leaveDayName,
        "leave_reason": leaveReason,
        "leave_from_ad": leaveFromAd,
        "leave_to_ad": leaveToAd,
        "full_name": fullName,
        "full_name_np": fullNameNp,
        "phone_no": phoneNo,
        "official_email": officialEmail,
        "role_name": roleName,
        "profile_image": profileImage,
    };
}