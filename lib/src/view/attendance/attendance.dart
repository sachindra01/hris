import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hris/src/controller/app_controller.dart';
import 'package:hris/src/controller/attendance_controller.dart';
import 'package:hris/src/helper/style.dart';
import 'package:hris/src/helper/validations.dart';
import 'package:hris/src/widgets/custom_button.dart';
import 'package:hris/src/widgets/custom_text_field.dart';
import 'package:intl/intl.dart';
import 'package:hris/src/helper/read_write.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  final AttendanceController _con = Get.put(AttendanceController());
  final AppController appCon = Get.put(AppController());
  
  //initial filter dates
  String finalSelectedYear = DateTime.now().year.toString();
  String finalSelectedNepaliYear = NepaliDateTime.now().year.toString();
  String selectedYear = DateTime.now().year.toString();
  String selectedNepaliYear = NepaliDateTime.now().year.toString();
  String selectedMonth = DateTime.now().month.toString();
  String selectedNepaliMonth = NepaliDateTime.now().month.toString();
  String finalSelectedMonth = DateTime.now().month.toString();
  String finalSelectedNepaliMonth = NepaliDateTime.now().month.toString();
  String finalSelectedMonthText = DateFormat.MMM().format(DateTime.now()).toString();
  String finalSelectedMonthNepaliText = NepaliDateFormat.MMMM().format(NepaliDateTime.now()).toString();
  String selectedMonthText = DateFormat.MMM().format(DateTime.now()).toString();
  String selectedMonthNepaliText = NepaliDateFormat.MMMM().format(NepaliDateTime.now()).toString();
  //To get date in nepali do NepaliDateFormat.MMMM(Language.nepali).format(NepaliDateTime.now()).toString();

  final TextEditingController lateCon = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _con.getAttendanceList(null, null, null, read('datePref') == "" || read('datePref') == null ? 'ad' : read('datePref').toString().toLowerCase());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _con.getAttendanceList(true, null, null, read('datePref') == "" || read('datePref') == null ? 'ad' : read('datePref').toString().toLowerCase()),
      color: Theme.of(context).primaryColor,
      backgroundColor: Colors.transparent,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 26.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Page Heading
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: Text(
                          "attendance".tr,
                          style: notoSans(Get.isDarkMode ? white : greyShade3, 17.0, 0.0),
                        ),
                      ),
                      SizedBox(
                        height: 7.h,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10.w),
                        height: 2.h,
                        width: Get.locale!.languageCode == "en" ? 91.w : 43.w,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                  //Attendance Date Filter
                  InkWell(
                    onTap: (){
                      read('datePref') == "" || read('datePref') == "AD" || read('datePref' ) == null
                      ? englishYearMonthPicker() 
                      : nepaliYearMonthPicker();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal : 11.sp, vertical: 8.sp),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Get.isDarkMode ? containerBorderDark : containerBorderLight, width: 1.2.sp),
                      ),
                      child: Text(read('datePref') == "" || read('datePref') == "AD" || read('datePref' ) == null
                        ?"$finalSelectedMonthText $finalSelectedYear" 
                        : "$finalSelectedNepaliYear $finalSelectedMonthNepaliText" , 
                        style: roboto(14, 0.0),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 12.h,
              ),
              //Body
              Obx(() => _con.isLoading.value == true
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
                : _con.attendance.isEmpty
                  ? const Expanded(
                    child: Center(
                      child: Text(
                        'No attendance for this month'
                      ),
                    ),
                  )
                  : Expanded(child: attendanceList()),
              ),
            ],
          ),
        )
      ),
    );
  }

  //LeaveListTile
  attendanceList() {
    return ListView.builder(
      itemCount: _con.attendance.length,
      itemBuilder: (ctx, index) {
        var attendance = _con.attendance[index];
        return Padding(
          padding: EdgeInsets.only(top: 10.0.h),
          child: InkWell(
            onTap : () {
              if(attendance.employeeRemarks == "" && _con.checkIfLate(attendance.checkinTime)) {
                if(attendance.adminRemarks == '') {
                  setState(() {
                    lateCon.text = attendance.lateReason;
                  });
                  openLateReasonDialog(attendance.id, context);
                }
              } 
            },
            //Attendance Tile
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 8.h),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      //Date and Day in words
                      viewDate(
                        read('datePref') == "" || read('datePref') == "AD" || read('datePref' ) == null
                        ? attendance.checkoutDateAd
                        : attendance.checkoutDateBs
                      ),
                      SizedBox(width:5.0.w),
                      //On Absent
                      attendance.absent
                        ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Absent', 
                                style: robotoWithColor(red, 16, 0.0, FontWeight.bold)
                              ),
                              Text(
                                'Reason : ${attendance.leaveReason}', 
                                style: roboto(14, 0.0, FontWeight.normal)
                              ),
                            ],
                          ),
                        )
                        : 
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Check In & Check Out section
                          Container(
                            width: 252.w,
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                //Check In
                                Row(
                                  children: [
                                    Text("IN  ", style: robotoWithColor(_con.checkIfLate(attendance.checkinTime) ? yellow : null, 14, 0.5),),
                                    SizedBox(
                                      width: 58.w,
                                      child: Text(
                                        "${attendance.checkinTime.split(':').sublist(0, 2).join(' : ')}", 
                                        style: robotoWithColor(_con.checkIfLate(attendance.checkinTime) ? yellow : null, 15.5, 0.0, FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 25.h,
                                  child: VerticalDivider(
                                    color: Theme.of(context).dividerColor,
                                    thickness: 0.8,
                                  ),
                                ),
                                //Check Out
                                Padding(
                                  padding: EdgeInsets.only(left : 14.0.w),
                                  child: Row(
                                    children: [
                                      Text("OUT  ", style: roboto(14, 0.5),),
                                      SizedBox(
                                        width: 58.w,
                                        child: Text(
                                          "${attendance.checkoutTime.split(':').sublist(0, 2).join(' : ')}", 
                                          style: roboto(15.5, 0.0, FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 6.h,),
                          //Total Hours
                          Container(
                            width: 252.w,
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 58.w,
                                  child: Text(
                                    attendance.attendanceTime.replaceAll('.',':'),
                                    style: _con.checkIfLessWorkingHorus(attendance.attendanceTime)
                                      ? robotoWithColor(yellow, 16, 0.0, FontWeight.bold)
                                      : roboto(16, 0.0, FontWeight.bold)
                                  )
                                ),
                                const Spacer(),
                                attendance.employeeRemarks == "" && _con.checkIfLate(attendance.checkinTime)
                                ? SizedBox(
                                  width: 100.w,
                                  child: Text("Enter Late Reason", style: robotoWithColor(red, 12, 0.0),)
                                )
                                : const SizedBox()
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  attendance.breaktime == null 
                  ? const SizedBox() 
                  : SizedBox(height: 5.h,),
                  //List of Breaks
                  ListView.builder(
                    itemCount: attendance.breaktime == null ? 0 : attendance.breaktime.length,
                    shrinkWrap: true,
                    itemBuilder: (context, idx){
                    if(attendance.breaktime != null){
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(
                          //   '${idx == 0 
                          //     ? "Break Time : "
                          //     : idx == 1 
                          //       ? "Lunch Break : " 
                          //       : "Evening Break : "} ${attendance.breaktime[idx].breakIn} - ${attendance.breaktime[idx].breakOut}',
                          //   style: roboto(13, 0.0, FontWeight.bold),
                          // ),
                          Row(
                            children: [
                              idx == 0
                                ? Text(
                                  "Break Time : ",
                                  style: roboto(13, 0.0, FontWeight.bold)
                                )
                                : const SizedBox(width: 84.0),
                              SizedBox(width: 12.0.r),
                              Row(
                                children: [
                                  Text(
                                    '${attendance.breaktime[idx].breakIn}',
                                    style: roboto(13, 0.0, FontWeight.bold)
                                  ),
                                  SizedBox(
                                    width: 100.w,
                                  ),
                                  Text(
                                    '${attendance.breaktime[idx].breakOut}',
                                    style: roboto(13, 0.0, FontWeight.bold)
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 5.h),
                        ],
                      );
                    } else{
                      return const SizedBox();
                    }
                  }),
                  //Late Reason if any
                  Visibility(
                    visible: attendance.employeeRemarks != '',
                    child: Column(
                      children: [
                        SizedBox(height: 13.0.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Late Reason",
                              style: roboto(13, 0.0, FontWeight.w400)
                            ),
                            Text(
                              '${attendance.employeeRemarks}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: roboto(12, 0.0, FontWeight.w300)
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: attendance.adminRemarks != '',
                    child: Column(
                      children: [
                        SizedBox(height: 13.0.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Admin Remarks",
                              style: roboto(13, 0.0, FontWeight.w400)
                            ),
                            Text(
                              '${attendance.adminRemarks}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: roboto(12, 0.0, FontWeight.w300)
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  viewDate(fullDate) {
    String date = DateFormat('d').format(DateTime.parse(fullDate));
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        height: read('datePref') == "" || read('datePref') == "AD" || read('datePref' ) == null ? 50.h : 52.h,
        width: 40.w,
        color: grey500,
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              Text(
                date,
                textAlign: TextAlign.center,
                style: roboto(16.0, 0.0)
              ),
              Text(
                appCon.getDayInWord(fullDate, read("datePref")),
                textAlign: TextAlign.center,
                style: roboto(10.0, 0.0)
              ),
            ],
          ),
        ),
      ),
    );
  }

  openLateReasonDialog(int id, BuildContext context) {
    return Get.defaultDialog(
      title: 'Add Late Reason',
      contentPadding: REdgeInsets.all(15.sp),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: lateCon,
              maxLines: 5,
              hintText: "Late Reason",
              textInputAction: TextInputAction.newline,
              keyboardType: TextInputType.multiline,
              autoValidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => Validations.limit255(value),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
            ),
            SizedBox(height: 20.h,),
            //Submit Button
            CustomButton(
              onPressed: () async {
                final isValid = _formKey.currentState!.validate();
                if (!isValid) return;
                var success = await _con.addLateReason(id, lateCon.text, context);
                if(success == true) lateCon.clear();
              },
              text: "Submit",
            ),
          ],
        ),
      )
    );
  } 

  //Cupertino Eng Date Picker
  englishYearMonthPicker() {
    int selectedYear1 = DateTime.now().year;
    int selectedMonth1 = DateTime.now().month;
    String selectedMonthText1 = DateFormat.MMM().format(DateTime.now()).toString();

    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final List<Map<String, dynamic>> months = [
          {"name": "Jan", "value": 1},
          {"name": "Feb", "value": 2},
          {"name": "Mar", "value": 3},
          {"name": "Apr", "value": 4},
          {"name": "May", "value": 5},
          {"name": "Jun", "value": 6},
          {"name": "Jul", "value": 7},
          {"name": "Aug", "value": 8},
          {"name": "Sep", "value": 9},
          {"name": "Oct", "value": 10},
          {"name": "Nov", "value": 11},
          {"name": "Dec", "value": 12},
        ];

        return Container(
          color: Theme.of(context).cardColor,
          height: MediaQuery.of(context).size.height * 0.36,
          child: Column(
            children: [
              // Select Year and Month
              Expanded(
                child: Row(
                  children: [
                    // Year
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: int.parse(finalSelectedYear) - 2000),
                        onSelectedItemChanged: (selectedItem) {
                          selectedYear1 = 2000 + selectedItem;
                        },
                        backgroundColor: Theme.of(context).cardColor,
                        itemExtent: 40,
                        children: List<Widget>.generate(
                          DateTime.now().year - 2000 + 1,
                          (index) => Center(
                            child: Text(
                              '${2000 + index}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Month
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: int.parse(finalSelectedMonth) - 1),
                        onSelectedItemChanged: (selectedItem) {
                          selectedMonth1 = months[selectedItem]['value'];
                          selectedMonthText1 = months[selectedItem]['name'];
                        },
                        backgroundColor: Theme.of(context).cardColor,
                        itemExtent: 40,
                        children: List<Widget>.generate(
                          12,
                          (index) => Center(
                            child: Text(
                              months[index]['name'],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              // Select Button
              CustomButton(
                text: 'select'.tr,
                height: 40,
                onPressed: () {
                  setState(() {
                    finalSelectedYear = selectedYear1.toString(); 
                    finalSelectedMonth = selectedMonth1.toString();
                    finalSelectedMonthText = selectedMonthText1;
                  });
                  _con.getAttendanceList(null, finalSelectedYear, finalSelectedMonth, "ad");
                  Get.back();
                },
              ),
              SizedBox(height: 30.h),
            ],
          ),
        );
      },
    );
  }

  //Cupertino Nepali Date picker
  nepaliYearMonthPicker(){
    int selectedYear1 = NepaliDateTime.now().year;
    int selectedMonth1 = NepaliDateTime.now().month;
    String selectedMonthText1 = NepaliDateFormat.MMMM().format(NepaliDateTime.now()).toString();

    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final List<Map<String, dynamic>> months = [
          // {"name": "बैशाख", "value": 1},      
          // {"name": "जेष्ठ", "value": 2},      
          // {"name": "असार", "value": 3},      
          // {"name": "श्रावण", "value": 4},      
          // {"name": "भाद्र", "value": 5},      
          // {"name": "असोज", "value": 6},      
          // {"name": "कार्तिक", "value": 7},      
          // {"name": "मंसिर", "value": 8},      
          // {"name": "पुष", "value": 9},      
          // {"name": "माघ", "value": 10},      
          // {"name": "फागुन", "value": 11},      
          // {"name": "चैत्र", "value": 12},

          //In eng
          // {"name": "Bai", "value": 1},      
          // {"name": "Jes", "value": 2},      
          // {"name": "Asar", "value": 3},      
          // {"name": "Shr", "value": 4},      
          // {"name": "Bha", "value": 5},      
          // {"name": "Ash", "value": 6},      
          // {"name": "Kar", "value": 7},      
          // {"name": "Marg", "value": 8},      
          // {"name": "Pou", "value": 9},      
          // {"name": "Mag", "value": 10},      
          // {"name": "Fal", "value": 11},      
          // {"name": "Cha", "value": 12},

          //Nepali month Full
          {"name": "Baishakh", "value": 1},      
          {"name": "Jestha", "value": 2},      
          {"name": "Ashadh", "value": 3},      
          {"name": "Shrawan", "value": 4},      
          {"name": "Bhadra", "value": 5},      
          {"name": "Ashwin", "value": 6},      
          {"name": "Kartik", "value": 7},      
          {"name": "Mangsir", "value": 8},      
          {"name": "Poush", "value": 9},      
          {"name": "Magh", "value": 10},      
          {"name": "Falgun", "value": 11},      
          {"name": "Chaitra", "value": 12}, 
        ];
        return Container(
          color: Theme.of(context).cardColor,
          height: MediaQuery.of(context).size.height * 0.36,
          child: Column(
            children: [
              // Select Year and Month
              Expanded(
                child: Row(
                  children: [
                    // Year
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: int.parse(finalSelectedNepaliYear) - 2000),
                        onSelectedItemChanged: (selectedItem) {
                          selectedYear1 = 2000 + selectedItem;
                        },
                        backgroundColor: Theme.of(context).cardColor,
                        itemExtent: 40,
                        children: List<Widget>.generate(
                          NepaliDateTime.now().year - 2000 + 1,
                          (index) => Center(
                            child: Text(
                              '${2000 + index}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Month
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: int.parse(finalSelectedNepaliMonth) - 1),
                        onSelectedItemChanged: (selectedItem) {
                          selectedMonth1 = months[selectedItem]['value'];
                          selectedMonthText1 = months[selectedItem]['name'];
                        },
                        backgroundColor: Theme.of(context).cardColor,
                        itemExtent: 40,
                        children: List<Widget>.generate(
                          12,
                          (index) => Center(
                            child: Text(
                              months[index]['name'],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              // Select Button
              CustomButton(
                text: 'select'.tr,
                height: 40,
                onPressed: () {
                  setState(() {
                    finalSelectedNepaliYear = selectedYear1.toString(); 
                    finalSelectedNepaliMonth = selectedMonth1.toString();
                    finalSelectedMonthNepaliText = selectedMonthText1;
                  });
                  _con.getAttendanceList(null, finalSelectedNepaliYear, finalSelectedNepaliMonth, "bs");
                  Get.back();
                },
              ),
              SizedBox(height: 30.h),
            ]
          ),
        );
      },
    );
  }
}