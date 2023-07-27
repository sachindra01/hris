import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hris/src/controller/app_controller.dart';
import 'package:hris/src/controller/leave_controller.dart';
import 'package:hris/src/helper/style.dart';
import 'package:hris/src/view/home/leave_detail.dart';
import 'package:hris/src/view/home/leave_form.dart';
import 'package:hris/src/widgets/show_message.dart';
import 'package:intl/intl.dart';

class LeaveList extends StatefulWidget {
  const LeaveList({super.key});

  @override
  State<LeaveList> createState() => _LeaveListState();
}

class _LeaveListState extends State<LeaveList> {

  final LeaveController _con = Get.put(LeaveController());
  final AppController appCon = Get.put(AppController());

  @override
  void initState() {
    _con.getLeaveList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _con.getLeaveList(true), 
      color: Theme.of(context).primaryColor,
      backgroundColor: Colors.transparent,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Obx(() => 
            _con.leaveIsLoading.value == true
              ? Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.32,
                  ),
                  Center(
                    child: Obx(() => Visibility(
                      visible: _con.ptr.value == false,
                      child: const CircularProgressIndicator()
                    )),
                  ),
                ],
              )
              : _con.leaveList.isEmpty
                ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(child: Text('noLeavesApp'.tr))
                )
                : Column(
                  children: [
                    SizedBox(height: 19.h,),
                    //Leave Lists
                    ListView.separated(
                      itemCount: _con.leaveList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return leaveListTile(index);
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 11.h);
                      }
                    ),
                    SizedBox(height: 40.h,)
                  ],
                )
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if(appCon.online.value){
              Get.to(() => const LeaveForm());
            } else{
              showMessage("Network Error", "Check your Internet Connection");
            }
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  //LeaveListTile
  leaveListTile(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Date
          Padding(
            padding:  EdgeInsets.only(left : 13.w),
            child: Text(convertDate(_con.leaveList[index].appliedDate), style: robotoWithColor(grey, 12, 0, FontWeight.bold)),
          ),
          SizedBox(height: 4.h,),
          //Leave List Tile
          InkWell(
            onLongPress: () => canUpdateLeave(index),
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                context: context, 
                builder: (context) => buildSheet(context, index),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal : 11.sp, vertical: 8.sp),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Get.isDarkMode ? containerBorderDark : containerBorderLight, width: 1.2.sp),
              ),  
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Leave Category and leave status
                  Row(
                    children: [
                      SizedBox(
                        width: 216.w,
                        child: Text("${_con.leaveList[index].leaveCategoryName}", 
                          style: robotoWithColor(getStatusFontColor(_con.leaveList[index].status.toString()), 12, 0.5, FontWeight.bold),
                              maxLines: 1, 
                              overflow: TextOverflow.ellipsis,
                        )
                      ),
                      const Spacer(),
                      //Leave status
                      Container(
                        width: 67.w,
                        height: 19.h,
                        // padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: getStatusColor(_con.leaveList[index].status.toString()),
                        ),
                        child: Text(_con.leaveList[index].status.toString(), style: robotoWithColor(getStatusFontColor(_con.leaveList[index].status.toString()), 10, 0, FontWeight.bold)),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  //Date And Time
                  Row(
                    children: [
                      //From Date
                      Text("${_con.leaveList[index].leaveFromAd}", style: roboto(14, 0, FontWeight.bold)), 
                      Visibility(
                        visible: _con.leaveList[index].leaveToAd != '',
                        child: Text(' - ', style: roboto(14, 0, FontWeight.bold))
                      ),
                      //To Date
                      Text("${_con.leaveList[index].leaveToAd}",style: roboto(14, 0, FontWeight.bold)),
                      SizedBox(
                        height: 13.h,
                        child: VerticalDivider(
                          color: Theme.of(context).dividerColor,
                          thickness: 0.8,
                        ),
                      ),
                      Icon(Icons.access_time, size: 13.sp, color: pink,),
                      SizedBox(width: 4.w,),
                      Text("${_con.decimalChecker(_con.leaveList[index].noOfDays)} day", style: roboto(11, 0, FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 6.h,),
                  //Leave Description
                  SizedBox(
                    height: 25.h,
                    width: double.infinity,
                    child: Text("${_con.leaveList[index].remarks}", 
                      style: robotoWithColor(grey, 12, 0.5), 
                      maxLines: 2, 
                      overflow: TextOverflow.ellipsis,
                    )
                  ),
                  SizedBox(height: 5.h),
                  //Leave Category
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: Text("${_con.leaveList[index].leaveCategoryName}", 
                  //     style:roboto1(getStatusFontColor(_con.leaveList[index].status.toString()), 9, 0, FontWeight.bold),
                  //     overflow: TextOverflow.ellipsis,
                  //   )
                  // ),
                  //Approver Section
                  SizedBox(
                    width: 240.w,
                    child: Wrap(
                      spacing: 10.w,
                      // runSpacing: 0.1.h,
                      alignment: WrapAlignment.start,
                      children: List.generate(
                        getApproverNames(index).length,
                        (idx) =>
                        RichText(
                          text: TextSpan(
                            text: '●',
                            style: TextStyle(
                              color: getStatusFontColor(getApproverNames(index)[idx]["status"]),
                            ),
                            children: [
                              TextSpan(
                                  text: " ${getApproverNames(index)[idx]["approverName"]}",
                                  style: robotoWithColor(Get.isDarkMode ? white : black ,11, 0.5),
                                ),
                              ],
                          ),
                        ),
                      )
                    )
                    // ListView.separated(
                    //   shrinkWrap: true,
                    //   physics: const BouncingScrollPhysics(),
                    //   separatorBuilder: (context, index) => SizedBox(width: 6.w,),
                    //   itemCount: approver.length,
                    //   scrollDirection: Axis.vertical,
                    //   itemBuilder: (context, index) {
                    //   return Container(
                    //     margin: EdgeInsets.symmetric(vertical : 3.sp),
                    //     padding: EdgeInsets.symmetric(vertical: 6.sp, horizontal: 8.sp),
                    //     decoration: BoxDecoration(
                    //       border: Border.all(color: grey500!, width: 1.2.sp),
                    //       borderRadius: BorderRadius.circular(50.r),
                    //     ),
                    //     child: Text(approver[index], style: poppins(10, 0),),
                    //   );
                    // },)
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  convertDate(appliedDate) {
    DateTime date = DateTime.parse(appliedDate);
    String formattedDate = DateFormat("MMM dd, yyyy").format(date);
    return formattedDate;
  }

  canUpdateLeave(index) async {
    for(var item in _con.leaveList[index].approverList) {
      if(item.status != "Applied") {
        showMessage("Leave Update", 'Selected leave cannot be updated.');
        return () {};
      }
    }
    if(_con.leaveList[index].status != "Applied") {
      showMessage("Leave Update", 'Selected leave cannot be updated.');
      return () {};
    }
    Get.to(()=> LeaveForm(
      update: true, 
      userData: [_con.leaveList[index]],
    ));
  }

  //Return Color acc to status
  getStatusColor(status) {
    return status == "Applied"
      ? lighrYellow // Applied
      : status == "Approved"
        ? lightGreen // Approved
        : lightPink;
  }
  
  // //Return Color acc to status
  // getStatusColor1(status) {
  //   return status == "Applied"
  //     ? blue // Applied
  //     : status == "Approved"
  //       ? green // Approved
  //       : red;
  // }

  //Return Color acc to status
  getStatusFontColor(status) {
    return status == "Applied"
      ? yellow // Applied
      : status == "Approved"
        ? green // Approved
        : pink;
  }

  //Store Approver names from api
  getApproverNames(index){
    List approverNames = [];
    for(var data in _con.leaveList[index].approverList as List){
      approverNames.add(
        {
          "approverName" : data.approverName.toString(),
          "status" : data.status.toString(),
        }
      );
    }
    return approverNames;
  }
  
  convertToDate(data) {
    String date = DateFormat('yyyy-MM-dd').format(data);
    return date;
  }

  makeDismissible({required Widget child, context}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: GestureDetector(
        onTap: () {},
        child: child,
      ),
    );
  }

  buildSheet(cont, index) {
    return makeDismissible(
      child: DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.35,
        maxChildSize: 0.9,
        builder: (_, controller) {
          return LeaveDetail(data: _con.leaveList[index], isLeaveList: true, scrollController: controller);
        },
      ),
      context: cont
    );
  }
}