import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hris/src/controller/app_controller.dart';
import 'package:hris/src/helper/read_write.dart';
import 'package:hris/src/model/employee_list_model.dart';
import 'package:hris/src/model/on_leave_today.dart' hide Datum;
import 'package:hris/src/repositary/api_repo.dart';
import 'package:hris/src/widgets/show_message.dart';
import 'package:intl/intl.dart';

class EmployeeController extends GetxController{
  final AppController _appCon = Get.put(AppController());
  List employeeList = [];
  List onLeaveList = [];
  List originalEmployeeList = [];
  late RxBool isLoading = false.obs;
  late RxBool isOnLeaveLoading = false.obs;
  late RxBool ptr = false.obs; // pull to refresh
  var selectedLeaveDate = DateFormat('y-MM-dd').format(DateTime.now()); 
  bool isOnline = true;
  
  getEmployeeList([isPtr]) async {
    isLoading(true);
    isOnline = await _appCon.checkInitialConnectivity();
    isOnline == true 
      ? getEmployeeListOnline([isPtr])
      : getEmployeeListOffline([isPtr]);
    isLoading(false);
  }

  getEmployeeListOffline([isPtr]) {
    var data = read('employeeList');
    if(data != '') {
      for(var item in data) {
        employeeList.add(Datum.fromJson(item));
      }
      originalEmployeeList = employeeList;
    } else {
      employeeList = [];
      originalEmployeeList = [];
    }
  }

  getEmployeeListOnline([isPtr]) async {
     try{
      if(isPtr != null) ptr(true);
      var response = await ApiRepo.apiGet('api/employees?self_display=1','');
      if(response["success"] == true){
        final resp = EmployeeListModel.fromJson(response);
        employeeList = resp.data!;
        originalEmployeeList = employeeList;
        write('employeeList', employeeList);
        return resp;
      } else {
        Get.back();
        showMessage("An Error Occured!", response['message']);
      }
    } catch(e){
      debugPrint(e.toString());
    } finally {
      ptr(false);
    }
  }

  getEmployeeOnLeaveList([isPtr]) async {
    try{
      isOnLeaveLoading(true);
      selectedLeaveDate = DateFormat('y-MM-dd').format(DateTime.now()); 
      if(isPtr != null) ptr(true);
      var response = await ApiRepo.apiGet('api/absentEmployeesList','');
      if(response["success"] == true) {
        final resp = EmployeeOnLeaveModel.fromJson(response);
        onLeaveList = resp.data!;
        return resp;
      } else {
        Get.back();
        showMessage("An Error Occured!", response['message']);
      }
    } catch(e){
      debugPrint(e.toString());
    } finally {
      isOnLeaveLoading(false);
      ptr(false);
    }
  }

  getEmployeeOnLeaveListSwipe(direction, [isPtr]) async {
    try{
      isOnLeaveLoading(true);
      if(isPtr != null) ptr(true);
      var newDate = '';
      if(direction == 'next') {
        newDate = DateFormat('y-MM-dd').format(DateFormat('y-MM-dd').parse(selectedLeaveDate).add(const Duration(days: 1)));
      } else if(direction == 'prev'){
        newDate = DateFormat('y-MM-dd').format(DateFormat('y-MM-dd').parse(selectedLeaveDate).subtract(const Duration(days: 1)));
      } else {
        newDate = DateFormat('y-MM-dd').format(DateFormat('y-MM-dd').parse(selectedLeaveDate));
      }
      selectedLeaveDate = newDate;
      var response = await ApiRepo.apiGet('api/absentEmployeesList?date_field=$newDate','');
      if(response["success"] == true) {
        final resp = EmployeeOnLeaveModel.fromJson(response);
        onLeaveList = resp.data!;
        return resp;
      } else {
        Get.back();
        showMessage("An Error Occured!", response['message']);
      }
    } catch(e){
      debugPrint(e.toString());
    } finally {
      isOnLeaveLoading(false);
      ptr(false);
    }
  }

  getFilteredEmployee(value) async {
    try{
      isLoading(true);
      if (value.isEmpty) {
        // If the search input is empty, reset the employeeList to the original list
        employeeList = List.from(originalEmployeeList);
      } else {
        List searchResults = originalEmployeeList
            .where((item) =>
                item.fullName.toLowerCase().contains(value.toLowerCase()))
            .toList();
        employeeList = searchResults;
      }
    } catch(e){
      debugPrint(e.toString());
    } finally {
      isLoading(false);
    }
  }

}