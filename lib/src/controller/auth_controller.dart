import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:hris/src/helper/read_write.dart';
import 'package:hris/src/model/log_in_model.dart';
import 'package:hris/src/repositary/api_repo.dart';
import 'package:hris/src/services/authentication.dart';
import 'package:hris/src/view/auth_pages/login.dart';
import 'package:hris/src/view/auth_pages/reset_password.dart';
import 'dart:io' show Platform;
import 'package:hris/src/view/common/bottom_navigation.dart';
import 'package:hris/src/view/common/splash.dart';
import 'package:hris/src/widgets/custom_loading.dart';
import 'package:hris/src/model/profile_model.dart';
import 'package:hris/src/widgets/show_message.dart';
import 'package:dio/dio.dart';

class AuthController extends GetxController {

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  late RxBool isProfileLoading = false.obs;
  ProfileModel? userProfileData;
  final Authentication _auth = Authentication();

  startLoading(){
    isProfileLoading(true);
    update();
  }

  stopLoading(){
    isProfileLoading(false);
    update();
  }

  logIn(email, password, organization, context, [rememberMe]) async {
    try {
      customLoading(context);
      String deviceId = read('deviceId');
      String platform = kIsWeb ? 'web' : Platform.isAndroid ? 'android': 'ios';
      String? fcm = await messaging.getToken();
      var formData = {
        'official_email': email,
        'password': password,
        'organization_code': organization,
        'device_id': deviceId,
        'fcm_token': fcm,
        'longitude': read('longitude'),
        'latitude': read('latitude'),
        'platform': platform
      };

      var response = await ApiRepo.apiPost('api/login', formData);
      if(response["success"] == true) {
        response['data']['password'] = password;
        response['data']['organization_code'] = organization;
        write('loginInfo', response['data']);
        final data = LogInModel.fromJson(response);
        write('startTime', data.data!.startTime);
        write('ownId', data.data!.id);
        write('apiToken', data.data!.token);
        write('fcm',fcm);
        write('logInProvider', '');
        if(rememberMe != null) {
          write('rememberMe', rememberMe);
        }
        if (kDebugMode) {
          print("Bearer Token  => ${data.data!.token}");
        }
        //To pop Custom Loading
        Get.back();
        Get.off(() => const BottomNavigation());
      } else {
        // Get.back();
        Navigator.pop(context);       // to pop custom loading
        // showMessage("An Error Occured!", response['message']);
      }
    } catch (e) {
      //To pop Custom Loading
      // Get.back();
      Navigator.pop(context);
      showMessage("An Error Occured!", e.toString());
    }
  }
  
  firebaseLogIn(email, uuid, organization, context, provider, rememberMe) async {
    try {
      customLoading(context);
      String deviceId = read('deviceId');
      String platform = kIsWeb ? 'web' : Platform.isAndroid ? 'android': 'ios';
      String? fcm = await messaging.getToken();
      var formData = {
        'official_email': email,
        'uuid': uuid,
        'organization_code': organization,
        'device_id': deviceId,
        'fcm_token': fcm,
        'longitude': read('longitude'),
        'latitude': read('latitude'),
        'platform': platform,
        'provider' : provider
      };

      var response = await ApiRepo.apiPost('api/firebase-login', formData);
      if(response["success"] == true) {
        response['data']['password'] = '';
        response['data']['organization_code'] = organization;
        write('loginInfo', response['data']);
        final data = LogInModel.fromJson(response);
        write('ownId', data.data!.id);
        write('startTime', data.data!.startTime);
        write('apiToken', data.data!.token);
        write('fcm',fcm);
        write('logInProvider', provider);
        if(rememberMe != null) {
          write('rememberMe', rememberMe);
        }
        if (kDebugMode) {
          print("Bearer Token  => ${data.data!.token}");
        }
        //To pop Custom Loading
        Get.back();
        Get.off(() => const BottomNavigation());
      } else {
        Navigator.pop(context);       // to pop custom loading
      }
    } catch (e) {
      //To pop Custom Loading
      Navigator.pop(context);
      showMessage("An Error Occured!", e.toString());
    }
  }

