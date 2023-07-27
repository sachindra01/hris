import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hris/src/controller/leave_controller.dart';
import 'package:hris/src/helper/style.dart';
import 'package:hris/src/view/home/leave_detail.dart';

class ApproveList extends StatefulWidget {
  const ApproveList({super.key});

  @override
  State<ApproveList> createState() => _ApproveListState();
}

class _ApproveListState extends State<ApproveList> {

  final LeaveController _con = Get.put(LeaveController());

  @override
  void initState() {
    _con.getLeaveApproveList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _con.getLeaveApproveList(true),
      color: Theme.of(context).primaryColor,
      backgroundColor: Colors.transparent,
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Obx(() => 
            _con.approveIsLoading.value == true
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
              : _con.approveList.isEmpty
                ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(child: Text('nothintoApprove'.tr))
                )
                : Column(
                  children: [
                    SizedBox(height: 19.h,),
                    ListView.separated(
                      itemCount: _con.approveList.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return approverListTile(index);
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 10.h,);
                      }
                    ),
                    SizedBox(height: 10.h,)
                  ],
                )
          ),
        ),
      ),
    );
  }

  //Approve List
  approverListTile(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: InkWell(
        onTap: (){
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
              //Applicant Name
              Text("${_con.approveList[index].name}", style: roboto(14, 0.0, FontWeight.bold),),
              //Leave Category and leave status
              Row(
                children: [
                  SizedBox(
                    width: 216.w,
                    child: Text("${_con.approveList[index].leaveCategoryName}", 
                      style: robotoWithColor(getStatusFontColor(_con.approveList[index].status), 12, 0.5, FontWeight.bold),
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
                      color: getStatusColor(_con.approveList[index].status),
                    ),
                    child: Text(_con.approveList[index].status, style: robotoWithColor(getStatusFontColor(_con.approveList[index].status), 10, 0, FontWeight.bold)),
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              //Date And Time
              Row(
                children: [
                  //From Date
                  Text("${_con.approveList[index].leaveFromAd}", style: roboto(14, 0, FontWeight.bold)), 
                  Visibility(
                    visible: _con.approveList[index].leaveToAd != '',
                    child: Text(' - ', style: roboto(14, 0, FontWeight.bold))
                  ),
                  //To Date
                  Text("${_con.approveList[index].leaveToAd}",style: roboto(14, 0, FontWeight.bold)),
                  SizedBox(
                    height: 13.h,
                    child: VerticalDivider(
                      color: Theme.of(context).dividerColor,
                      thickness: 0.8,
                    ),
                  ),
                  Icon(Icons.access_time, size: 13.sp, color: pink,),
                  SizedBox(width: 4.w,),
                  Text("${_con.decimalChecker(_con.approveList[index].noOfDays)} day", style: roboto(11, 0, FontWeight.bold)),
                ],
              ),
              SizedBox(height: 6.h,),
              //Leave Description
              SizedBox(
                height: 25.h,
                width: double.infinity,
                child: Text("${_con.approveList[index].remarks}", 
                  style: robotoWithColor(grey, 12, 0.5), 
                  maxLines: 2, 
                  overflow: TextOverflow.ellipsis,
                )
              ),
              SizedBox(height: 5.h),
              //Leave Category
              // SizedBox(
              //   width: double.infinity,
              //   child: Text("${_con.approveList[index].leaveCategoryName}", 
              //     style:roboto1(getStatusFontColor(_con.approveList[index].status.toString()), 9, 0, FontWeight.bold),
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
    );
  }

  //Return Color acc to status
  getStatusColor(status) {
    return status == "Applied"
      ? lighrYellow // Applied
      : status == "Approved"
        ? lightGreen // Approved
        : lightPink;
  }

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
    for(var data in _con.approveList[index].approverList as List){
      approverNames.add({
        "approverName" : data.approverName.toString(),
        "status" : data.status.toString(),
      });
    }
    return approverNames;
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
          return LeaveDetail(data: _con.approveList[index], isLeaveList: false, scrollController: controller);
        },
      ),
      context: cont
    );
  }

}