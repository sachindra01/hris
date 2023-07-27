// To parse this JSON data, do
//
//     final nepalProvinceModel = nepalProvinceModelFromJson(jsonString);

import 'dart:convert';

NepalProvinceModel nepalProvinceModelFromJson(String str) => NepalProvinceModel.fromJson(json.decode(str));

String nepalProvinceModelToJson(NepalProvinceModel data) => json.encode(data.toJson());

class NepalProvinceModel {
    NepalProvinceModel({
        this.status,
        this.success,
        this.message,
        this.data,
    });

    String? status;
    bool? success;
    String? message;
    Data? data;

    factory NepalProvinceModel.fromJson(Map<String, dynamic> json) => NepalProvinceModel(
        status: json["status"],
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "success": success,
        "message": message,
        "data": data!.toJson(),
    };
}

class Data {
    Data({
        this.data,
        this.links,
        this.meta,
    });

    List<Datum>? data;
    Links? links;
    Meta? meta;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        links: Links.fromJson(json["links"]),
        meta: Meta.fromJson(json["meta"]),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "links": links!.toJson(),
        "meta": meta!.toJson(),
    };
}

class Datum {
    Datum({
        this.provinceId,
        this.name,
        this.altName,
        this.longitude,
        this.latitude,
        this.area,
        this.population,
    });

    int? provinceId;
    String? name;
    String? altName;
    String? longitude;
    String? latitude;
    String? area;
    String? population;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        provinceId: json["province_id"],
        name: json["name"],
        altName: json["alt_name"],
        longitude: json["longitude"],
        latitude: json["latitude"],
        area: json["area"],
        population: json["population"],
    );

    Map<String, dynamic> toJson() => {
        "province_id": provinceId,
        "name": name,
        "alt_name": altName,
        "longitude": longitude,
        "latitude": latitude,
        "area": area,
        "population": population,
    };
}

class Links {
    Links({
        this.first,
        this.last,
        this.prev,
        this.next,
    });

    String? first;
    String? last;
    dynamic prev;
    dynamic next;

    factory Links.fromJson(Map<String, dynamic> json) => Links(
        first: json["first"],
        last: json["last"],
        prev: json["prev"],
        next: json["next"],
    );

    Map<String, dynamic> toJson() => {
        "first": first,
        "last": last,
        "prev": prev,
        "next": next,
    };
}

class Meta {
    Meta({
        this.currentPage,
        this.from,
        this.lastPage,
        this.links,
        this.path,
        this.perPage,
        this.to,
        this.total,
    });

    int? currentPage;
    int? from;
    int? lastPage;
    List<Link>? links;
    String? path;
    int? perPage;
    int? to;
    int? total;

    factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"],
        from: json["from"],
        lastPage: json["last_page"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "links": List<dynamic>.from(links!.map((x) => x.toJson())),
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
    };
}

class Link {
    Link({
        this.url,
        this.label,
        this.active,
    });

    String? url;
    String? label;
    bool? active;

    factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
    );

    Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
    };
}