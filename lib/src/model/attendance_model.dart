// To parse this JSON data, do
//
//     final attendanceModel = attendanceModelFromJson(jsonString);

import 'dart:convert';

AttendanceModel attendanceModelFromJson(String str) => AttendanceModel.fromJson(json.decode(str));

String attendanceModelToJson(AttendanceModel data) => json.encode(data.toJson());

class AttendanceModel {
    bool? success;
    List<Datum>? data;
    int? code;

    AttendanceModel({
        this.success,
        this.data,
        this.code,
    });

    factory AttendanceModel.fromJson(Map<String, dynamic> json) => AttendanceModel(
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
    int? id;
    int? empId;
    bool? isLate;
    bool? absent;
    List<Breaktime>? breaktime;
    String? checkinTime;
    String? checkoutTime;
    String? checkinDateAd;
    String? checkoutDateAd;
    String? checkinDateBs;
    String? checkoutDateBs;
    String? employeeRemarks;
    String? adminRemarks;
    String? lateReason;
    String? leaveReason;
    String? attendanceTime;

    Datum({
        this.id,
        this.empId,
        this.isLate,
        this.absent,
        this.breaktime,
        this.checkinTime,
        this.checkoutTime,
        this.checkinDateAd,
        this.checkoutDateAd,
        this.checkinDateBs,
        this.checkoutDateBs,
        this.employeeRemarks,
        this.adminRemarks,
        this.lateReason,
        this.leaveReason,
        this.attendanceTime
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        isLate: json["is_late"],
        empId: json["emp_id"],
        absent: json["absent"],
        breaktime: json["breaktime"] == null ? null : List<Breaktime>.from(json["breaktime"].map((x) => Breaktime.fromJson(x))),
        checkinTime: json["checkin_time"],
        checkoutTime: json["checkout_time"],
        checkinDateAd: json["checkin_date_ad"],
        checkoutDateAd: json["checkout_date_ad"],
        checkinDateBs: json["checkin_date_bs"],
        checkoutDateBs: json["checkout_date_bs"],
        employeeRemarks: json["employee_remarks"] ?? '',
        adminRemarks: json["admin_remarks"] ?? '',
        lateReason: json["late_reason"] ?? '',
        leaveReason: json["leave_reason"] ?? '',
        attendanceTime: json['attendance_time']
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "emp_id": empId,
        "absent": absent,
        "is_late": isLate,
        "breaktime": List<dynamic>.from(breaktime!.map((x) => x.toJson())),
        "checkin_time": checkinTime,
        "checkout_time": checkoutTime,
        "checkin_date_ad": checkinDateAd,
        "checkout_date_ad": checkoutDateAd,
        "checkin_date_bs": checkinDateBs,
        "checkout_date_bs": checkoutDateBs,
        "employee_remarks": employeeRemarks,
        "admin_remarks": adminRemarks,
        "late_reason": lateReason,
        "leave_reason": leaveReason,
        "attendance_time": attendanceTime
    };
}

class Breaktime {
    String? breakIn;
    String? breakOut;

    Breaktime({
        this.breakIn,
        this.breakOut,
    });

    factory Breaktime.fromJson(Map<String, dynamic> json) => Breaktime(
        breakIn: json["break_in"],
        breakOut: json["break_out"],
    );

    Map<String, dynamic> toJson() => {
        "break_in": breakIn,
        "break_out": breakOut,
    };
}
