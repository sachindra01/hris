import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:get/get.dart";
import "package:hris/src/controller/auth_controller.dart";
import "package:hris/src/controller/employee_controller.dart";
import "package:hris/src/controller/leave_controller.dart";
import "package:hris/src/helper/convert_date.dart";
import "package:hris/src/helper/read_write.dart";
import "package:hris/src/helper/style.dart";
import "package:hris/src/helper/validations.dart";
import "package:hris/src/model/leave_list_model.dart";
import "package:hris/src/model/profile_model.dart";
import "package:hris/src/widgets/cached_network_image.dart";
import "package:hris/src/widgets/custom_alert_dialog.dart";
import "package:hris/src/widgets/custom_appbar.dart";
import "package:hris/src/widgets/custom_button.dart";
import "package:hris/src/widgets/custom_dropdown.dart";
import "package:hris/src/widgets/custom_text_field.dart";
import "package:hris/src/widgets/show_message.dart";
import "package:intl/intl.dart";
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:nepali_date_picker/nepali_date_picker.dart';

class LeaveForm extends StatefulWidget {
  final bool? update;
  final List<Datum>? userData;
  final List? leaveApproverNameList;
  final List? leaveApproverIdList;
  const LeaveForm({super.key, this.update, this.userData, this.leaveApproverNameList, this.leaveApproverIdList});

  @override
  State<LeaveForm> createState() => _LeaveFormState();
}

class _LeaveFormState extends State<LeaveForm> with SingleTickerProviderStateMixin{
  //Tab Controller
  late final TabController tabController;

  //Form Key
  final _formKey = GlobalKey<FormState>();

  //Text Controllers
  final TextEditingController leaveCategoryController = TextEditingController();
  final TextEditingController leaveDaysController = TextEditingController();
  final TextEditingController noOfDaysController = TextEditingController();
  final TextEditingController leaveReason = TextEditingController();
  final TextEditingController fromDate = TextEditingController();
  final TextEditingController toDate = TextEditingController();
  final TextEditingController approverName = TextEditingController();

  //Variable for storing data that will be sent to Api
  String approverId = "";
  String leaveDayCode = "";
  List addApproverName = [""];
  List addApproverNameChip = [];
  List approverIdList = [];

  // create a list of controllers for each text field
  // List<DropdownEditingController<Map<String, dynamic>>> approverDropDownController = [];

  //Get Controller
  final AuthController _authCon = Get.put(AuthController());
  final LeaveController _leaveCon = Get.put(LeaveController());
  final EmployeeController _employeeCon = Get.put(EmployeeController());

  //Profile Data
  late ProfileModel profileData;

  //Drop DownList
  List<Map<String, dynamic>> employeeList = [];
  List<Map<String, dynamic>> leaveCategoryList = [];
  List<Map<String, dynamic>> leaveDaysList = [];

  //bool check for checkbox
  bool isAD = true;
  bool isBS = false;
  String finalFromDateInAD = "";
  String finalFromDateInBS = "";
  String finalToDateInAD = "";
  String finalToDateInBS = "";

  //Store value to know if leave days and catedory is selected from dropdown
  var selectedLeaveDay = "";
  var selectedLeaveDayCode = "";
  var selectedLeaveCategory = "";
  var selectedNoOfDays = "";

  //To calculate no.of days from from and to date
  dynamic calcFromDate = "";
  dynamic calcToDate = "";

  //Select initial Leave category Index
  leaveCategoryInitialIndex(){
    for (int i=0; i<leaveCategoryList.length;i++) {
      if (leaveCategoryList[i]["name"] == leaveCategoryController.text) {
        return i; 
      }
    }
  }

  //Select initial Leave category Index
  leaveDaysInitialIndex(){
    for (int i=0; i<leaveDaysList.length;i++) {
      if (leaveDaysList[i]["name"] == leaveDaysController.text) {
        return i; 
      }
    }
  }

  @override
  void initState() {
    if(mounted){
      tabController = TabController(length: 1, vsync: this);
      tabController.addListener(() { 
        setState(() {});
      });
      if(widget.update == true){
        updateForm();
      } else{
        initializedData();
      }
    }
    super.initState();
  }

  initializedData() async{
    // //Generate text controllers for every form added
    // approverDropDownController = List.generate(
    //   addApproverName.length,
    //   (_) => DropdownEditingController<Map<String, dynamic>>(),
    // );

    //Get necessary data
    await getNecessaryData();

    //initial values in dropdown
    if(leaveCategoryList.isNotEmpty && leaveDaysList.isNotEmpty){
      leaveCategoryController.text = await leaveCategoryList[0]["name"] ?? "";
      leaveDaysController.text = await leaveDaysList[0]["name"] ?? "";
      leaveDayCode = await leaveDaysList[0]["code"] ?? "";
      noOfDaysController.text = await leaveDaysList[0]["noOfDays"] ?? "";
    }
  }