  logOut(token, context) async{
    try{
      customLoading(context);
      var response = await ApiRepo.apiGet('api/logout','');
      if(response["success"] == true){
        remove("apiToken");
        remove('ownProfile');
        remove('longitude');
        remove('latitude');
        if(read('logInProvider') != null && read('logInProvider') != '') {
          await _auth.googleLogout();
          // remove('logInProvider');
        }
        //To pop Custom Loading
        Get.back();
        Get.offAll(() => const SplashScreen());
        Get.delete<AuthController>();
      } else {
        Get.back();
        showMessage("An Error Occured!", response['message']);
      }
    } catch(e){
      //To pop Custom Loading
      Get.back();
      showMessage("An Error Occured!", e.toString());
    }
  }

  forgetPassword(email, context) async {
    try {
      customLoading(context);
      var formData = {
        'official_email': email
      };
      var response = await ApiRepo.apiPost('api/forgetPassword', formData);
      if(response["success"] == true) {
        //To pop Custom Loading
        Get.back();
        // showCustomToast(context, "Check your mail and Input the code.");
        showMessage('Success', 'Check your mail for OTP');
        Get.to(()=> ResetPassword(
          email: email,
        ));
      } else {
        Navigator.pop(context); // Get.back(); 
        // showMessage("An Error Occured!", response['message']); 
      }
    } catch (e) {
      //To pop Custom Loading
        Navigator.pop(context); // Get.back(); 
        showMessage("An Error Occured!", e.toString());
    }
  }

  resetPassword(email, token, password, context) async {
    try {
      customLoading(context);
      var formData = {
        'official_email': email,
        'token' : token,
        'password' : password
      };

      var response = await ApiRepo.apiPost('api/resetPassword', formData);
      if(response["success"] == true) {
        //To pop Custom Loading
        Get.back();
        showMessage("Password Reset Succesful", "Your password has been reset succesfully");
        write('biometricsEnabled', false);
        Get.to(()=> const Login());
      } else {
        Get.back();
        showMessage("An Error Occured!", response['message']);
      }
    } catch (e) {
      //To pop Custom Loading
      Get.back();
      showMessage("An Error Occured!", e.toString());
    }
  }

  //Profile Controller
  getProfileData() async{
    try{
      startLoading();
      var response = await ApiRepo.apiGet('api/profile','');
      if(response["success"] == true){
        final data = ProfileModel.fromJson(response);
        userProfileData = data;
        var profile = read('loginInfo');
        write('startTime', userProfileData!.data!.startTime);
        profile['profile_image_url'] = userProfileData!.data!.profileImageUrl;
        write('loginInfo', profile);
        return data;
      } else {
        Get.back();
        showMessage("An Error Occured!", response['message']);
      }
    } catch(e){
      debugPrint(e.toString());
      stopLoading();  
    } finally{
      stopLoading();  
    }
  }

  //Post notification
  updateNotification(notification) async{
    try{
      startLoading();
      await ApiRepo.apiPost('api/notification', {'notification' : notification == true ? 1 : 0});
      // if(response["success"] == true) {
      // }
    } catch (e) {
      showMessage("An Error Occured!", e.toString());
    }
  }

