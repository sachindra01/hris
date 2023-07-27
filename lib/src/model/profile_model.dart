// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString?);

import 'dart:convert';

ProfileModel profileModelFromJson(String? str) => ProfileModel.fromJson(json.decode(str!));

String? profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
    bool? success;
    Data? data;
    List<Device>? device;
    dynamic projectInfo;
    ReportsTo? reportsTo;
    int? code;

    ProfileModel({
      this.success,
      this.data,
      this.device,
      this.projectInfo,
      this.reportsTo,
      this.code,
    });

    factory ProfileModel.fromJson(Map<String?, dynamic> json) => ProfileModel(
      success: json["success"],
      data: Data.fromJson(json["data"]),
      device: json["device"] != null 
        ? List<Device>.from(json["device"].map((x) => Device.fromJson(x)))
        : [
          Device(
            brand: "",
            deviceName: "",
            deviceType: "",
            modelNo: ""
          )
        ],
      projectInfo: json["projectInfo"] != null 
          ? List<ProjectInfo>.from(json["projectInfo"].map((x) => ProjectInfo.fromJson(x)))
          : ProjectInfo(
              projectName : "",
              endDateBs : "",
              projectLeaderId : 0,
              projectLeaderName : "",
              projectLeaderProfileImageUrl : "",
              progressPercent : "",
              teamsId : [
                TeamsId(
                  teamsId : 0,
                  teamName : "",
                  teamProfileImageUrl : ""

                )
              ],
          ),
      reportsTo: json["reportsTo"] == null ? null : ReportsTo.fromJson(json["reportsTo"]),
      code: json["code"],
    );

    Map<String?, dynamic> toJson() => {
      "success": success,
      "data": data!.toJson(),
      "device": List<dynamic>.from(device!.map((x) => x.toJson())),
      "projectInfo":  List<dynamic>.from(projectInfo.map((x) => x.toJson())),
      "reportsTo": reportsTo!.toJson(),
      "code": code,
    };
}

class Data {
    int? id;
    String? fullName;
    String? fName;
    String? mName;
    String? lName;
    String? fNameNp;
    String? mNameNp;
    String? lNameNp;
    String? departmentName;
    String? roleName;
    String? profileImageUrl;
    dynamic joinDateAd;
    String? fullNameNp;
    String? phoneNo;
    String? officialEmail;
    dynamic personalEmail;
    dynamic birthdayAd;
    String? genderName;
    dynamic citizenshipNo;
    CitizenshipAttr? citizenshipAttr;
    dynamic nationality;
    dynamic religion;
    String? maritalStatus;
    dynamic noOfChildren;
    dynamic panNo;
    dynamic passportNo;
    dynamic drivingLicense;
    dynamic personalVehicle;
    List<EmpEducation>? empEducation;
    List<EmpExperience>? empExperience;
    EntAddress? permanentAddress;
    EntAddress? currentAddress;
    List<ContactPerson>? contactPersons;
    List<EmpReference>? empReference;
    bool? notification;
    String? startTime;
    String? endTime;
    String? workingHours;

    Data({
        this.id,
        this.fullName,
        this.fName,
        this.mName,
        this.lName,
        this.fNameNp,
        this.mNameNp,
        this.lNameNp,
        this.departmentName,
        this.roleName,
        this.profileImageUrl,
        this.joinDateAd,
        this.fullNameNp,
        this.phoneNo,
        this.officialEmail,
        this.personalEmail,
        this.birthdayAd,
        this.genderName,
        this.citizenshipNo,
        this.citizenshipAttr,
        this.nationality,
        this.religion,
        this.maritalStatus,
        this.noOfChildren,
        this.panNo,
        this.passportNo,
        this.drivingLicense,
        this.personalVehicle,
        this.empEducation,
        this.empExperience,
        this.permanentAddress,
        this.currentAddress,
        this.contactPersons,
        this.empReference,
        this.notification,
        this.startTime,
        this.endTime,
        this.workingHours,
    });