  //Update Leavefrom
  updateForm() async{
    leaveCategoryController.text = widget.userData![0].leaveCategoryName.toString();
    leaveDaysController.text = widget.userData![0].leaveDayName.toString();
    noOfDaysController.text = widget.userData![0].noOfDays.toString();
    leaveReason.text = widget.userData![0].remarks.toString();
    addApproverNameChip = widget.leaveApproverNameList ?? [];
    leaveDayCode = widget.userData![0].leaveDayCode.toString();
    approverIdList = widget.leaveApproverIdList ?? [];
    for(var list in widget.userData![0].approverList as List){
      addApproverNameChip.add(
        {
          "name" : list.approverName,
          "role" : list.role ?? "N/A",
          "approverImage" : list.approverImage ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTcZHZkZFOA8sW0MCEom45CGwmnJdl-RsK5n6-vEbSyqcYBvLBwkLTaYB8gjBXAO9ABhVs&usqp=CAU",
        }
      );
      approverIdList.add({"approver_id": list.approverId.toString()});
    }
    fromDate.text = widget.userData![0].leaveFromAd.toString();
    toDate.text = widget.userData![0].leaveToAd.toString();
    finalFromDateInAD = widget.userData![0].leaveFromAd.toString();
    finalToDateInAD = widget.userData![0].leaveToAd.toString();
    finalFromDateInBS = NepaliDateFormat('yyyy-MM-dd').format(DateTime(int.parse(widget.userData![0].leaveFromAd!.split("-")[0]), int.parse(widget.userData![0].leaveFromAd!.split("-")[1]), int.parse(widget.userData![0].leaveFromAd!.split("-")[2])).toNepaliDateTime());
    finalToDateInBS = NepaliDateFormat('yyyy-MM-dd').format(DateTime(int.parse(widget.userData![0].leaveToAd!.split("-")[0]), int.parse(widget.userData![0].leaveToAd!.split("-")[1]), int.parse(widget.userData![0].leaveToAd!.split("-")[2])).toNepaliDateTime());
    calcFromDate = DateTime.parse(widget.userData![0].leaveFromAd.toString());
    calcToDate = widget.userData![0].leaveToAd == null || widget.userData![0].leaveToAd =="" ? "" : DateTime.parse(widget.userData![0].leaveToAd.toString());
    // approverName.text = widget.userData![0].noOfDays.toString();

    //Get necessary data
    await getNecessaryData();
    if(mounted) setState(() {});
  }

  //Get necessary data
  getNecessaryData() async{
    _leaveCon.isLoading(true);

    var employeeData = await _employeeCon.getEmployeeListOnline();
    var leaveCategory = await _leaveCon.getLeaveCategory();
    var leaveDays = await _leaveCon.getLeaveDays();
    var reportToInfo = await _authCon.getProfileData();
    profileData = await _authCon.getProfileData();

    if(widget.update == null || widget.update == false){
      if(reportToInfo.reportsTo != null) {
        //Initial Report to ids
        approverIdList.add(
          {"approver_id" :  reportToInfo.reportsTo.id}
        );
        //Initial Report to Name
        addApproverNameChip.add(
          {
            "name" :  reportToInfo.reportsTo.fullName,
            "role" : reportToInfo.reportsTo.roleName,
            "approverImage" : reportToInfo.reportsTo.profileImageUrl,
          }
        );
      }
    }

    //For Employee
    for(var employee in employeeData.data){
      employeeList.add(
          {
          "name" : employee.fullName,
          "id" : employee.id,
          "role" : employee.roleName,
          "approverImage" : employee.profileImageUrl,
          }
      );
    }
    
    //For LeaveCategory & Leave Days
    if(leaveCategory != null && leaveDays != null ){
      //For LeaveCategory
      for(var data in leaveCategory.data){
        leaveCategoryList.add(
          {
            "name" : data.name,
            "nameNp" : data.nameNp,
            // "id" : data.id,
            "code" : data.code,
            "noOfDays" : data.noOfDays.toString(),
          }
        );
      }

      //For LeaveDays
      for(var data in leaveDays.data){
        leaveDaysList.add(
            {
            "name" : data.name,
            "id" : data.id,
            "code" : data.code,
            "description" : data.description,
            "nameNp" : data.nameNp,
            "noOfDays" : data.noOfDays
            }
        );
      }
    }
    
    _leaveCon.isLoading(false);
  }

