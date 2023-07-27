import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hris/src/controller/leave_controller.dart';
import 'package:hris/src/helper/read_write.dart';
import 'package:hris/src/helper/style.dart';
import 'package:hris/src/widgets/custom_alert_dialog.dart';
import 'package:hris/src/widgets/custom_button.dart';
import 'package:hris/src/widgets/custom_text_field.dart';

class LeaveDetail extends StatefulWidget {
  const LeaveDetail({super.key, required this.data, required this.isLeaveList, required this.scrollController});
  // ignore: prefer_typing_uninitialized_variables
  final data;
  final bool? isLeaveList;
  final dynamic scrollController;

  @override
  State<LeaveDetail> createState() => _LeaveDetailState();
}

class _LeaveDetailState extends State<LeaveDetail> {
  final _formKey = GlobalKey<FormState>();
  final LeaveController _con = Get.put(LeaveController());
  List approverData = [];

  @override
  void initState() {
    getApproverRemarks();
    super.initState();
  }

  getApproverRemarks(){
    for(var data in widget.data.approverList){
      approverData.add({
        "approverName" : data.approverName,
        "approverRemark" : data.approverRemarks,
        "approverStatus" : data.status,
        "approverId" : data.approverId,
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          header(),
          body()
        ],
      ),
    );
  }