    factory Data.fromJson(Map<String?, dynamic> json) => Data(
      id: json["id"],
      fullName: json["full_name"],
      fName: json["f_name"],
      mName: json["m_name"],
      lName: json["l_name"],
      fNameNp: json["f_name_np"],
      mNameNp: json["m_name_np"],
      lNameNp: json["l_name_np"],
      notification: json["notification"],
      departmentName: json["department_name"],
      roleName: "admin", //json["role_name"],
      profileImageUrl: json["profile_image_url"],
      joinDateAd: json["join_date_ad"],
      fullNameNp: json["full_name_np"],
      phoneNo: json["phone_no"] ?? '',
      officialEmail: json["official_email"],
      personalEmail: json["personal_email"],
      birthdayAd: json["birthday_ad"],
      genderName: json["gender_name"],
      citizenshipNo: json["citizenship_no"],
      citizenshipAttr: json["citizenship_attr"] != null 
        ? CitizenshipAttr.fromJson(json["citizenship_attr"])
        : CitizenshipAttr(
          issueDate: "",
          issueDateNp: "",
          issueDistrict: "",
        ),
      nationality: json["nationality"],
      religion: json["religion"],
      maritalStatus: json["marital_status"],
      noOfChildren: json["no_of_children"],
      panNo: json["pan_no"],
      passportNo: json["passport_no"],
      drivingLicense: json["driving_license"],
      personalVehicle: json["personal_vehicle"],
      startTime: json["start_time"] ?? "10:00",
      endTime: json["end_time"] ?? "19:00",
      workingHours: json["working_hours"] ?? "9",
      empEducation: json["emp_education"] !=  null 
        ? List<EmpEducation>.from(json["emp_education"].map((x) => EmpEducation.fromJson(x)))
        : [
          EmpEducation(
            completionYear: "",
            degree: "",
            institution: "",
            percentage: ""
          )
        ],
      empExperience: json["emp_experience"] != null
        ? List<EmpExperience>.from(json["emp_experience"].map((x) => EmpExperience.fromJson(x)))
        : [
          EmpExperience(
            company: "",
            position: "",
            workFrom: "",
            workFromNp: "",
            workTo: "",
            workToNp: "",
          )
        ],
      permanentAddress: json["permanent_address"] != null 
        ? EntAddress.fromJson(json["permanent_address"]) 
        : EntAddress(
          address: "",
          city: "",
          districtCode: "",
          districtName: "",
          stateCode: "",
          stateName: "",
          ward: "",
        ),
      currentAddress: json["current_address"] != null 
        ? EntAddress.fromJson(json["current_address"])
        : EntAddress(
          address: "",
          city: "",
          districtCode: "",
          districtName: "",
          stateCode: "",
          stateName: "",
          ward: "",
        ),
      contactPersons:  json["contact_persons"] != null 
        ? List<ContactPerson>.from(json["contact_persons"].map((x) => ContactPerson.fromJson(x)))
        : [
          ContactPerson(
            address: "",
            email: "",
            name: "",
            phone: "",
            relationship: "",
            title: "",
          ),
        ],
      empReference: json["emp_reference"] != null 
        ? List<EmpReference>.from(json["emp_reference"].map((x) => EmpReference.fromJson(x)))
        : [
          EmpReference(
            address: "",
            company: "",
            name: "",
            phone: ""
          )
        ],
    );

    Map<String?, dynamic> toJson() => {
      "id": id,
      "full_name": fullName,
      "f_name": fName,
      "m_name": mName,
      "l_name": lName,
      "f_name_np": fNameNp,
      "m_name_np": mNameNp,
      "l_name_np": lNameNp,
      "department_name": departmentName,
      "role_name": roleName,
      "profile_image_url": profileImageUrl,
      "join_date_ad": joinDateAd,
      "full_name_np": fullNameNp,
      "phone_no": phoneNo,
      "official_email": officialEmail,
      "personal_email": personalEmail,
      "birthday_ad": birthdayAd,
      "gender_name": genderName,
      "citizenship_no": citizenshipNo,
      "citizenship_attr": citizenshipAttr!.toJson(),
      "nationality": nationality,
      "religion": religion,
      "marital_status": maritalStatus,
      "no_of_children": noOfChildren,
      "pan_no": panNo,
      "passport_no": passportNo,
      "driving_license": drivingLicense,
      "personal_vehicle": personalVehicle,
      "emp_education": empEducation,
      "emp_experience": empExperience,
      "permanent_address": permanentAddress!.toJson(),
      "current_address": currentAddress!.toJson(),
      "contact_persons": List<dynamic>.from(contactPersons!.map((x) => x.toJson())),
      "emp_reference": List<dynamic>.from(empReference!.map((x) => x.toJson())),
      "notification": notification,
    };
}

