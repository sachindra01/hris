import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hris/src/controller/attendance_controller.dart';
import 'package:hris/src/controller/employee_controller.dart';
import 'package:hris/src/helper/read_write.dart';
import 'package:hris/src/helper/style.dart';
import 'package:hris/src/view/common/app_bars.dart';
import 'package:hris/src/view/home/notice_tile.dart';
import 'package:hris/src/view/home/todays_update_tile.dart';
import 'package:hris/src/widgets/cached_network_image.dart';
import 'package:hris/src/widgets/custom_date_picker.dart';
import 'package:intl/intl.dart';

class OnLeaveToday extends StatefulWidget {
  const OnLeaveToday({super.key});

  @override
  State<OnLeaveToday> createState() => _OnLeaveTodayState();
}

class _OnLeaveTodayState extends State<OnLeaveToday> {
  final EmployeeController _con = Get.put(EmployeeController());
  final AttendanceController _atCon = Get.put(AttendanceController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  String selectedOnLeaveDate = DateFormat('dd MMMM yyyy').format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 0,0,0)).toString();
  DateTime selectedInititalDateForPicker = DateTime.now();
  @override
  void initState() {
    _con.getEmployeeOnLeaveList();
    _atCon.attendanceTodays();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _con.getEmployeeOnLeaveList(true);
        _atCon.attendanceTodays(true);
      },
      color: Theme.of(context).primaryColor,
      backgroundColor: Colors.transparent,
      child: Scaffold(
          key: scaffoldKey,
          appBar: homeAppBar(scaffoldKey),
          // drawer: Drawer(
          //   child: ListView(
          //     padding: EdgeInsets.zero,
          //     children: <Widget>[
          //       const DrawerHeader(
          //         decoration: BoxDecoration(
          //           color: Colors.blue,
          //         ),
          //         child: Text(
          //           'Drawer Header',
          //           style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 24,
          //           ),
          //         ),
          //       ),
          //       ListTile(
          //         leading: const Icon(Icons.settings),
          //         title: const Text('Settings'),
          //         onTap: () {
          //           // Add your navigation logic here
          //           Navigator.pop(context); // Closes the drawer
          //         },
          //       ),
          //       ListTile(
          //         leading: const Icon(Icons.help),
          //         title: const Text('Help'),
          //         onTap: () {
          //           // Add your navigation logic here
          //           Navigator.pop(context); // Closes the drawer
          //         },
          //       ),
          //     ],
          //   ),
          // ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 28.h,
                ),
                //Greeting text
                Text(
                  "welcome".tr,
                  style: robotoWithColor(const Color(0xffB4B2B2), 16, 0.0),
                ),
                SizedBox(
                  height: 8.h,
                ),
                //User name
                Text(
                  read('loginInfo')['full_name']!,
                  style: roboto(22, 0.0),
                ),
                SizedBox(
                  height: 6.h,
                ),
                //Orginization Code
                Text(
                  read('loginInfo')['organization_code']!.toString().toUpperCase(),
                  style: roboto(14, 0.0, FontWeight.w300)
                ),
                SizedBox(
                  height: 20.h,
                ),
                //Todays Update Section
                todaysUpdateSection(),
                // SizedBox(
                //   height: 40.h,
                // ),
                // //Notice Seciton
                // noticeSection(),
                SizedBox(
                  height: 30.h,
                ),
                //Employee on leave today
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Obx(
                          ()=> _con.isOnLeaveLoading.value == true
                          ?Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: Text(
                              "${'employeeOnLeave'.tr}   ~",
                              style: notoSans(
                                Get.isDarkMode ? white : greyShade3,
                                17.0,
                                0.0
                              ),
                            ),
                          )
                          : Padding(
                            padding: EdgeInsets.only(left: 10.w),
                            child: Text(
                              "${'employeeOnLeave'.tr} (${_con.onLeaveList.length})",
                              style: notoSans(
                                Get.isDarkMode ? white : greyShade3,
                                17.0,
                                0.0
                              ),
                            ),
                          )
                        ),
                        SizedBox(
                          height: 7.h,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.w),
                          height: 2.h,
                          width: Get.locale!.languageCode == "en"
                              ? 108.w
                              : 98.w,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                    const Spacer(),
                    //Day
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 11.sp, vertical: 8.sp),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                            color: Get.isDarkMode
                                ? containerBorderDark
                                : containerBorderLight,
                            width: 1.2.sp),
                      ),
                      child: Text(DateFormat.E().format(selectedInititalDateForPicker), style: roboto(14, 0),),
                    ),
                    SizedBox(width: 8.w,),
                    InkWell(
                      onTap: (){
                        PickDate.datePicker(
                          context: context,
                          initialDate: selectedInititalDateForPicker,
                          maxYear: 3000,
                          minYear: 1999,
                          hideDay: false,
                          hideMonth: false,
                          hideYear: false,
                          displayFullMonthName: true,
                          showMonthsInNumber: false,
                          ymdFormat: false,
                          buttonText: "Submit",
                          buttonColor: red,
                          onDateSelected: (selectedDate, selectedTime) {
                            setState(() {
                              selectedOnLeaveDate = DateFormat('dd MMMM yyyy').format(DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 0,0,0)).toString();
                              _con.selectedLeaveDate = DateFormat('y-MM-dd').format(DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 0,0,0)).toString();
                              selectedInititalDateForPicker = selectedDate;
                            });
                            _con.getEmployeeOnLeaveListSwipe(null);
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 11.sp, vertical: 8.sp),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                              color: Get.isDarkMode
                                  ? containerBorderDark
                                  : containerBorderLight,
                              width: 1.2.sp),
                        ),
                        child: Text(
                          selectedOnLeaveDate,
                          style: roboto(14, 0.0),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12.h,
                ),
                Obx(() => _con.isOnLeaveLoading.value == true
                    ? Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                        ),
                        Center(
                          child: Obx(() => Visibility(
                            visible: _con.ptr.value == false,
                            child: const CircularProgressIndicator()
                          )),
                        ),
                      ],
                    )
                    : Container(
                      constraints: BoxConstraints(
                        maxHeight: 374.h,
                      ),
                      child: displayListType()
                    )
                )
              ],
            ),
          )),
    );
  }

  //todays update section
  todaysUpdateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "todayUpdate".tr,
              style: roboto(16, 0.0, FontWeight.w500),
            ),
            // const Spacer(),
            // InkWell(
            //   onTap: () {},
            //   child: Text(
            //     "View All",
            //     style: robotoWithColor(blue, 12, 0.0),
            //   )
            // ),
          ],
        ),
        //Today Updats tile
        SizedBox(
          height: 14.h,
        ),
        Obx(() => 
          _atCon.isLoading.value
            ? Visibility(
              visible: _atCon.ptr.value == false,
              child: const Center(child: CircularProgressIndicator())
            )
            : _atCon.attendanceToday == null
              ? Center(child: 
                Text(
                  "noAttendanceData".tr,
                  textAlign: TextAlign.center,
                )
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Present
                  TodaysUpdateTile(
                    icon: const Icon(
                      Icons.person,
                      color: green,
                    ),
                    title: "present".tr,
                    employeeCount: _atCon.attendanceToday.attendancePresent.toString(),
                    backgroundColor: lightGreen,
                    borderColor: green,
                  ),
                  //Absent
                  TodaysUpdateTile(
                    icon: const Icon(
                      Icons.person,
                      color: pink,
                    ),
                    title: "absent".tr,
                    employeeCount: _atCon.attendanceToday.attendanceAbsent.toString(),
                    backgroundColor: lightPink,
                    borderColor: pink,
                  ),
                  //Late
                  TodaysUpdateTile(
                    icon: const Icon(
                      Icons.timer,
                      color: yellow,
                    ),
                    title: "late".tr,
                    employeeCount: _atCon.attendanceToday.lateComers.toString(),
                    backgroundColor: lighrYellow,
                    borderColor: yellow,
                  ),
                ],
              )
        ),
      ],
    );
  }

  //notice section
  noticeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Notice",
              style: roboto(16, 0.0, FontWeight.w500),
            ),
            const Spacer(),
            InkWell(
                onTap: () {},
                child: Text(
                  "View All",
                  style: robotoWithColor(blue, 12, 0.0),
                )),
          ],
        ),
        SizedBox(
          height: 14.h,
        ),
        //Notice tiles
        ListView.separated(
          separatorBuilder: (context, index) => SizedBox(
            height: 8.h,
          ),
          itemCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return NoticeTile(
              title: index == 0 ? "Leave Notice" : "Client Meeting Notice",
              ontap: () {},
              statusColor: index == 0 ? pink : blue,
            );
          },
        ),
      ],
    );
  }

  displayListType() {
    return GestureDetector(
      onVerticalDragEnd: (details) {},
      onHorizontalDragEnd: (details) async {
        if(details.primaryVelocity! < 0) {
          var resp = await _con.getEmployeeOnLeaveListSwipe('next');
          if(resp != null) {
            selectedOnLeaveDate = DateFormat('dd MMMM yyyy').format(DateTime.parse(_con.selectedLeaveDate));
            selectedInititalDateForPicker = DateTime.parse(_con.selectedLeaveDate);
          }
        } else {
          var resp = await _con.getEmployeeOnLeaveListSwipe('prev');
          if(resp != null) {
            selectedOnLeaveDate = DateFormat('dd MMMM yyyy').format(DateTime.parse(_con.selectedLeaveDate));
            selectedInititalDateForPicker = DateTime.parse(_con.selectedLeaveDate);
          }
        }
        setState(() {});
      },
      child: _con.onLeaveList.isEmpty
          ? Container(
            height: Get.locale!.languageCode == "en" ? MediaQuery.of(context).size.height * 0.461 : MediaQuery.of(context).size.height * 0.453,
            color: Colors.transparent,
            alignment: Alignment.center,
            child: Text(
            'noneOnLeave'.tr,
            style: const TextStyle(fontSize: 16.0),
          ))
          : SizedBox(
            height: Get.locale!.languageCode == "en" ? MediaQuery.of(context).size.height * 0.461 : MediaQuery.of(context).size.height * 0.453,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _con.onLeaveList.length,
              itemBuilder: (ctx, index) {
                var emp = _con.onLeaveList[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 11.sp, vertical: 8.sp),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: Get.isDarkMode
                            ? containerBorderDark
                            : containerBorderLight,
                        width: 1.2.sp
                      ),
                    ),
                    child: Row(
                      children: [
                        viewImage(emp.profileImage),
                        const SizedBox(width: 8.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text('${emp.fullName}',
                                  style: roboto(14, 0.0, FontWeight.bold)),
                            ),
                            SizedBox(
                                width: 130.w,
                                child: Text(
                                  "${emp.leaveCategory}",
                                  style: robotoWithColor(
                                      green, 12, 0.5, FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )),
                            SizedBox(
                              height: 6.h,
                            ),
                            Container(
                                constraints: BoxConstraints(
                                  minHeight: 12.0.h,
                                  maxHeight: 25.0.h,
                                ),
                                width: MediaQuery.of(context).size.width * 0.65,
                                child: Text(
                                  "${emp.leaveReason}",
                                  style: robotoWithColor(grey, 12, 0.5),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )),
                            SizedBox(
                              height: 6.h,
                            ),
                            SizedBox(
                                width: 100.w,
                                child: Text(
                                  "${emp.leaveDayName}",
                                  style: roboto(12, 0.5, FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
    );
  }

  Widget viewImage(imgUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100.r),
      child: DisplayNetworkImage(imageUrl: imgUrl, height: 60.0, width: 60.0),
    );
  }
}
