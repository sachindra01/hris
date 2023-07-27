import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hris/src/helper/read_write.dart';
import 'package:hris/src/model/attendance_model.dart';
import 'package:hris/src/model/attendance_today.dart';
import 'package:hris/src/repositary/api_repo.dart';
import 'package:hris/src/widgets/custom_loading.dart';
import 'package:hris/src/widgets/show_message.dart';

class AttendanceController extends GetxController{
  // ignore: prefer_typing_uninitialized_variables
  var attendanceToday;
  List attendance = [];
  late RxBool isLoading = false.obs;
  late RxBool ptr = false.obs; // pull to refresh
  
  getAttendanceList([isPtr, year, month, dateMode]) async {
    var date = isPtr == null ? year == null && month == null ? "" : "$year-$month" : "";
    try{
      isLoading(true);
      if(isPtr != null) ptr(true);
      var response = await ApiRepo.apiGet('api/employeesAttendances?date=$date&date_mode=$dateMode', '');
      if(response["success"] == true){
        final resp = AttendanceModel.fromJson(response);
        attendance = resp.data!;
        return resp;
      } else {
        Get.back();
        showMessage("An Error Occured!", response['message']);
      }
    } catch(e){
      debugPrint(e.toString());
    } finally {
      isLoading(false);
      ptr(false);
    }
  }

  updateLateReason(id, reason, context) async {
    try{
      customLoading(context);
      var formData = {
        'id': id,
        'employee_remarks': reason,
      };
      var response = await ApiRepo.apiPost('api/updateAttendance', formData);
      if(response["code"] == 200){
        //To pop Loading
        Get.back();
        //Pop Alert Dialog
        Get.back();
        //Get Back from Page
        getAttendanceList();
        showMessage("Attendance Update", response["message"].toString());
        return true;
      } else {
        //To pop loading and alert
        Get.back();
        Get.back();
        showMessage("An Error Occured!", response['message']);
      }
    } catch(e){
      debugPrint(e.toString());
      //To pop Loading
      Get.back();
      Get.back();
      showMessage("An Error Occured!", e.toString());
    }
  }

  addLateReason(id, reason, context) async {
    try{
      customLoading(context);
      var formData = {
        'id': id,
        'employee_remarks': reason,
      };
      var response = await ApiRepo.apiPost('api/addLateReason', formData);
      if(response["code"] == 200){
        //To pop Loading
        Get.back();
        //Pop Alert Dialog
        Get.back();
        //Get Back from Page
        getAttendanceList();
        showMessage("Attendance Update", response["message"].toString());
        return true;
      } else {
        //To pop loading and alert
        Get.back();
        Get.back();
        showMessage("An Error Occured!", response['message']);
      }
    } catch(e){
      debugPrint(e.toString());
      //To pop Loading
      Get.back();
      Get.back();
      showMessage("An Error Occured!", e.toString());
    }
  }

  attendanceTodays([isPtr]) async {
    try{
      isLoading(true);
      if(isPtr != null) ptr(true);
      var response = await ApiRepo.apiGet('api/dashboard', '');
      if(response['exception'] == null && response["success"] == true){
        final resp = AttendanceTodayModel.fromJson(response);
        attendanceToday = resp.data!;
      } else {
        Get.back();
        showMessage("An Error Occured!", response['message']);
      }
    } catch(e){
      debugPrint(e.toString());
    } finally {
      isLoading(false);
      ptr(false);
    }
  }

  //Check if late
  bool checkIfLate(String timeStr) {
    var startTime = read("startTime");
    // Convert the time string to a DateTime object
    DateTime time = DateTime.parse("2000-01-01 $timeStr");
    // Create a DateTime object with time that is late
    DateTime tenAM = DateTime.parse("2000-01-01 $startTime");
    // Compare the times
    return time.isAfter(tenAM);
  }

  bool checkIfLessWorkingHorus(String timeStr) {
    // Split the time string into hours and minutes
    List<String> timeParts = timeStr.split('.');
    
    if (timeParts.length != 2) {
      // Invalid time format
      return false;
    }

    // Parse hours and minutes from the time string
    int hours = int.tryParse(timeParts[0]) ?? 0;
    int minutes = int.tryParse(timeParts[1]) ?? 0;

    // Convert hours and minutes into a single duration (in minutes)
    int totalMinutes = hours * 60 + minutes;

    // Compare with 9 hours (540 minutes)
    return totalMinutes < 540;
  }

}