  //Update Profile
  updateProfile(
    context,
    userInfo,
    profileImage,

    department,
    personalEmail,
    email,
    role,
    // Personal Tabs
    fNameEng,
    lNameEng,
    fNameNep,
    lNameNep,
    fullNameEng,
    fullNameNep,
    birthDate,
    noOfChildren,
    nationalityCode,
    religionCode,
    maritalStatusCode,
    gender,
    employeeEducationControllers,
    employeeExperienceControllers,
    //Document Tabs
    issueDate,
    issueDateNp,
    issueDistrict,
    citizenShip,
    panNo,
    passportNo,
    drivingLicense,
    personalVechile,
    //Contacts tabs 
    phone,
    //Permanent Address
    permanentState,
    permanentDistrict,
    permanentCity,
    permanentWardNo,
    permanentAddress,
    //Current Address
    state,
    district,
    city,
    wardNo,
    address,
    contactPersonControllers,
    employeeReferrenceControllers
  ) async {
    //To set data from form and send to api
    var contactPerson = [];
    var employeRefrence = [];
    var employeeEducation = [];
    var employeeExperience = [];
    var profileImg = read("pickedImage");

    //To set the string value of text controller
    //For contact person list
    for(var data in contactPersonControllers){
      contactPerson.add(
        {
          "title" : data["title"]?.text,
          "relationship" : data["relationship"]?.text,
          "name" : data["name"]?.text,
          "phone" : data["phone"]?.text,
          "email" : data["email"]?.text,
          "address" : data["address"]?.text,
        }
      );
    }

    //for employee reference list
    for(var data in employeeReferrenceControllers){
      employeRefrence.add(
        {
          "name" : data["name"]?.text,
          "company" : data["company"]?.text,
          "address" : data["address"]?.text,
          "phone" : data["phone"]?.text,
        }
      );
    }

    //for employee education
    for(var data in employeeEducationControllers){
      employeeEducation.add(
        {
          "degree" : data["degree"]?.text,
          "institution" : data["institution"]?.text,
          "completion_year" : data["completion_year"]?.text,
          "percentage" : data["percentage"]?.text,
        }
      );
    }

    //for employee experience
    for(var data in employeeExperienceControllers){
      employeeExperience.add(
        {
          "company" : data["company"]?.text,
          "work_from" : data["workFrom"]?.text,
          "work_to" : data["workTo"]?.text,
          "position" :  data["position"]?.text
        }
      );
    }
    
    var updateUserInfo = FormData.fromMap({
      'f_name' :  fNameEng,
      'l_name' :  lNameEng,
      'f_name_np' : fNameNep,
      'l_name_np' : lNameNep,
      'gender' :  gender,
      'nationality' :  nationalityCode,
      'religion' :  religionCode,
      'birthday_ad' :  birthDate == "" ? null : birthDate,
      'marital_status' :  maritalStatusCode ?? "unmarried",
      'no_of_children' :  noOfChildren == ""  ? 0 : noOfChildren,
      'citizenship_no' :  citizenShip == ""  ? null : citizenShip,
      'pan_no' :  panNo == "" ? null : panNo,
      'passport_no' : passportNo == ""  ? null : passportNo,
      'driving_license' : drivingLicense == ""  ? null : drivingLicense,
      'personal_vehicle' : personalVechile == ""  ? null : personalVechile,
      'personal_email' : personalEmail == "" ? null : personalEmail,
      'phone_no' :  phone,
      'emp_education' :  employeeEducation,
      'emp_experience' :  employeeExperience,
      "permanent_address" : permanentState == "null"
        ? null 
        : {
          "state" : permanentState == '' ? null : permanentState,  
          "district" : permanentDistrict == '' ? null : permanentDistrict,
          "city" : permanentCity == '' ? null : permanentCity,
          "ward" : permanentWardNo == '' ? null : permanentWardNo,
          "address" : permanentAddress == '' ? null : permanentAddress,
        },
      "current_address" : {
        "state" : state?.toString(),  
        "district" : district?.toString(),
        "city" : city == "" ? null : city ,
        "ward" : wardNo == "" ? null : wardNo,
        "address" : address == "" ? null : address,
      },
      "contact_persons" :  contactPerson,
      "emp_reference" : employeRefrence,
      "citizenship_attr" : {
        "issue_date" : issueDate == '' ? null : issueDate, 
        "issue_date_np" : issueDateNp == '' ? null : issueDateNp, 
        "issue_district" : issueDistrict == '' ? null : issueDistrict,
      },
      'employee_image' : profileImg == null || profileImg == ""
        ? ''
        : await MultipartFile.fromFile(
          profileImg.path, 
          filename: profileImg.path.split('/').last,
        ) 
    });
    try{
      startLoading();
      var response = await ApiRepo.apiPost('api/updateProfile', updateUserInfo);
      if(response != null && response["code"] == 200){
        Get.off(()=>const BottomNavigation(index: 4,));
        showMessage("Success", response['message']);
      } else {
        stopLoading();
      }
    } catch(e){
      debugPrint(e.toString());
      stopLoading();
    }
  }

}