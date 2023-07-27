// To parse this JSON data, do
//
//     final stateListModel = stateListModelFromJson(jsonString);

import 'dart:convert';

StateListModel stateListModelFromJson(String str) => StateListModel.fromJson(json.decode(str));

String stateListModelToJson(StateListModel data) => json.encode(data.toJson());

class StateListModel {
    bool? success;
    List<Datum>? data;
    int? code;

    StateListModel({
        this.success,
        this.data,
        this.code,
    });

    factory StateListModel.fromJson(Map<String, dynamic> json) => StateListModel(
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
    String? stateName;
    int? stateCode;
    List<District>? districts;

    Datum({
        this.stateName,
        this.stateCode,
        this.districts,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        stateName: json["state_name"],
        stateCode: json["state_code"],
        districts: List<District>.from(json["districts"].map((x) => District.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "state_name": stateName,
        "state_code": stateCode,
        "districts": List<dynamic>.from(districts!.map((x) => x.toJson())),
    };
}

class District {
    int? districtCode;
    int? stateCode;
    String? districtName;

    District({
        this.districtCode,
        this.stateCode,
        this.districtName,
    });

    factory District.fromJson(Map<String, dynamic> json) => District(
        districtCode: json["district_code"],
        stateCode: json["state_code"],
        districtName: json["district_name"],
    );

    Map<String, dynamic> toJson() => {
        "district_code": districtCode,
        "state_code": stateCode,
        "district_name": districtName,
    };
}
