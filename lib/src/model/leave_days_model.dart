// To parse this JSON data, do
//
//     final leaveDays = leaveDaysFromJson(jsonString);

import 'dart:convert';

LeaveDays leaveDaysFromJson(String str) => LeaveDays.fromJson(json.decode(str));

String leaveDaysToJson(LeaveDays data) => json.encode(data.toJson());

class LeaveDays {
    LeaveDays({
        required this.success,
        required this.data,
        required this.code,
    });

    bool success;
    List<Datum> data;
    int code;

    factory LeaveDays.fromJson(Map<String, dynamic> json) => LeaveDays(
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
        required this.id,
        required this.code,
        required this.name,
        this.nameNp,
        required this.noOfDays,
        this.description,
        required this.isFullDay,
        this.displayOrder,
        required this.noOfDaysDisplay,
    });

    int id;
    String code;
    String name;
    String? nameNp;
    String noOfDays;
    String? description;
    int isFullDay;
    int? displayOrder;
    double noOfDaysDisplay;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        nameNp: json["name_np"],
        noOfDays: json["no_of_days"],
        description: json["description"],
        isFullDay: json["is_full_day"],
        displayOrder: json["display_order"],
        noOfDaysDisplay: json["no_of_days_display"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "name_np": nameNp,
        "no_of_days": noOfDays,
        "description": description,
        "is_full_day": isFullDay,
        "display_order": displayOrder,
        "no_of_days_display": noOfDaysDisplay,
    };
}
