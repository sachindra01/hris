// To parse this JSON data, do
//
//     final attendanceTodayModel = attendanceTodayModelFromJson(jsonString);

import 'dart:convert';

AttendanceTodayModel attendanceTodayModelFromJson(String str) => AttendanceTodayModel.fromJson(json.decode(str));

String attendanceTodayModelToJson(AttendanceTodayModel data) => json.encode(data.toJson());

class AttendanceTodayModel {
    bool? success;
    Data? data;
    int? code;

    AttendanceTodayModel({
        this.success,
        this.data,
        this.code,
    });

    factory AttendanceTodayModel.fromJson(Map<String, dynamic> json) => AttendanceTodayModel(
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
    int? totalemployees;
    int? attendancePresent;
    int? attendanceAbsent;
    int? lateComers;

    Data({
        this.totalemployees,
        this.attendancePresent,
        this.attendanceAbsent,
        this.lateComers,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalemployees: json["totalemployees"] ?? 0,
        attendancePresent: json["attendancePresent"] ?? 0,
        attendanceAbsent: json["attendanceAbsent"] ?? 0,
        lateComers: json["lateComers"] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        "totalemployees": totalemployees,
        "attendancePresent": attendancePresent,
        "attendanceAbsent": attendanceAbsent,
        "lateComers": lateComers,
    };
}