  @override
  void dispose() {
    tabController.dispose();
    leaveCategoryController.dispose();
    leaveDaysController.dispose();
    noOfDaysController.dispose();
    leaveReason.dispose();
    fromDate.dispose();
    toDate.dispose();
    approverName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        context, 
        "leaveForm".tr,
        GestureDetector(
          onTap: ()=> Navigator.pop(context),
          child: Icon(
            Icons.arrow_back, color: Get.isDarkMode ? white : black,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            //Leave Form
            SingleChildScrollView(
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                child: Obx(() => 
                  _leaveCon.isLoading.value == true 
                    ? SizedBox(
                      height: MediaQuery.of(context).size.height - kToolbarHeight,
                      child: const Center(
                        child: CircularProgressIndicator()
                      ),
                    )
                    : Form(
                      key: _formKey,
                      child: Column(
                        children: [
                        //Employee Selection
                        Visibility(
                          visible: profileData.data!.roleName.toString() == "admin" || profileData.data!.roleName.toString() == "Team Leader",
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              employeeSelection(),
                              SizedBox(height: 12.h,),
                            ],
                          ),
                        ),
                        //Approver Seletion
                        approverSection(),
                        SizedBox(height: 12.h,),
                        //Leave Form Section
                        leaveForm(),
                        SizedBox(height: 30.h,),
                        // //Submit Button
                        // widget.update != true
                        // ? submitButton()
                        // : updateButton(),
                        SizedBox(height: 120.h,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //Buttons
            Obx(() => 
             _leaveCon.isLoading.value == true 
              ? const SizedBox()
              : Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  height: 90.h,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Submit Button
                      widget.update != true
                      ? submitButton()
                      : updateButton(),
                    ]
                  ),
                ),
              )
            )
          ],
        ),
      ),
    );
  }

  //leave form
  leaveForm (){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h,),
        //Leave Category
        CustomTextField(
          width: 400.w,
          onTap: (){
            selectedLeaveCategory = leaveCategoryController.text;
            selectedNoOfDays = noOfDaysController.text;
            if(leaveCategoryList.isNotEmpty){
              leaveCategoryDropDown();
            } else{
              showMessage("Denied", "No leave assigned");
            }
          },
          controller: leaveCategoryController,
          labelText: "leaveCategory".tr,
          readOnly: true,
          suffixIcon:  const Icon(Icons.expand_more_rounded, color: grey,),
          validator: (leaveCat) {
            return leaveCat == null || leaveCat.isEmpty ? 'Select a category.' : null;
          },
        ),
        SizedBox(height: 10.h,),
        //Leave Days
        CustomTextField(
          width: 400.w,
          onTap: () {
            selectedNoOfDays = noOfDaysController.text;
            selectedLeaveDay = leaveDaysController.text;
            selectedLeaveDayCode = leaveDayCode;
            if(leaveDaysList.isNotEmpty && leaveDaysController.text != ""){
              leaveDaysSelectionSheet();
            } else{
              showMessage("Denied", "No leave assigned");
            }
          },
          controller: leaveDaysController,
          readOnly: true,
          labelText: "leaveDays".tr,
          suffixIcon:  const Icon(Icons.expand_more_rounded, color: grey,),
          validator: (leaveDay) {
            return leaveDay == null || leaveDay.isEmpty ? 'Leave day must be selected.' : null;
          },
        ),
        SizedBox(height: 12.h,),
        //Select Date Type
        selectDateType(),
        //From and To date
        // leaveDaysController.text == "Full Day"
        leaveDayCode == "Full Day"
        ?fromAndToDate()
        :fromDateOnly(),
        SizedBox(height: 12.h,),
        //No. of days
         noOfDaysController.text == "" 
         ? const SizedBox()
         :Row(
          children: [
            Text("No. of Days:", style: roboto(14, 0.0)),
            SizedBox(width: 5.w,),
            Text(_leaveCon.decimalChecker(noOfDaysController.text),  style: roboto(16, 0.0, FontWeight.bold, 1.0)),
            SizedBox(width: 1.w,),
            Text("days",style: roboto(14, 0.0)),
          ],
        ),
        SizedBox(height: 22.h,),
        //Leave Reason
        CustomTextField(
          width: 400.w,
          onTap: (){},
          controller: leaveReason,
          labelText: "leaveReason".tr,
          hintText: "leaveReason".tr,
          maxLines: 5,
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.multiline,
          validator: (leaveReasons) => Validations.limit255(leaveReasons, "Leave Reason Cannot be empty"),
        ),
      ],
    );
  }

  //leave category selection sheet
  leaveCategoryDropDown(){
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: white,
          height: MediaQuery.of(context).size.height*0.3,
          child: Column(
            children: [
              Container(
                color: lightGrey.withOpacity(0.2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MaterialButton(
                      child: Text("Cancel",style: robotoWithColor(grey, 16.0, 0.0),),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                    MaterialButton(
                      child: Text("Done",style: robotoWithColor(grey, 16.0, 0.0),),
                      onPressed: (){
                        if(leaveCategoryController.text == ''){
                          setState(() {
                            leaveCategoryController.text = leaveCategoryList[0]["name"];
                          });
                        } else{
                          setState(() {
                            leaveCategoryController.text = selectedLeaveCategory;
                            noOfDaysController.text = selectedNoOfDays;
                          });
                        }
                        Navigator.pop(context);
                      },
                    )
                  ]
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: leaveCategoryInitialIndex()
                  ),
                  onSelectedItemChanged: (value) {
                    setState(() {
                      selectedLeaveCategory = leaveCategoryList[value]["name"];
                      // selectedNoOfDays = leaveCategoryList[value]["noOfDays"];
                    });
                  },
                  itemExtent: 40.sp,
                  children: leaveCategoryList.map((value) => Center(child: Text(value["name"],style: robotoWithColor(black, 16.0, 0.0),))).toList(),
                ),
              )
            ],
          ),
        );
      }
    );
  }

  //leave Days selection sheet
  leaveDaysSelectionSheet(){
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: white,
          height: MediaQuery.of(context).size.height*0.3,
          child: Column(
            children: [
              Container(
                color: lightGrey.withOpacity(0.2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MaterialButton(
                      child: Text("Cancel",style: robotoWithColor(grey, 16.0, 0.0),),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                    MaterialButton(
                      child: Text("Done",style: robotoWithColor(grey, 16.0, 0.0),),
                      onPressed: (){
                        if(leaveDaysController.text == ''){
                          setState(() {
                            leaveDaysController.text = leaveDaysList[0]["name"];
                          });
                        } else{
                          setState(() {
                            leaveDaysController.text = selectedLeaveDay;
                            leaveDayCode = selectedLeaveDayCode;
                            noOfDaysController.text = selectedNoOfDays;
                            if(noOfDaysController.text != "1"){
                              finalToDateInAD = "";
                              toDate.clear();
                              finalToDateInBS = "";
                            }
                          });
                        }
                        Navigator.pop(context);
                      },
                    )
                  ]
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(
                    initialItem: leaveDaysInitialIndex()
                  ),
                  onSelectedItemChanged: (value) {
                    setState(() {
                      selectedLeaveDay = leaveDaysList[value]["name"];
                      selectedLeaveDayCode = leaveDaysList[value]["code"] ?? leaveDaysList[0]["code"];
                      selectedNoOfDays = leaveDaysList[value]["noOfDays"] ?? leaveDaysList[0]["noOfDays"];
                    });
                  },
                  itemExtent: 40.sp,
                  children: leaveDaysList.map((value) => Center(child: Text(value["name"],style: robotoWithColor(black, 16.0, 0.0),))).toList(),
                ),
              )
            ],
          ),
        );
      }
    );
  }

  //Select Date type (AD/ BS)
  selectDateType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            //For AD
            Checkbox(
              activeColor: pink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0.r),
              ),
              side: MaterialStateBorderSide.resolveWith(
                (states) => const BorderSide(width: 1, color: pink),
              ),
              value: isAD,
              onChanged:(val) {
                FocusManager.instance.primaryFocus?.unfocus();
                setState(() {
                  isBS = false;
                  isAD = true;
                  //Set to and from date
                  if(finalFromDateInAD != "" && finalFromDateInBS != ""){
                    fromDate.text = finalFromDateInAD;
                  }
                  if(finalToDateInAD != "" && finalToDateInBS != ""){
                    toDate.text = finalToDateInAD;
                  }
                  // finalFromDateInAD = "";
                  // finalToDateInAD = "";
                  // fromDate.clear;
                  // fromDate.text = "";
                  // toDate.clear;
                  // toDate.text = "";
                });
              }
            ),
            Text("A.D", style: poppins(15, 0.0),),
            SizedBox(width: 16.w,),
            //For BS
            Checkbox(
              activeColor: pink,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0.r),),
              side: MaterialStateBorderSide.resolveWith(
                (states) => const BorderSide(width: 1, color: pink),
              ),
              value: isBS,
              onChanged:(val) {
                FocusManager.instance.primaryFocus?.unfocus();
                setState(() {
                  isAD = false;
                  isBS = true;
                  //Set to and from date
                  if(finalFromDateInAD != "" && finalFromDateInBS != ""){
                    fromDate.text = finalFromDateInBS;
                  }
                  if(finalToDateInAD != "" && finalToDateInBS != ""){
                    toDate.text = finalToDateInBS;
                  }
                  // finalFromDateInAD = "";
                  // finalToDateInAD = "";
                  // fromDate.clear;
                  // fromDate.text = "";
                  // toDate.clear;
                  // toDate.text = "";
                });
              }
            ),
            Text("B.S", style: poppins(15, 0.0),),
          ],
        )
      ],
    );
  }

  //FromDate only
  fromDateOnly(){
    return CustomTextField(
      width: 160.w,
      onTap: ()=> pickDate("from", convertedDate(fromDate.text)),
      controller: fromDate,
      readOnly: true,
      keyboardType: TextInputType.number,
      labelText: "from".tr,
      suffixIcon:  const Icon(Icons.calendar_month, color: pink,),
      validator: (fromDate) {
        return fromDate == null || fromDate.isEmpty ? 'From Date cannot be empty.' : null;
      },
    );
  }

  //From and to Date
  fromAndToDate(){
    return SizedBox(
      height: 100.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //From
          CustomTextField(
            width: 155.w,
            onTap: ()=> pickDate("from", convertedDate(fromDate.text)),
            controller: fromDate,
            readOnly: true,
            keyboardType: TextInputType.number,
            labelText: "from".tr,
            suffixIcon:  const Icon(Icons.calendar_month, color: pink,),
            validator: (fromDate) {
              return fromDate == null || fromDate.isEmpty ? 'From Date cannot be empty.' : null;
            },
          ),
          //To
          CustomTextField(
            width: 155.w,
            onTap: ()=> pickDate("to", convertedDate(toDate.text)),
            controller: toDate,
            readOnly: true,
            keyboardType: TextInputType.number,
            labelText: "to".tr,
            suffixIcon:  const Icon(Icons.calendar_month, color: pink,),
            validator: (toDate) {
              return toDate == null || toDate.isEmpty ? 'To Date cannot be empty.' : null;
            },
          ),
        ],
      ),
    );
  }

  //Date Picker English
  pickDate(type, initialDate) async{
    //-----For Selecting Date in AD-----
    if(isAD){
      //Pick Eng Date
      DateTime? pickedDate = await showDatePicker(
        context: context, 
        initialDate: initialDate ?? DateTime.now(),
        firstDate: DateTime(1900), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(3000),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: red.withOpacity(0.9), //Background color
                onSurface: Get.isDarkMode ? white : black, //UnSelected Date Font Color
              ),
            ),
            child: child!,
          ); 
        },
      );
      //Formatt date
      if(pickedDate != null ){
        //Formatted Eng Date
        var englishDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day).toString();
        //Formatted Nep Date
        var nepaliDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day).toNepaliDateTime();
        if(type == "from" ){
          //Set the latest Calc date for calcuation
          calcFromDate = DateTime.parse(englishDateTime);
          //if we have to date then calculate the total no of days
          if(calcToDate != "" && leaveDayCode == "Full Day"){
            noOfDaysController.text =  formatDate(calcFromDate, calcToDate);
          }
          //set fromDate text controller
          fromDate.text = DateFormat('yyyy-MM-dd').format((DateTime.parse(englishDateTime))).toString();
          //store date to send to api
          finalFromDateInAD = DateFormat('yyyy-MM-dd').format((DateTime.parse(englishDateTime))).toString();
          finalFromDateInBS = NepaliDateFormat('yyyy-MM-dd').format((NepaliDateTime.parse(nepaliDate.toString()))).toString();
          //set date for calculation
          calcFromDate = DateTime.parse(englishDateTime);
        } else{
          //Set the latest Calc date for calcuation
          calcToDate = DateTime.parse(englishDateTime);
          //if we have from date then calculate the total no of days
          if(calcFromDate != "" && leaveDayCode == "Full Day"){
            noOfDaysController.text =  formatDate(calcFromDate, calcToDate);
          }
          //set ToDate text controller
          toDate.text = DateFormat('yyyy-MM-dd').format((DateTime.parse(englishDateTime))).toString();
          //store date to send to api
          finalToDateInAD = DateFormat('yyyy-MM-dd').format((DateTime.parse(englishDateTime))).toString();
          finalToDateInBS = NepaliDateFormat('yyyy-MM-dd').format((NepaliDateTime.parse(nepaliDate.toString()))).toString();
          //set date for calculation
          calcToDate = DateTime.parse(englishDateTime);
        }
        // var nepDateInString = NepaliDateFormat('yyyy-MM-dd').format((NepaliDateTime.parse(nepaliDate.toString()))).toString();
      }
    }
    //For Selecting Date in BS 
    else{
      //Pick Nep Date
      DateTime? pickedDate = await picker.showMaterialDatePicker(
        context: context,
        initialDate: initialDate != null ? NepaliDateTime(initialDate.year, initialDate.month, initialDate.day) : NepaliDateTime.now(),
        firstDate: NepaliDateTime(2000),
        lastDate: NepaliDateTime(2090),
        initialDatePickerMode: DatePickerMode.day,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: red.withOpacity(0.9), //Background color
                onSurface: Get.isDarkMode ? white : black, //UnSelected Date Font Color
              ),
            ),
            child: child!,
          );
        },
      );
      //Format Nepali date
      if(pickedDate != null ){
        String? formattedDateTime;
        DateTime? engDate;
        setState(() {
          //Formatt date in BS
          formattedDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day).toString();
          //Formatt date in AD
          engDate = NepaliDateTime(pickedDate.year, pickedDate.month, pickedDate.day, 0, 0, 0).toDateTime();
        });
        if(type == "from" ){
          //set date for calculation
          calcFromDate = DateTime.parse(engDate.toString());
          //if we have to date then calculate the total no of days
          if(calcToDate != "" && leaveDayCode == "Full Day"){
            noOfDaysController.text =  formatDate(calcFromDate, calcToDate);
          }
          //set fromDate text controller
          fromDate.text = DateFormat('yyyy-MM-dd').format((DateTime.parse(formattedDateTime!))).toString();
          //store date to send to api
          finalFromDateInAD = DateFormat('yyyy-MM-dd').format((DateTime.parse(engDate.toString()))).toString();
          finalFromDateInBS =  DateFormat('yyyy-MM-dd').format((DateTime.parse(formattedDateTime!))).toString();
        } else{
          //if we have to date then calculate the total no of days
          calcToDate = DateTime.parse(engDate.toString());  
          if(calcFromDate != "" && leaveDayCode == "Full Day"){
            noOfDaysController.text =  formatDate(calcFromDate, calcToDate);
          }
          //set ToDate text controller
          toDate.text = DateFormat('yyyy-MM-dd').format((DateTime.parse(formattedDateTime!))).toString();
          //store date to send to api
          finalToDateInAD = DateFormat('yyyy-MM-dd').format((DateTime.parse(engDate.toString()))).toString();
          finalToDateInBS =  DateFormat('yyyy-MM-dd').format((DateTime.parse(formattedDateTime!))).toString();
        }
        // var nepDateInString = NepaliDateFormat('yyyy-MM-dd').format((NepaliDateTime.parse(nepaliDate.toString()))).toString();
      }
    }

    //If only from date is selected
    if(fromDate.text != "" && toDate.text == "" && leaveDayCode == "Full Day"){
      noOfDaysController.text = "1";
    }
    setState(() {});
  }

  //Employee Selection Section
  employeeSelection(){
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        left: 10.0.w,
        right: 10.0.w,
      ),
      height: 60.h,
      decoration: BoxDecoration(
        color: Get.isDarkMode ? textFormFieldColorDark : textFormFieldColorLight,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: DropdownFormField<Map<String, dynamic>>(
        dropdownColor: Theme.of(context).brightness == Brightness.light ? grey200 : grey700,
        fontColor: Get.isDarkMode ? white : blackColor,
        decoration:InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0.w, 3.8.h, 10.0.w, 3.8.h),
          prefixIconConstraints: BoxConstraints(
            minWidth: 12.0.w
          ),
          suffixIconConstraints: BoxConstraints(
            minWidth: 12.0.w
          ),
          border: InputBorder.none,
          hintText: profileData.data!.roleName.toString() == "admin" || profileData.data!.roleName.toString() == "Team Leader" 
            ? profileData.data!.fullName
            : "selectEmployee".tr,
          suffixIcon: Padding(
            padding: EdgeInsets.only(top: 1.5.h, left: 10.0.w),
            child: const Icon(Icons.expand_more_rounded, color: grey,),
          ),
        ),
        displayItemFn: (dynamic item) => Text(
          (item ?? {})['name'] ?? '',
          style: poppins(16, 0.0),
        ),
        findFn: (dynamic str) async => employeeList,
        selectedFn: (dynamic item1, dynamic item2) {
          if (item1 != null && item2 != null) {
            return item1['name'] == item2['name'];
          }
          return false;
        },
        filterFn: (dynamic item, str) => item['name'].toLowerCase().indexOf(str.toLowerCase()) >= 0,
        dropdownItemFn: (dynamic item, int position, bool focused,bool selected, Function() onTap) =>
        ListTile(
          title: Column(
            children: [
              Row(
                children: [
                  //Approver Image
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 2.5.h),
                    height: 30.h,
                    width: 30.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100)
                    ),
                    child: DisplayNetworkImage(
                      height: 20,
                      width: 20,
                      imageUrl: item["approverImage"].toString(),
                    ),
                  ),
                  SizedBox(width: 15.w,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['name']),
                      Text(item['role'].toString(), style: roboto(12, 0, FontWeight.w300),),
                    ],
                  ),
                ],
              ),
            ],
          ),
          tileColor: focused ? const Color.fromARGB(20, 0, 0, 0) : Colors.transparent,
          onTap: (){
            onTap();
            // if(approverIdList.length < 5){
            //   for (var data in approverIdList) {
            //     if (data['approver_id'].toString() == item["id"].toString()) {
            //       showMessage("Notice", "This approver has already been selected");
            //       return; // Added return statement to exit loop after showing snackbar
            //     } else if (item["id"] == read("ownId")) {
            //       showMessage("Notice", "You cannot add yourself as Approver");
            //       return; // Added return statement to exit loop after showing snackbar
            //     }
            //   }
            //   // If no duplicate or self ID found, add approver to the list
            //   setState(() {
            //     approverIdList.add({"approver_id": item["id"].toString()});
            //     addApproverNameChip.add(
            //       {
            //         "name" : item["name"].toString(),
            //         "role" : item["role"].toString(),
            //         "approverImage" : item["approverImage"].toString(),
            //       }
            //     );
            //   });
            // } else{
            //   showMessage("Notice", "Only 5 approver can be added");
            // }
          }
        ),
      ),
    );
  }

  //Approver Section
  approverSection(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Select Approver Dropdown
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(
            left: 10.0.w,
            right: 10.0.w,
          ),
          height: 60.h,
          decoration: BoxDecoration(
            color: Get.isDarkMode ? textFormFieldColorDark : textFormFieldColorLight,
            borderRadius: BorderRadius.circular(5.r),
          ),
          child: DropdownFormField<Map<String, dynamic>>(
            dropdownColor: Theme.of(context).brightness == Brightness.light ? grey200 : grey700,
            fontColor: Get.isDarkMode ? white : blackColor,
            decoration:InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(10.0.w, 3.8.h, 10.0.w, 3.8.h),
              prefixIconConstraints: BoxConstraints(
                minWidth: 12.0.w
              ),
              suffixIconConstraints: BoxConstraints(
                minWidth: 12.0.w
              ),
              border: InputBorder.none,
              labelText:  "selectApprover".tr,
              suffixIcon: Padding(
                padding: EdgeInsets.only(top: 1.5.h, left: 10.0.w),
                child: const Icon(Icons.expand_more_rounded, color: grey,),
              ),
            ),
            displayItemFn: (dynamic item) => Text(
              (item ?? {})['name'] ?? '',
              style: poppins(16, 0.0),
            ),
            findFn: (dynamic str) async => employeeList,
            selectedFn: (dynamic item1, dynamic item2) {
              if (item1 != null && item2 != null) {
                return item1['name'] == item2['name'];
              }
              return false;
            },
            filterFn: (dynamic item, str) => item['name'].toLowerCase().indexOf(str.toLowerCase()) >= 0,
            dropdownItemFn: (dynamic item, int position, bool focused,bool selected, Function() onTap) =>
            ListTile(
              title: Column(
                children: [
                  Row(
                    children: [
                      //Approver Image
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 2.5.h),
                        height: 30.h,
                        width: 30.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100)
                        ),
                        child: DisplayNetworkImage(
                          height: 20,
                          width: 20,
                          imageUrl: item["approverImage"].toString(),
                        ),
                      ),
                      SizedBox(width: 15.w,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['name']),
                          Text(item['role'].toString(), style: roboto(12, 0, FontWeight.w300),),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              tileColor: focused ? const Color.fromARGB(20, 0, 0, 0) : Colors.transparent,
              onTap: (){
                onTap();
                if(approverIdList.length < 5){
                  for (var data in approverIdList) {
                    if (data['approver_id'].toString() == item["id"].toString()) {
                      showMessage("Notice", "This approver has already been selected");
                      return; // Added return statement to exit loop after showing snackbar
                    } else if (item["id"] == read("ownId")) {
                      showMessage("Notice", "You cannot add yourself as Approver");
                      return; // Added return statement to exit loop after showing snackbar
                    }
                  }
                  // If no duplicate or self ID found, add approver to the list
                  setState(() {
                    approverIdList.add({"approver_id": item["id"].toString()});
                    addApproverNameChip.add(
                      {
                        "name" : item["name"].toString(),
                        "role" : item["role"].toString(),
                        "approverImage" : item["approverImage"].toString(),
                      }
                    );
                  });
                } else{
                  showMessage("Notice", "Only 5 approver can be added");
                }
              }
            ),
          ),
        ),
        approverIdList.isNotEmpty
        ? SizedBox(height: 5.h) 
        : const SizedBox(),
        //Selected Approvers Names section
        // approverIdList.isNotEmpty
        // ? Padding(
        //   padding: EdgeInsets.only(left : 5.0.w),
        //   child: Text("selectedApprover".tr, style: poppins(14, 0.1, FontWeight.w500)),
        // )
        // : const SizedBox(),
        SizedBox(height: 4.h),
        //Selected Approvers
        Wrap(
          spacing: 4.w,
          runSpacing: 6.h,
          alignment: WrapAlignment.start,
          children: List.generate(
            approverIdList.length,
            (index) =>
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 5.h, right: 4.w),
                  height: 46.h,
                  padding: EdgeInsets.symmetric(horizontal: 6.sp, vertical: 4.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: grey500!, width: 1.2.sp),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(100.r),
                      bottomLeft: Radius.circular(100.r),
                      bottomRight: Radius.circular(100.r)
                    ),
                  ),
                  child: Wrap(
                    // spacing: 0.1.w,
                    // runSpacing: 1.h,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    runAlignment: WrapAlignment.start,
                    alignment: WrapAlignment.start,
                    children: [
                      //Approver Image
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 2.5.h),
                        height: 30.h,
                        width: 30.h,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: addApproverNameChip[index]["approverImage"] == "" || addApproverNameChip[index]["approverImage"] == null
                            ? const AssetImage("assets/images/noProfileImg.jpg") as ImageProvider
                            : NetworkImage(
                              addApproverNameChip[index]["approverImage"].toString(),
                            ),
                            fit: BoxFit.cover
                          ),
                          borderRadius: BorderRadius.circular(100)
                        ),
                      ),
                      SizedBox( width: 8.w,),
                      //Approver name
                      Padding(
                        padding: EdgeInsets.only(top : 2.4.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 1.5.h),
                            Text(addApproverNameChip[index]["name"] ?? "N/A"),
                            Text(addApproverNameChip[index]["role"] ?? "N/A", style: poppins(10, 0),),
                          ],
                        ),
                      ),
                    ],
                  )
                ),
                //Remove Approver
                GestureDetector(
                  onTap: (){
                    setState(() {
                      approverIdList.removeAt(index);
                      addApproverNameChip.removeAt(index);
                    });
                  },
                  child: Container(
                    height: 17.h,
                    width: 17.h,
                    decoration: BoxDecoration(
                      color: black,
                      border: Border.all(color: grey500!, width: 1.5.sp),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                  alignment: Alignment.center,
                  child: Icon(Icons.clear, size: 8.sp, color: white,),
                  ),
                )
              ],
            ),
          )
        ),
      ],
    );
  }

  //Submit Button
  submitButton() {
    return CustomButton(
      height: 45.h,
      width: double.infinity,
      text: "submit".tr,
      fontSize: 18.sp,
      borderRadius: 50.r,
      onPressed: () async{
        final isValid = _formKey.currentState!.validate();
        if (!isValid) {
          //Validate Approver
          if(approverIdList.isEmpty){
            showMessage("Select an Approver", "Select at least 1 approver");
          }
          return;
        }
        if(leaveCategoryList.isNotEmpty){
          //Validation for picked date
          if(noOfDaysController.text.trim() == "0"){
            showMessage("Error", "To Date cannot be before from Date");
            return;
          }
          customAlertDialog(
            'Ok', 
            () => _leaveCon.addLeave(
              context,
              leaveCategoryController.text, 
              finalFromDateInAD, 
              finalToDateInAD, 
              leaveDayCode,
              leaveReason.text,
              noOfDaysController.text,
              approverIdList
            ),
            'Cancel', 
            () => Get.back(), 
            'You are about to apply for leave. Are you sure?'
          );
        }else{
          showMessage("Denied", "You are not assigned any leave.");
        }
      }
    );
  }

  //Update Button
  updateButton() {
    return CustomButton(
      height: 45.h,
      width: double.infinity,
      text: "update".tr,
      fontSize: 18.sp,
      borderRadius: 50.r,
      onPressed: () async{
        final isValid = _formKey.currentState!.validate();
        if (!isValid) {
          //Validate Approver
          if(approverIdList.isEmpty){
            showMessage("Select an Approver", "Select at least 1 approver");
          } else if(noOfDaysController.text == "0"){
            showMessage("Error", "To Date cannot be less than from Date");
          }
          return;
        }
        if(leaveCategoryList.isNotEmpty){
          //Validation for picked date
          if(noOfDaysController.text.trim() == "0"){
            showMessage("Error", "To Date cannot be less than from Date");
            return;
          }
          customAlertDialog(
            'Ok', 
            () => _leaveCon.updateLeaveRequest(
              context,
              widget.userData![0].id,
              leaveCategoryController.text, 
              finalFromDateInAD, 
              finalToDateInAD, 
              leaveDayCode,
              leaveReason.text,
              noOfDaysController.text,
              approverIdList
            ),
            'Cancel', 
            () => Get.back(), 
            'You are about to update the leave request. Are you sure?'
          );
        } else {
          showMessage("Denied", "You are not assigned any leave.");
        }
      }
    );
  }

  //Format Date
  String formatDate(DateTime fromDate, toDate) {
    if(fromDate == toDate){
      return "1";
    } else{
      final difference = toDate.difference(fromDate).inDays;
      if(difference < 0){
        return "0";
      }
      return (difference+1).toString();
    }
  }
}