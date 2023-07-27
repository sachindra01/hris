// To parse this JSON data, do
//
//     final leaveListModel = leaveListModelFromJson(jsonString);

import 'dart:convert';

LeaveListModel leaveListModelFromJson(String str) => LeaveListModel.fromJson(json.decode(str));

String leaveListModelToJson(LeaveListModel data) => json.encode(data.toJson());

class LeaveListModel {
    LeaveListModel({
        this.success,
        this.data,
        this.code,
    });

    bool? success;
    List<Datum>? data;
    int? code;

    factory LeaveListModel.fromJson(Map<String, dynamic> json) => LeaveListModel(
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
        this.leaveCategoryCode,
        this.leaveDayCode,
        this.leaveFromBs,
        this.leaveToBs,
        this.noOfDays,
        this.remarks,
        this.leaveDayName,
        this.leaveCategoryName,
        this.status,
        this.approverList,
        this.name,
        this.nameNp,
        this.leaveFromAd,
        this.leaveToAd,
        this.appliedDate
    });

    int? id;
    String? name;
    String? nameNp;
    String? leaveCategoryCode;
    String? leaveDayCode;
    String? leaveFromBs;
    String? leaveToBs;
    String? leaveFromAd;
    String? leaveToAd;
    String? noOfDays;
    String? remarks;
    String? leaveDayName;
    String? leaveCategoryName;
    String? status;
    List<ApproveList>? approverList;
    String? appliedDate;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        nameNp: json["name_np"],
        leaveCategoryCode: json["leave_category_code"],
        leaveDayCode: json["leave_day_code"] ?? "",
        leaveFromBs: json["leave_from_bs"] ?? "",
        leaveToBs: json["leave_to_bs"] ?? "",
        leaveFromAd: json["leave_from_ad"] ?? "",
        leaveToAd: json["leave_to_ad"] ?? "",
        noOfDays: json["no_of_days"],
        remarks: json["remarks"],
        leaveDayName: json["leave_day_name"],
        leaveCategoryName: json["leave_category_name"],
        status: json["status"],
        appliedDate: json["applied_date"],
        approverList: List<ApproveList>.from(json["approve_list"].map((x) => ApproveList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "name_np": nameNp,
        "leave_category_code": leaveCategoryCode,
        "leave_day_code": leaveDayCode,
        "leave_from_bs": leaveFromBs,
        "leave_to_bs": leaveToBs,
        "no_of_days": noOfDays,
        "remarks": remarks,
        "leave_day_name": leaveDayName,
        "leave_category_name": leaveCategoryName,
        "leave_from_ad": leaveFromAd,
        "leave_to_ad": leaveToAd,
        "status": status,
        "applied_date": appliedDate,
        "approve_list": List<dynamic>.from(approverList!.map((x) => x.toJson())),
    };
}

class ApproveList {
  ApproveList({
      required this.id,
      required this.status,
      this.approvedAt,
      required this.approverId,
      this.approverRemarks,
      this.role,
      this.approverImage,
      required this.approverName,
  });

  int id;
  String status;
  dynamic approvedAt;
  int approverId;
  String? approverRemarks;
  String approverName;
  String? role;
  String? approverImage;

  factory ApproveList.fromJson(Map<String, dynamic> json) => ApproveList(
      id: json["id"],
      status: json["status"]!,
      approvedAt: json["approved_at"],
      approverId: json["approver_id"],
      approverRemarks: json["approver_remarks"],
      approverName: json["approver_name"]!,
      role : json["role_name"],
      approverImage : json["profile_image_url"],
  );

  Map<String, dynamic> toJson() => {
      "id": id,
      "status":status,
      "approved_at": approvedAt,
      "approver_id": approverId,
      "approver_remarks": approverRemarks,
      "approver_name": approverName,
      "role_name": role,
      "profile_image_url": approverImage,
  };
}