class CitizenshipAttr {
    String? issueDateNp;
    String? issueDate;
    String? issueDistrict;

    CitizenshipAttr({
      this.issueDateNp,
      this.issueDate,
      this.issueDistrict,
    });

    factory CitizenshipAttr.fromJson(Map<String, dynamic> json) => CitizenshipAttr(
      issueDateNp: json["issue_date_np"] ?? "",
      issueDate: json["issue_date"] ?? "",
      issueDistrict: json["issue_district"] ?? "",
    );

    Map<String, dynamic> toJson() => {
      "issue_date_np": issueDateNp,
      "issue_date": issueDate,
      "issue_district": issueDistrict,
    };
}

class EmpReference {
    String? name;
    String? company;
    String? address;
    String? phone;

    EmpReference({
      this.name,
      this.company,
      this.address,
      this.phone,
    });

    factory EmpReference.fromJson(Map<String, dynamic> json) => EmpReference(
      name: json["name"] ?? '',
      company: json["company"] ?? '',
      address: json["address"] ?? '',
      phone: json["phone"] ?? '',
    );

    Map<String, dynamic> toJson() => {
      "name": name,
      "company": company,
      "address": address,
      "phone": phone,
    };
}

class ContactPerson {
    dynamic title;
    dynamic relationship;
    dynamic name;
    dynamic phone;
    dynamic email;
    dynamic address;

    ContactPerson({
      this.title,
      this.relationship,
      this.name,
      this.phone,
      this.email,
      this.address,
    });

    factory ContactPerson.fromJson(Map<String?, dynamic> json) => ContactPerson(
      title: json["title"],
      relationship: json["relationship"],
      name: json["name"],
      phone: json["phone"],
      email: json["email"],
      address: json["address"],
    );

    Map<String?, dynamic> toJson() => {
      "title": title,
      "relationship": relationship,
      "name": name,
      "phone": phone,
      "email": email,
      "address": address,
    };
}

class EntAddress {
    String? stateCode;
    String? stateName;
    String? districtCode;
    String? districtName;
    String? city;
    String? ward;
    String? address;

    EntAddress({
      this.stateCode,
      this.stateName,
      this.districtCode,
      this.districtName,
      this.city,
      this.ward,
      this.address,
    });

    factory EntAddress.fromJson(Map<String?, dynamic> json) => EntAddress(
      stateCode: json["state_code"],
      stateName: json["state_name"],
      districtCode: json["district_code"],
      districtName: json["district_name"],
      city: json["city"],
      ward: json["ward"],
      address: json["address"],
    );

    Map<String?, dynamic> toJson() => {
      "state_code": stateCode,
      "state_name": stateName,
      "district_code": districtCode,
      "district_name": districtName,
      "city": city,
      "ward": ward,
      "address": address,
    };
}

class ReportsTo {
    int? id;
    String? fullName;
    String? fullNameNp;
    String? roleName;
    String? officialEmail;
    String? profileImageUrl;

    ReportsTo({
      this.id,
      this.fullName,
      this.fullNameNp,
      this.roleName,
      this.officialEmail,
      this.profileImageUrl,
    });

    factory ReportsTo.fromJson(Map<String?, dynamic> json) => ReportsTo(
      id: json["id"],
      fullName: json["full_name"],
      fullNameNp: json["full_name_np"],
      roleName: json["role_name"],
      officialEmail: json["official_email"],
      profileImageUrl: json["profile_image_url"],
    );

    Map<String?, dynamic> toJson() => {
      "id": id,
      "full_name": fullName,
      "full_name_np": fullNameNp,
      "role_name": roleName,
      "official_email": officialEmail,
      "profile_image_url": profileImageUrl,
    };
}

