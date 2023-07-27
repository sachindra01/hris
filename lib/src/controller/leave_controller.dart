import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris/src/model/approve_list_model.dart';
import 'package:hris/src/model/leave_category_model.dart';
import 'package:hris/src/model/leave_days_model.dart';
import 'package:hris/src/model/leave_list_model.dart';
import 'package:hris/src/repositary/api_repo.dart';
import 'package:hris/src/widgets/custom_loading.dart';
import 'package:hris/src/widgets/show_message.dart';

class LeaveController extends GetxController {

  late RxBool isLoading = false.obs;
  late RxBool leaveIsLoading = false.obs;
  late RxBool approveIsLoading = false.obs;
  List leaveList = [];
  List approveList = [];
  List<List> leaveListApproverNameList = [];
  List<List> leaveListApproverIdList = [];
  RxDouble leaveTaken = 0.0.obs;
  late RxBool ptr = false.obs; // pull to refresh

  startLoading(){
    isLoading(true);
    update();
  }

  stopLoading(){
    isLoading(false);
    update();
  }

  getLeaveList([isPtr]) async {
    try{
      leaveIsLoading(true);
      if(isPtr != null) ptr(true);
      var response = await ApiRepo.apiGet('api/employeeLeaves','');
      if(response["success"] == true) {
        leaveTaken(0.0);
        final resp = LeaveListModel.fromJson(response);
        leaveList = resp.data!;
        for(var item in leaveList) {
          if(item.status == "Approved") {
            leaveTaken.value += double.parse(item.noOfDays);
          }
        }
      } else {
        Get.back();
        showMessage("An Error Occured!", response['message']);
      }
    } catch(e){
      debugPrint(e.toString());
    } finally{
      leaveIsLoading(false);
      ptr(false);
    }
  }

  getLeaveApproveList([isPtr]) async {
    try{
      approveIsLoading(true);
      if(isPtr != null) ptr(true);
      var response = await ApiRepo.apiGet('api/approverList','');
      if(response["success"] == true){
        final resp = ApproveListModel.fromJson(response);
        approveList = resp.data;
      } else {
        Get.back();
        showMessage("An Error Occured!", response['message']);
      }
    } catch(e) {
      debugPrint(e.toString());
    } finally {
      approveIsLoading(false);
      ptr(false);
    }
  }

  getLeaveCategory() async{
    try {
      var response = await ApiRepo.apiGet('api/getLeaveCategorys', '');
      if(response["success"] == true){
        final data = LeaveCategoryModel.fromJson(response);
        return data;
      } else {
        // Get.back();
        // showMessage("An Error Occured!", response['message']);
      }
    } catch (e) {
      log(e.toString());
      showMessage("An Error Occured!", e.toString());
    }
  }

  getLeaveDays() async{
    try {
      var response = await ApiRepo.apiGet('api/getLeaveDays', '');
      if(response["success"] == true){
        final data = LeaveDays.fromJson(response);
        return data;
      } else {
        Get.back();
        showMessage("An Error Occured!", response['message']);
      }
    } catch (e) {
      log(e.toString());
      showMessage("An Error Occured!", e.toString());
    }
  }

  addLeave(context, leaveCategory, from, to, leaveDaysCode, leaveReason, noOfDays, approverIdList) async{
    try{
      customLoading(context);
      var formData = {
        'leave_category': leaveCategory,
        'no_of_days': noOfDays ?? "1",
        'remarks': leaveReason,
        'leave_from_ad': from,
        'leave_to_ad': to == "" ? null : to,
        'leave_day_code': leaveDaysCode,
        'approveform': jsonEncode(approverIdList)
      };
      var response = await ApiRepo.apiPost('api/employeeLeaves', formData);
      if(response["success"] == true){
        //To pop Loading
        Get.back();
        //Pop Alert Dialog
        Get.back();
        //Get Back from Page
        Get.back();
        showMessage("Leave Added", response["message"].toString());
        getLeaveList();
      } else {
        //To pop Loading
        Navigator.pop(context);
        //Pop Alert Dialog
        Get.back();
        showMessage("An Error Occured!", response['message']);
      }
    } catch(e){
      debugPrint(e.toString());
      //To pop Loading
      Navigator.pop(context);
      //Pop Alert Dialog
      Get.back();
      showMessage("An Error Occured!", e.toString());
    }
  }

  approveLeave(context, status, leaveId, [rejectReason]) async{
    try{
      customLoading(context);
      var formData = {
        'status': status,
        'emp_leave_id': leaveId,
        "approver_remarks": rejectReason
      };
      var response = await ApiRepo.apiPost('api/approveLeave', formData);
      if(response["success"] == true){
        Get.back();     //To pop Loading
        Get.back();     //Get Back from Page
        Get.back();     //Get back from alert dialog
        Get.back();     // Get back from remarks dialog
        showMessage("Leave Request", response["message"].toString());
        getLeaveApproveList();
      } else {
        Get.back();
        showMessage("An Error Occured!", response['message']);
      }
    } catch(e) {
      debugPrint(e.toString());
      //To pop Loading
      Get.back();
      showMessage("An Error Occured!", e.toString());
    }
  }

  cancelLeave(context, leaveId) async {
    try{
      Get.back();       // Alert dialog
      customLoading(context);
      var response = await ApiRepo.apiDelete('api/employeeLeaves/$leaveId');
      if(response["success"] == true){
        Get.back();     //To pop Loading
        Get.back();     //Get Back from Page
        showMessage("Leave Request", response["message"].toString());
        getLeaveList();
      } else {
        Get.back();
        showMessage("An Error Occured!", response['message']);
      }
    } catch(e) {
      debugPrint(e.toString());
      //To pop Loading
      Get.back();
      showMessage("An Error Occured!", e.toString());
    }
  }

  updateLeaveRequest(context, id, leaveCategory, from, to, leaveDaysCode, leaveReason, noOfDays, approverIdList) async {
    try{
      startLoading();
      var updateLeaveInfo = {
        'leave_category': leaveCategory,
        'no_of_days': noOfDays ?? "1",
        'remarks': leaveReason,
        'leave_from_ad': from,
        'leave_to_ad': to == "" ? from : to,
        'leave_day_code': leaveDaysCode ?? "1",
        'approveform': jsonEncode(approverIdList)
      };
      var response = await ApiRepo.apiPut('api/employeeLeaves/$id', updateLeaveInfo);
      if(response['code'] == 200){
        Get.back();         // pop loading
        Get.back();         // back to list
        showMessage("Success", response['message']);
        getLeaveList();
      } else {
        Get.back();
        showMessage("An Error Occured!", response['message']);
      }
    } catch(e){
      debugPrint(e.toString());
    } finally{
      stopLoading();  
    }
  }

  decimalChecker(value) {
    List split = value.split(".");
    if(split.length == 2){
      return split[1] == '00' ? split[0] : value; 
    } else {
      return split[0];
    }
  }
  
}