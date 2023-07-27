import 'dart:convert';

OptionItemModel optionItemModelFromJson(String? str) => OptionItemModel.fromJson(json.decode(str!));

String? optionItemModelToJson(OptionItemModel data) => json.encode(data.toJson());

class OptionItemModel {
    bool? success;
    OptionItemData? data;
    int? code;

    OptionItemModel({
        this.success,
        this.data,
        this.code,
    });

    factory OptionItemModel.fromJson(Map<String?, dynamic> json) => OptionItemModel(
        success: json["success"],
        data: OptionItemData.fromJson(json["data"]),
        code: json["code"],
    );

    Map<String?, dynamic> toJson() => {
        "success": success,
        "data": data!.toJson(),
        "code": code,
    };
}

class OptionItemData {
    List<OptionData>? maritalStatus;
    List<OptionData>? personalVehicle;
    List<OptionData>? drivingLicense;
    List<OptionData>? nationality;
    List<OptionData>? religion;
    List<OptionData>? gender;

    OptionItemData({
        this.maritalStatus,
        this.personalVehicle,
        this.drivingLicense,
        this.nationality,
        this.religion,
        this.gender,
    });

    factory OptionItemData.fromJson(Map<String?, dynamic> json) => OptionItemData(
      maritalStatus: List<OptionData>.from(json["marital_status"].map((x) => OptionData.fromJson(x))),
      personalVehicle: List<OptionData>.from(json["personal_vehicle"].map((x) => OptionData.fromJson(x))),
      drivingLicense: List<OptionData>.from(json["driving_license"].map((x) => OptionData.fromJson(x))),
      nationality: List<OptionData>.from(json["nationality"].map((x) => OptionData.fromJson(x))),
      religion: List<OptionData>.from(json["religion"].map((x) => OptionData.fromJson(x))),
      gender: List<OptionData>.from(json["gender"].map((x) => OptionData.fromJson(x))),
    );

    Map<String?, dynamic> toJson() => {
      "marital_status": List<dynamic>.from(maritalStatus!.map((x) => x.toJson())),
      "personal_vehicle": List<dynamic>.from(personalVehicle!.map((x) => x.toJson())),
      "driving_license": List<dynamic>.from(drivingLicense!.map((x) => x.toJson())),
      "nationality": List<dynamic>.from(nationality!.map((x) => x.toJson())),
      "religion": List<dynamic>.from(religion!.map((x) => x.toJson())),
      "gender" : List<dynamic>.from(gender!.map((x) => x.toJson())),
    };
}

class OptionData {
    int? id;
    String? code;
    String? name;
    String? nameNp;

    OptionData({
        this.id,
        this.code,
        this.name,
        this.nameNp,
    });

    factory OptionData.fromJson(Map<String?, dynamic> json) => OptionData(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        nameNp: json["name_np"],
    );

    Map<String?, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "name_np": nameNp,
    };
}