  Widget header() {
    return Container(
      height: 70.h,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h,),
          //Bottomsheet Drag Indicator
          Center(
            child: Container(
              height: 3.h,
              width: 35.w,
              decoration: BoxDecoration(
                color: grey,
                borderRadius: BorderRadius.circular(100.r)
              ),
            ),
          ),
          SizedBox(height: 15.h,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              'Leave Detail',
              style: roboto(17, 0.0, FontWeight.w500)
            ),
          ),
          SizedBox(height: 5.h,),
          Divider(
            thickness: 0.2,
            color: grey.withOpacity(0.4),
          )
        ],
      ),
    );
  }

  body() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.56,
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Applicant Name
                Visibility(
                  visible: widget.isLeaveList == false,
                  child: Text(widget.data.name ?? "Null", style: roboto(16, 0.0, FontWeight.w500))
                ),
                SizedBox(height: 10.0.h),
                //Leave Reason
                CustomTextField(
                  readOnly: true,
                  labelText: "Leave Reason",
                  initialValue : widget.data.remarks.toString(),
                  enableInteractiveSelection: false,
                ),
                SizedBox(height: 14.0.h),
                //Leave Category
                Row(
                  children: [
                    SizedBox(
                      width: 94.w,
                      child: Text(
                        'Category ',
                        style: roboto(14, 0.0)
                      ),
                    ),
                    const Spacer(),
                    dataContainer(widget.data.leaveCategoryName)
                  ],
                ),
                SizedBox(height: 10.0.h),
                //Leave Days
                Row(
                  children: [
                    SizedBox(
                      width: 94.w,
                      child: Text(
                        'Leave Day ',
                        style: roboto(14, 0.0)
                      ),
                    ),
                    const Spacer(),
                    dataContainer(widget.data.leaveDayName)
                  ],
                ),
                SizedBox(height: 10.0.h),
                //No. Of Days
                Row(
                  children: [
                    SizedBox(
                      width: 94.w,
                      child: Text(
                        'No. of Days ',
                        style: roboto(14, 0.0)
                      ),
                    ),
                    const Spacer(),
                    dataContainer(widget.data.noOfDays)
                  ],
                ),
                SizedBox(height: 15.0.h),
                //Date
                widget.data.leaveToAd == null || widget.data.leaveToAd == "" 
                ? SizedBox(
                  width: 140.w,
                  child: dataContainer(widget.data.leaveFromAd, true),
                )
                :Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 140.w,
                      child: dataContainer(widget.data.leaveFromAd, true),
                    ),
                    const Text('~'),
                    SizedBox(
                      width: 140.w,
                      child:  dataContainer(widget.data.leaveToAd, true),
                    ),
                  ],
                ),
                SizedBox(height: 35.0.h),
                //For Approver List
                Visibility(
                  visible: widget.isLeaveList == false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Approver Remarks", style: roboto(13, 0.0),),
                      SizedBox(height: 20.0.h),
                      ListView.separated(
                        separatorBuilder: (context, index) => SizedBox(height: 4.h),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: approverData.length,
                        itemBuilder: (context, index) {
                          if(approverData[index]["approverId"] == read('ownId') && widget.data.approverList[index].status == "Applied"){
                            return const SizedBox();
                          } else {
                              return Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(10.r)
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Approver Name and status
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      //Appover Name
                                      SizedBox(
                                        width: 200.w,
                                        child: Text(
                                          approverData[index]["approverName"].toString(), style: roboto(12, 0.0, FontWeight.w500),
                                          maxLines: 2,
                                        )
                                      ),
                                      //Approver Status
                                      Container(
                                        width: 75.w,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
                                        decoration: BoxDecoration(
                                          color: getStatusColor(approverData[index]["approverStatus"].toString()),
                                          borderRadius: BorderRadius.circular(100),
                                        ),
                                        child: Text(
                                          approverData[index]["approverStatus"].toString() == "Applied"
                                          ? "Pending"
                                          : approverData[index]["approverStatus"].toString(),
                                          style: robotoWithColor(
                                            getStatusFontColor(approverData[index]["approverStatus"].toString()),
                                            9.5,
                                            0.0,
                                            FontWeight.normal,
                                          )
                                        ),
                                      )
                                    ],
                                  ),
                                  approverData[index]["approverRemark"] == null || approverData[index]["approverRemark"] == ""
                                  ? const SizedBox() 
                                  : Padding(
                                    padding: EdgeInsets.only(top: 5.0.h),
                                    child: Text(approverData[index]["approverRemark"].toString(), style: roboto(10, 0.0),),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      ),
                      SizedBox(height: 15.0.h),
                      checkStatus()
                    ],
                  ),
                ),
                Visibility(
                  visible: widget.isLeaveList == true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Approver Remarks", style: roboto(13, 0.0),),
                      SizedBox(height: 20.0.h),
                      ListView.separated(
                        separatorBuilder: (context, index) => SizedBox(height: 8.h),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: approverData.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(10.r)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Approver Name and status
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    //Appover Name
                                    SizedBox(
                                      width: 200.w,
                                      child: Text(
                                        approverData[index]["approverName"].toString(), style: roboto(12, 0.0, FontWeight.w500),
                                        maxLines: 2,
                                      )
                                    ),
                                    //Approver Status
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical : 3.sp),
                                      padding: EdgeInsets.symmetric(vertical: 4.sp, horizontal: 8.sp),
                                      decoration: BoxDecoration(
                                        color: getStatusColor(approverData[index]["approverStatus"].toString()),
                                        border: Border.all(color: Colors.transparent, width: 1.2.sp),
                                        borderRadius: BorderRadius.circular(50.r),
                                      ),
                                      child: Text(
                                        approverData[index]["approverStatus"].toString() == "Applied"
                                         ? "Pending"
                                         : approverData[index]["approverStatus"].toString(),
                                        style: robotoWithColor(
                                          getStatusFontColor(approverData[index]["approverStatus"].toString()),
                                          9.5,
                                          0.0,
                                          FontWeight.normal,
                                        )
                                      ),
                                    )
                                  ],
                                ),
                                approverData[index]["approverRemark"] == null || approverData[index]["approverRemark"] == ""
                                ? const SizedBox() 
                                : Padding(
                                  padding: EdgeInsets.only(top: 10.0.h),
                                  child: Text(approverData[index]["approverRemark"].toString(), style: roboto(10, 0.0),),
                                ),
                              ],
                            ),
                          );
                        }
                      ),
                      SizedBox(height: 20.0.h),
                      cancelLeave()
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle labelStyle() {
    return const TextStyle(
      fontSize: 16.0
    );
  }

  Widget dataContainer(dataItem, [multipleTextbox, reason]) {
    return Container(
      decoration: BoxDecoration(
        color: Get.isDarkMode ? grey800 : grey100,
        borderRadius: BorderRadius.circular(4.r)
      ),
      alignment: Alignment.centerLeft,
      height: reason != null ? 60.0 : 30.h,
      width: multipleTextbox == null ? MediaQuery.of(context).size.width * 0.59 : MediaQuery.of(context).size.width * 0.45,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          dataItem.toString(),
          textAlign: TextAlign.start,
          style: roboto(14, 0.0, FontWeight.w500)
        ),
      ),
    );
  }

  Widget acceptButtons(id) {
    return SizedBox(
      height: 50.0.h,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 12.0,
          right: 12.0
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: 'Approve', 
              color: green,
              fontColor: white,
              height: 35.h,
              width: 110.w,
              borderRadius: 100.r,
              onPressed: () => approvalRemarksDialog(context, 1, id)
            ),
            SizedBox(width: 8.w),
            // CustomButton(
            //   text: 'Detail', 
            //   color: Colors.blue,
            //   width: 100.0,
            //   height: 40.0,
            //   onPressed: () {}
            // ),
            CustomButton(
              text: 'Reject', 
              color: red,
              fontColor: white,
              height: 35.h,
              width: 110.w,
              borderRadius: 100.r,
              onPressed: () => approvalRemarksDialog(context, 2, id) //_con.approveLeave(context, 2, id)
            )
          ],
        ),
      ),
    );
  }

  Widget approveResult(status) {
    return Center(
      child: CustomButton(
        height: 40.h,
        width: 110.w,
        borderRadius: 100.r,
        onPressed: (){},
        text: status,
        color: status == "Approved" ? green : red,
      ),
    );
  }

  approvalRemarksDialog(context, status, id) {
    TextEditingController leaveReasonCon = TextEditingController();
    String statusText = status == 1 ? 'approve' : 'reject';  
    return Get.defaultDialog(
      title: 'Add a Remark',
      contentPadding: REdgeInsets.all(15.sp),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: leaveReasonCon,
              maxLines: 3,
              keyboardType: TextInputType.text,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (val) => status == 1 ? null : val!.isEmpty ? 'Please provide with reason' : null,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Get.isDarkMode ? white : black,
                    width: 1.2
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Get.isDarkMode ? white : black,
                    width: 1.2
                  )
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red, 
                    width: 1.2
                  ),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                    width: 1.2,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            CustomButton(
              height: 35.h,
              fontSize: 15,
              text: status == 1 ? 'Approve' : 'Reject',
              fontColor: white,
              color: status == 1 ? green : red,
              onPressed: () {
                if(_formKey.currentState!.validate()) {
                  customAlertDialog(
                    'Yes', 
                    () => _con.approveLeave(context, status, id, leaveReasonCon.text),
                    'No', 
                    () => Get.back(), 
                    'You are about to $statusText the request. Are you sure?'
                  );
                }
              }
            )
          ],
        ),
      )
    );
  }

  cancelLeave() {
    for(var item in widget.data.approverList) {
      if(item.status != "Applied") {
        return const SizedBox();
      }
    }
    return SizedBox(
      height: 50.0,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 12.0,
          right: 12.0
        ),
        child: Center(
          child: CustomButton(
            text: 'Cancel Leave', 
            color: red,
            fontColor: white,
            height: 35.h,
            width: 135.w,
            borderRadius: 100.r,
            fontWeight: FontWeight.bold,
            onPressed: () => cancelLeaveAlert(),
          ),
        ),
      ),
    );
  }

  cancelLeaveAlert() {
    return customAlertDialog(
      'Yes', 
      () => _con.cancelLeave(context, widget.data.id),
      'No', 
      () => Get.back(), 
      'You are about to cancel the request. Are you sure?'
    );
  }

  checkStatus() {
    int id = read('ownId');
    var matchingObjects = widget.data.approverList.where((obj) => obj.approverId == id);
    if (matchingObjects.isNotEmpty) {
      if(matchingObjects.first.status != "Applied") {
        return const SizedBox();
      } else {
        return acceptButtons(widget.data.id);
      }
    } else {
      return approveResult(widget.data.status);
    }
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
}