class Device {
  String? deviceName;
  String? brand;
  String? modelNo;
  dynamic deviceType;

  Device({
    this.deviceName,
    this.brand,
    this.modelNo,
    this.deviceType,
  });

  factory Device.fromJson(Map<String, dynamic> json) => Device(
    deviceName: json["device_name"],
    brand: json["brand"],
    modelNo: json["model_no"],
    deviceType: json["device_type"],
  );

  Map<String, dynamic> toJson() => {
    "device_name": deviceName,
    "brand": brand,
    "model_no": modelNo,
    "device_type": deviceType,
  };
}

class EmpEducation {
    String? degree;
    String? institution;
    String? completionYear;
    String? percentage;

    EmpEducation({
      this.degree,
      this.institution,
      this.completionYear,
      this.percentage,
    });

    factory EmpEducation.fromJson(Map<String, dynamic> json) => EmpEducation(
      degree: json["degree"] ?? "",
      institution: json["institution"] ?? "",
      completionYear: json["completion_year"] ?? "",
      percentage: json["percentage"] ?? "",
    );

    Map<String, dynamic> toJson() => {
      "degree": degree,
      "institution": institution,
      "completion_year": completionYear,
      "percentage": percentage,
    };
}

class EmpExperience {
    String? company;
    String? workFromNp;
    String? workFrom;
    String? workToNp;
    String? workTo;
    String? position;

    EmpExperience({
      this.company,
      this.workFromNp,
      this.workFrom,
      this.workToNp,
      this.workTo,
      this.position,
    });

    factory EmpExperience.fromJson(Map<String, dynamic> json) => EmpExperience(
      company: json["company"] ?? "",
      workFromNp: json["work_from_np"] ?? "",
      workFrom: json["work_from"] ?? "",
      workToNp: json["work_to_np"] ?? "",
      workTo: json["work_to"] ?? "",
      position: json["position"] ?? "",
    );

    Map<String, dynamic> toJson() => {
      "company": company,
      "work_from_np": workFromNp,
      "work_from": workFrom,
      "work_to_np": workToNp,
      "work_to": workTo,
      "position": position,
    };
}

class ProjectInfo {
    String? projectName;
    String? endDateBs;
    int? projectLeaderId;
    String? projectLeaderName;
    String? projectLeaderProfileImageUrl;
    dynamic progressPercent;
    List<TeamsId>? teamsId;

    ProjectInfo({
        this.projectName,
        this.endDateBs,
        this.projectLeaderId,
        this.projectLeaderName,
        this.projectLeaderProfileImageUrl,
        this.progressPercent,
        this.teamsId,
    });

    factory ProjectInfo.fromJson(Map<String, dynamic> json) => ProjectInfo(
        projectName: json["project_name"],
        endDateBs: json["end_date_bs"],
        projectLeaderId: json["project_leader_id"],
        projectLeaderName: json["project_leader_name"],
        projectLeaderProfileImageUrl: json["project_leader_profile_image_url"],
        progressPercent: json["progress_percent"],
        teamsId: List<TeamsId>.from(json["teams_id"].map((x) => TeamsId.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "project_name": projectName,
        "end_date_bs": endDateBs,
        "project_leader_id": projectLeaderId,
        "project_leader_name": projectLeaderName,
        "project_leader_profile_image_url": projectLeaderProfileImageUrl,
        "progress_percent": progressPercent,
        "teams_id": List<dynamic>.from(teamsId!.map((x) => x.toJson())),
    };
}

class TeamsId {
    int? teamsId;
    String? teamName;
    String? teamProfileImageUrl;

    TeamsId({
        this.teamsId,
        this.teamName,
        this.teamProfileImageUrl,
    });

    factory TeamsId.fromJson(Map<String, dynamic> json) => TeamsId(
        teamsId: json["teams_id"],
        teamName: json["team_name"],
        teamProfileImageUrl: json["team_profile_image_url"],
    );

    Map<String, dynamic> toJson() => {
        "teams_id": teamsId,
        "team_name": teamName,
        "team_profile_image_url": teamProfileImageUrl,
    };
}