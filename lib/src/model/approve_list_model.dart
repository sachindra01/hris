// To parse this JSON data, do
//
//     final approveListModel = approveListModelFromJson(jsonString);

import 'dart:convert';

ApproveListModel approveListModelFromJson(String str) => ApproveListModel.fromJson(json.decode(str));

String approveListModelToJson(ApproveListModel data) => json.encode(data.toJson());

class ApproveListModel {
    ApproveListModel({
        required this.success,
        required this.data,
        required this.code,
    });

    bool success;
    List<Datum> data;
    int code;

    factory ApproveListModel.fromJson(Map<String, dynamic> json) => ApproveListModel(
        success: json["success"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "code": code,
    };
}

class Datum {
    Datum({
        this.id,
        this.name,
        this.nameNp,
        this.leaveCategoryCode,
        this.leaveDayCode,
        this.leaveFromBs,
        this.leaveToBs,
        this.leaveFromAd,
        this.leaveToAd,
        this.noOfDays,
        this.remarks,
        this.leaveDayName,
        this.leaveCategoryName,
        this.status,
        this.approverList,
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

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        nameNp: json["name_np"],
        leaveCategoryCode: json["leave_category_code"],
        leaveDayCode: json["leave_day_code"],
        leaveFromBs: json["leave_from_bs"],
        leaveToBs: json["leave_to_bs"],
        leaveFromAd: json["leave_from_ad"] ?? "",
        leaveToAd: json["leave_to_ad"] ?? "",
        noOfDays: json["no_of_days"],
        remarks: json["remarks"],
        leaveDayName:json["leave_day_name"] ?? "",
        leaveCategoryName: json["leave_category_name"] ?? "",
        status: json["status"],
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
        "leave_from_ad": leaveFromAd,
        "leave_to_ad": leaveToAd,
        "no_of_days": noOfDays,
        "remarks": remarks,
        "leave_day_name": leaveDayName,
        "leave_category_name": leaveCategoryName,
        "status": status,
        "approve_list": List<dynamic>.from(approverList!.map((x) => x.toJson())),
    };
}

class ApproveList {
    ApproveList({
        this.id,
        this.status,
        this.approvedAt,
        this.approverId,
        this.approverRemarks,
        this.approverName,
    });

    int? id;
    String? status;
    dynamic approvedAt;
    int? approverId;
    String? approverRemarks;
    String? approverName;

    factory ApproveList.fromJson(Map<String, dynamic> json) => ApproveList(
        id: json["id"],
        status: json["status"],
        approvedAt: json["approved_at"],
        approverId: json["approver_id"],
        approverRemarks: json["approver_remarks"],
        approverName: json["approver_name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "approved_at": approvedAt,
        "approver_id": approverId,
        "approver_remarks": approverRemarks,
        "approver_name": approverName,
    };
}
