import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hris/src/controller/app_controller.dart';
import 'package:hris/src/controller/auth_controller.dart';
import 'package:hris/src/helper/read_write.dart';
import 'package:hris/src/helper/style.dart';
import 'package:hris/src/model/profile_model.dart';
import 'package:hris/src/widgets/cached_network_image.dart';
import 'package:hris/src/widgets/custom_appbar.dart';
import 'package:hris/src/widgets/custom_button.dart';
import 'package:hris/src/widgets/custom_item_picker.dart';
import 'package:hris/src/widgets/custom_text_field.dart';
import 'package:hris/src/widgets/pick_and_crop_image.dart';
import 'package:hris/src/widgets/show_message.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'package:nepali_date_picker/nepali_date_picker.dart' as picker;
import 'package:nepali_date_picker/nepali_date_picker.dart';

class EditProfilePage extends StatefulWidget {
  final int? userID;
  final ProfileModel userData;

  const EditProfilePage({
    super.key, 
    this.userID, 
    required this.userData
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> with SingleTickerProviderStateMixin{
  //Get Controllers
  final AuthController profileCon = Get.put(AuthController());
  final AppController appCon = Get.put(AppController());
 
  //Tab controller
  late final TabController _tabController;

  //Form Key for validation
  final formKey = GlobalKey<FormState>(); 
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  //Text Controllers
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController personalEmailController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

  //Personal Tab Controllers
  final TextEditingController nameEngController = TextEditingController();
  final TextEditingController fNameEngController = TextEditingController();
  final TextEditingController lNameEngController = TextEditingController();
  final TextEditingController fNameNepController = TextEditingController();
  final TextEditingController lNameNepController = TextEditingController();
  final TextEditingController mNameNepController = TextEditingController();
  final TextEditingController mNameEngController = TextEditingController();
  final TextEditingController nameNepController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController noOfChildrenController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController religionController = TextEditingController();
  final TextEditingController maritalStatusController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  //Document Tab Controllers
  final TextEditingController issueDateController = TextEditingController();
  final TextEditingController issueDateNpController = TextEditingController();
  final TextEditingController issueDistrictController = TextEditingController();
  final TextEditingController citizenShipController = TextEditingController();
  final TextEditingController panController = TextEditingController();
  final TextEditingController passportNoController = TextEditingController();
  final TextEditingController drivingLicenseController = TextEditingController();
  final TextEditingController personalVechileController = TextEditingController();

  //Contacts tab controllers 
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController wardNoController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController permanentStateController = TextEditingController();
  final TextEditingController permanentDistrictController = TextEditingController();
  final TextEditingController permanentCityController = TextEditingController();
  final TextEditingController permanentWardNoController = TextEditingController();
  final TextEditingController permanentAddressController = TextEditingController();

  //For Picking Image
  File? file;
  String? updateProfileUrl;

  //DropDown Lists
    //--Sate And District DeopDown
  List<Map<String, dynamic>> stateList = [];
  List<Map<String, dynamic>> districtList = [];
  List<Map<String, dynamic>> selectedCurrentDistrictList = [];
  List<Map<String, dynamic>> permanentDistrictList = [];
  List<Map<String, dynamic>> selectedPermanentDistrictList = [];
  dynamic finalCurrentStateCode;
  dynamic selectedCurrentStateCode;
  dynamic finalPermanentStateCode;
  dynamic selectedPermanentStateCode;
  dynamic finalCurrentDistrictCode;
  dynamic selectedCurrentDistrictCode;
  dynamic finalPermanentDistrictCode;
  dynamic selectedPermanentDistrictCode;
  String selectedCurrentState = "";
  String selectedPermanentState = "";
  String selectedCurrentDistrict = "";
  String selectedPermanentDistrict = "";
    //--Personal Page Dropdown
  List<Map<String, dynamic>> genderList = [];
  List<Map<String, dynamic>> nationalityList = [];
  List<Map<String, dynamic>> maritalStatusList = [];
  List<Map<String, dynamic>> religionList = [];
  dynamic nationalityCode;
  dynamic religionCode;
  dynamic maritalStatusCode;
  dynamic genderCode;
  String selectedGender = "";
  String selectedGenderCode = "";
  String selectedNationality = "";
  String selectedReligion = "";
  String selectedMaritalStatus = "";
  String selectedNationalityCode = "";
  String selectedReligionCode = "";
  String selectedMaritalStatusCode = "";
   //Document Page Dropdown
  List<Map<String, dynamic>> personalVehicleList = [];
  dynamic personalVehicleCode;
  String selectedPersonalVehicleCode = "";
  String selectedPersonalVehicle = "";
  List<Map<String, dynamic>> drivingLicenseList = [];
  dynamic drivingLicenseCode;
  String selectedDrivingLicenseCode = "";
  String selectedDrivingLicense = "";
  
  //For contact person form and Employee refrence form
  List <Map<String,TextEditingController>> contactPersonControllers = [];
  
  List <Map<String,TextEditingController>> employeeReferrenceFormTextControllers = [];

  //For contact person form and Employee Education form
  List <Map<String,TextEditingController>> employeeEducationControllers = [];

  //For contact person form and Employee Experience form
  List <Map<String,TextEditingController>> employeeExperienceControllers = [];

  //Set initial Index of Gender DropDown
  getGenderDropDownIndex(){
    if(genderController.text != ""){
      for (int i=0; i < genderList.length; i++) {
        if (genderList[i]["name"].toString() == genderController.text) {
          return i; 
        }
      } 
    } else {
      return 0;
    }
  }

  //To get the inital data for the Nationality dropdown
  getNationalityDropDownIndex(){
    if(nationalityController.text != ""){
      for (int i=0; i < nationalityList.length; i++) {
        if (nationalityList[i]["name"].toString() == nationalityController.text) {
          return i; 
        }
      } 
    } else {
      return 0;
    }
  }

  //To get the inital data for the Religion dropdown
  getReligionDropDownIndex(){
    if(religionController.text != ""){
      for (int i=0; i < religionList.length; i++) {
        if (religionList[i]["name"].toString() == religionController.text) {
          return i; 
        }
      } 
    } else {
      return 0;
    }
  }

  //To get the inital data for the Marital Status dropdown
  getMaritalStatusDropDownIndex(){
    if(maritalStatusController.text != ""){
      for (int i=0; i < maritalStatusList.length; i++) {
        if (maritalStatusList[i]["name"].toString() == maritalStatusController.text) {
          return i; 
        }
      } 
    } else {
      return 0;
    }
  }

  //To get the inital data for the Driving License dropdown
  getDrivingLicenseDropDownIndex(){
    if(drivingLicenseController.text != ""){
      for (int i=0; i < drivingLicenseList.length; i++) {
        if (drivingLicenseList[i]["name"].toString() == drivingLicenseController.text) {
          return i; 
        }
      } 
    } else {
      return 0;
    }
  }

  //To get the inital data for the Personal Vehicle dropdown
  getPersonalVehicleDropDownIndex(){
    if(personalVechileController.text != ""){
      for (int i=0; i < personalVehicleList.length; i++) {
        if (personalVehicleList[i]["name"].toString() == personalVechileController.text) {
          return i; 
        }
      } 
    } else {
      return 0;
    }
  }

  //To get the inital index for the State/Provience dropdown
  getStateDropDownIndex() {
    if(stateController.text != ""){
      for (int i=0; i < stateList.length; i++) {
        if (stateList[i]["stateName"].toString() == stateController.text) {
          return i; 
        }
      } 
    } else {
      return 0;
    }
  }

  //To get the inital index for the State/Provience dropdown
  getPermanentStateDropDownIndex() {
    if(permanentStateController.text != ""){
      for (int i=0; i < stateList.length; i++) {
        if (stateList[i]["stateName"].toString() == permanentStateController.text) {
          return i; 
        }
      } 
    } else {
      return 0;
    }
  }

  //To get the inital data for the current district dropdown
  getCurrentDistrictDropDownIndex(){
    if(districtController.text != ""){
      for (int i=0; i < districtList.length; i++) {
        if (districtList[i]["districtName"].toString() == districtController.text) {
          return i; 
        }
      } 
    } else {
      return 0;
    }
  }

  //To get the inital data for the Permanent district dropdown
  getPermanentDistrictDropDownIndex() {
    if(permanentDistrictController.text != ''){
      for (int i=0; i < permanentDistrictList.length; i++) {
        if (permanentDistrictList[i]["districtName"].toString() == permanentDistrictController.text) {
          return i; 
        }
      } 
    } else {
      return 0;
    }
  }

  @override
  void initState() {
    initialiseValue();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() { 
      setState(() {});
    });
    super.initState();
  }

  initialiseValue() async{
    nameEngController.text = widget.userData.data!.fullName!;
    fNameEngController.text = widget.userData.data!.fName ?? "";
    lNameEngController.text = widget.userData.data!.lName ?? "";
    mNameEngController.text = widget.userData.data!.mName ?? "";
    nameNepController.text = widget.userData.data!.fullNameNp!;
    fNameNepController.text = widget.userData.data!.fNameNp ?? "";
    lNameNepController.text = widget.userData.data!.lNameNp ?? "";
    mNameNepController.text = widget.userData.data!.mNameNp ?? "";
    emailController.text = widget.userData.data!.officialEmail ?? "";
    roleController.text = widget.userData.data!.roleName ?? "";
    updateProfileUrl = widget.userData.data!.profileImageUrl ?? "";
    genderController.text = widget.userData.data!.genderName!;
    departmentController.text = widget.userData.data!.departmentName!;
    birthDateController.text = widget.userData.data!.birthdayAd == null ? "" : widget.userData.data!.birthdayAd.toString();
    nationalityController.text = widget.userData.data!.nationality ?? "";
    religionController.text = widget.userData.data!.religion ?? "";
    maritalStatusCode = widget.userData.data!.maritalStatus ?? "";
    personalVehicleCode = widget.userData.data!.personalVehicle ?? "";
    drivingLicenseCode = widget.userData.data!.drivingLicense ?? "";
    //To get ontap functionality in cupatinopicker
    selectedDrivingLicenseCode = widget.userData.data!.drivingLicense ?? "";
    selectedPersonalVehicleCode = widget.userData.data!.personalVehicle ?? "";
    selectedNationality = widget.userData.data!.nationality ?? "";
    selectedReligion = widget.userData.data!.religion ?? "";
    selectedGender = widget.userData.data!.genderName ?? "";
    selectedMaritalStatus = widget.userData.data!.maritalStatus ?? "";
    empEducationDataMapping();
    empExperienceDataMapping();
    contactPersonDataMapping();
    employeeReferenceDataMapping();
    await getNecessaryData();
    citizenShipController.text = widget.userData.data!.citizenshipNo ?? "";
    issueDateController.text = widget.userData.data!.citizenshipAttr == null ? "" : widget.userData.data!.citizenshipAttr!.issueDate.toString();
    issueDateNpController.text = widget.userData.data!.citizenshipAttr == null ? "" : widget.userData.data!.citizenshipAttr!.issueDateNp.toString();
    issueDistrictController.text = widget.userData.data!.citizenshipAttr == null ? "" : widget.userData.data!.citizenshipAttr!.issueDistrict.toString();
    noOfChildrenController.text = widget.userData.data!.noOfChildren == null ? "" : widget.userData.data!.noOfChildren.toString();
    phoneController.text = widget.userData.data!.phoneNo ?? "";
    stateController.text = widget.userData.data!.currentAddress!.stateName!;
    districtController.text = widget.userData.data!.currentAddress!.districtName ?? "";
    cityController.text = widget.userData.data!.currentAddress!.city ?? "";
    wardNoController.text = widget.userData.data!.currentAddress!.ward ?? "";
    addressController.text = widget.userData.data!.currentAddress!.address ?? "";
    personalEmailController.text = widget.userData.data!.personalEmail == null ? "" : widget.userData.data!.personalEmail.toString(); 
    panController.text = widget.userData.data!.panNo ?? "";
    passportNoController.text = widget.userData.data!.passportNo ?? "";
    // drivingLicenseController.text = widget.userData.data!.drivingLicense ?? "";
    permanentStateController.text = widget.userData.data!.permanentAddress!.stateName ?? "";
    permanentDistrictController.text = widget.userData.data!.permanentAddress!.districtName ?? "";
    personalVechileController.text = widget.userData.data!.personalVehicle ?? "";
    permanentCityController.text = widget.userData.data!.permanentAddress!.city ?? "";
    permanentWardNoController.text = widget.userData.data!.permanentAddress!.ward ?? "";
    permanentAddressController.text = widget.userData.data!.permanentAddress!.address ?? "";
    finalCurrentStateCode = int.tryParse(widget.userData.data!.currentAddress!.stateCode ?? "");
    finalPermanentStateCode = int.tryParse( widget.userData.data!.permanentAddress!.stateCode ?? "");
    finalCurrentDistrictCode = int.tryParse(widget.userData.data!.currentAddress!.districtCode ?? "");
    finalPermanentDistrictCode = int.tryParse(widget.userData.data!.permanentAddress!.districtCode ?? "");
    // selectedCurrentAddStateCode = widget.userData.data!.currentAddress!.stateCode ?? "";
    // selectedPermanentAddStateCode = widget.userData.data!.permanentAddress!.stateCode ?? "";
    // selectedCurrentAddDistrictCode = widget.userData.data!.currentAddress!.districtCode ?? "";
    // selectedPermanentAddDistrictCode = widget.userData.data!.permanentAddress!.districtCode ?? "";
  }

  //Emoloyee Education Data mapping
  empEducationDataMapping(){
    //To add initial form
    if( widget.userData.data!.empEducation!.isEmpty){
      employeeEducationControllers.add(
        {
          "degree" : TextEditingController(),
          "institution" : TextEditingController(),
          "completion_year" : TextEditingController(),
          "percentage" : TextEditingController()
        }
      );
    } else{
      for(var data in widget.userData.data!.empEducation!){
        employeeEducationControllers.add(
          {
            "degree" : TextEditingController(text: data.degree),
            "institution" : TextEditingController(text: data.institution),
            "completion_year" : TextEditingController(text: data.completionYear),
            "percentage" : TextEditingController(text: data.percentage)
          }
        );
      }
    }
  }

  //Emoloyee Experience Data mapping
  empExperienceDataMapping(){
    //To add initial form
    if( widget.userData.data!.empExperience!.isEmpty){
      employeeExperienceControllers.add(
        {
          "company" : TextEditingController(),
          "workFrom" : TextEditingController(),
          "workTo" : TextEditingController(),
          "position" : TextEditingController()
        }
      );
    } else{
      for(var data in widget.userData.data!.empExperience!){
        employeeExperienceControllers.add(
          {
            "company" : TextEditingController(text: data.company),
            "workFrom" : TextEditingController(text: data.workFrom),
            "workTo" : TextEditingController(text: data.workTo),
            "position" : TextEditingController(text: data.position)
          }
        );
      }
    }
  }

  //Contact Person Data mapping
  contactPersonDataMapping(){
    //To add initial form
    if( widget.userData.data!.contactPersons!.isEmpty){
      contactPersonControllers.add(
        {
          "title" : TextEditingController(),
          "relationship" : TextEditingController(),
          "name" : TextEditingController(),
          "phone" : TextEditingController(),
          "email" : TextEditingController(),
          "address" : TextEditingController(),
        }
      );
    } else{
      for(var data in widget.userData.data!.contactPersons!){
        contactPersonControllers.add(
          {
            "title" : TextEditingController(text: data.title),
            "relationship" : TextEditingController(text: data.relationship),
            "name" : TextEditingController(text: data.name),
            "phone" : TextEditingController(text: data.phone),
            "email" : TextEditingController(text: data.email),
            "address" : TextEditingController(text: data.address),
          }
        );
      }
    }
  }

  //Employee reference Data mapping
  employeeReferenceDataMapping(){
    //To add initial form
    if( widget.userData.data!.empReference!.isEmpty){
      employeeReferrenceFormTextControllers.add(
        {
          "name" : TextEditingController(),
          "company" : TextEditingController(),
          "address" : TextEditingController(),
          "phone" : TextEditingController()
        }
      );
    } else{
      for(var data in widget.userData.data!.empReference!){
        employeeReferrenceFormTextControllers.add(
          {
            "name" : TextEditingController(text: data.name),
            "company" : TextEditingController(text: data.company),
            "address" : TextEditingController(text: data.address),
            "phone" : TextEditingController(text: data.phone),
          }
        );
      }
    }
  }

  //Get necessary data for dropdown and initial value of dropdown controllers9
  getNecessaryData() async{
    var stateData = await appCon.getState();
    var optionItemsData = await appCon.getOptionItemLists();

    //For Gender
    for(var data in optionItemsData.data.gender){
      //Set initial value for the nationality code
      if(data.name == genderController.text){
        selectedGenderCode = data.code;
        selectedGender = data.name;
      }
      genderList.add(
        {
          "code" : data.code,
          "id" : data.id,
          "name" : data.name,
          "nameNp" : data.nameNp
        }
      );
    }

    //For Nationality
    for(var data in optionItemsData.data.nationality){
      //Set initial value for the nationality code
      if(data.name == nationalityController.text){
        nationalityCode = data.code;
        selectedNationalityCode = data.code;
      }
      nationalityList.add(
        {
          "code" : data.code,
          "id" : data.id,
          "name" : data.name,
          "nameNp" : data.nameNp
        }
      );
    }

    //For Religion
    for(var data in optionItemsData.data.religion){
      //Set initial value for the nationality code
      if(data.name == religionController.text){
        religionCode = data.code;
        selectedReligionCode = data.code;
      }
      religionList.add(
        {
          "code" : data.code,
          "id" : data.id,
          "name" : data.name,
          "nameNp" : data.nameNp
        }
      );
    }

    //For Marital Status
    for(var data in optionItemsData.data.maritalStatus){
      //Set initial value for the nationality code
      if(data.code == maritalStatusCode){
        maritalStatusController.text = data.name;
        selectedMaritalStatusCode = data.code;
      }
      maritalStatusList.add(
        {
          "code" : data.code,
          "id" : data.id,
          "name" : data.name,
          "nameNp" : data.nameNp
        }
      );
    }

    //For Personal Vechile
    for(var data in optionItemsData.data.personalVehicle){
      //Set initial value for the nationality code
      if(data.code == personalVehicleCode){
        personalVechileController.text = data.name;
        selectedPersonalVehicleCode = data.code;
      }
      personalVehicleList.add(
        {
          "code" : data.code,
          "id" : data.id,
          "name" : data.name,
          "nameNp" : data.nameNp
        }
      );
    }

    //For Driving License
    for(var data in optionItemsData.data.drivingLicense){
      //Set initial value for the nationality code
      if(data.code == drivingLicenseCode){
        drivingLicenseController.text = data.name;
        selectedDrivingLicenseCode = data.code;
      }
      drivingLicenseList.add(
        {
          "code" : data.code,
          "id" : data.id,
          "name" : data.name,
          "nameNp" : data.nameNp
        }
      );
    }

    //For State List
    for(var dataList in stateData.data){
      stateList.add(
        {
          "stateName" : dataList.stateName,
          "stateCode" : dataList.stateCode,
          "districts" : dataList.districts,
        }
      );
    }

    //For Current District List and initial value of the state and district text controllers
    for(var data in stateList){
      if(widget.userData.data!.currentAddress!.stateCode.toString() == data["stateCode"].toString()){
        //This will set the initail value for the state controller so that we have initial value for the statedropdown
        stateController.text = data["stateName"];
        //adds required district in district list acc to province selected
        for(int i = 0; i < data["districts"].length; i++ ){
          //Save the district name to district controller acc to incomming district code
          if(data["districts"][i].districtCode.toString() == widget.userData.data!.currentAddress!.districtCode!.toString()){
            districtController.text = data["districts"][i].districtName;
          }
          districtList.add(
            {
              "districtName" : data["districts"][i].districtName,
              "districtCode" : data["districts"][i].districtCode,
              "stateCode" : data["districts"][i].stateCode,
            }
          );
        }
      }
    }

    //For Permanent District
    for(var data in stateList){
      if(data["stateCode"].toString() == widget.userData.data!.permanentAddress!.stateCode.toString()){
        //This will set the initail value for the state controller so that we have initial value for the permanentstatedropdown
        permanentStateController.text = data["stateName"];
        //adds required district in district list acc to province selected
        for(int i = 0; i < data["districts"].length; i++ ){
          //Save the district name to district controller acc to incomming district code
          if(data["districts"][i].districtCode.toString() == widget.userData.data!.permanentAddress!.districtCode.toString()){
            permanentDistrictController.text = data["districts"][i].districtName;
          }
          permanentDistrictList.add(
            {
              "districtName" : data["districts"][i].districtName,
              "districtCode" : data["districts"][i].districtCode,
              "stateCode" : data["districts"][i].stateCode,
            }
          );
        }
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    nameEngController.dispose();
    nameNepController.dispose();
    departmentController.dispose();
    emailController.dispose();
    genderController.dispose();
    phoneController.dispose();
    nationalityController.dispose();
    religionController.dispose();
    maritalStatusController.dispose();
    roleController.dispose();
    birthDateController.dispose();
    citizenShipController.dispose();
    noOfChildrenController.dispose();
    issueDateController.dispose();
    issueDateNpController.dispose();
    issueDistrictController.dispose();
    stateController.dispose();
    districtController.dispose();
    cityController.dispose();
    wardNoController.dispose();
    addressController.dispose();
    personalEmailController.dispose();
    panController.dispose();
    passportNoController.dispose();
    drivingLicenseController.dispose();
    personalVechileController.dispose();
    permanentStateController.dispose();
    permanentDistrictController.dispose();
    permanentCityController.dispose();
    permanentWardNoController.dispose();
    permanentAddressController.dispose();
    fNameEngController.dispose();
    lNameEngController.dispose();
    fNameNepController.dispose();
    lNameNepController.dispose();
    mNameNepController.dispose();
    mNameEngController.dispose();
    remove("pickedImage");
    super.dispose();
  }

  double getHeight() {
    return 800;
  }

  @override
  Widget build(BuildContext contexwt) {
    return Scaffold(
      appBar: customAppbar(
        context, 
        "Edit Profile",
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
            NestedScrollView(
              headerSliverBuilder: (context, value) {
                return [
                  SliverPersistentHeader(
                    delegate: _SliverAppBarDelegate(
                      minHeight: 150.h,
                      maxHeight: 150.h,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
                        height: getHeight() * (1 / 11),
                        width: double.infinity,
                        child: //Profile and email
                        profileAndEmail(),
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverAppBarDelegate(
                      minHeight: 60,
                      maxHeight: 60,
                      child: Container(
                        height: 50.h,
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(5.0,),
                        ),
                        child: Obx(() => 
                          Visibility(
                            visible: appCon.isLoading.value == false && profileCon.isProfileLoading.value == false,
                            child: TabBar(
                              controller: _tabController,
                              padding: EdgeInsets.only(left: 16.w),
                              isScrollable: true,
                              labelColor: Get.isDarkMode ? white : greyShade3,
                              labelStyle: notoSans(greyShade3, 17.0, 0.0),
                              unselectedLabelColor: grey,
                              unselectedLabelStyle: notoSans(grey, 17.0, 0.0),
                              indicatorColor: Theme.of(context).primaryColor,
                              indicatorSize: TabBarIndicatorSize.label,
                              indicatorWeight: 2.2,
                              tabs: const [
                                Tab(
                                  text: "Personal",
                                  height: 40,
                                ),
                                Tab(
                                  text: "Documents",
                                  height: 40,
                                ),
                                Tab(
                                  text: "Contacts",
                                  height: 40,
                                ),
                              ],
                            ),
                          ),
                        ) 
                      ),
                    ),
                  ),
                ];
              },
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(() => 
                  appCon.isLoading.value || profileCon.isProfileLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : Form(
                      key: formKey,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          //Personal Tab
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                            child: Form(
                              key: _formKey1, 
                              child: personalTab(), 
                            ),
                          ),
                          //Document Tab
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                            child: Form(
                              key: _formKey2, 
                              child: documentTab(), 
                            ),
                          ),
                          //Contact Tab
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                            child: Form(
                              key: _formKey3, 
                              child: contactTab(), 
                            ),
                          ),
                        ],
                      ),
                    ),
                )
              ),
            ),
            //Submit Button Section
            Obx(() => 
              Visibility(
                visible: profileCon.isProfileLoading.value != true && appCon.isLoading.value != true,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.all(20.sp),
                    height: 80.h,
                    width: double.infinity,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: 
                    //Update Button
                    CustomButton(
                      width: double.infinity,
                      text: 'Update',
                      onPressed:() async { 
                        checkValidation();
                        if(genderController.text != "" && maritalStatusCode != "" && finalCurrentStateCode != null && finalCurrentDistrictCode != null && finalCurrentStateCode != "" && finalCurrentDistrictCode != "" && phoneController.text != "" && cityController.text !="" && wardNoController.text != "" && addressController.text != ""){
                          profileCon.updateProfile(
                            context,
                            widget.userData.data,
                            updateProfileUrl,
                
                            departmentController.text,
                            personalEmailController.text,
                            emailController.text,
                            roleController.text,
                
                            //Personal tab
                            fNameEngController.text,
                            lNameEngController.text,
                            fNameNepController.text,
                            lNameNepController.text,
                            nameEngController.text,
                            nameNepController.text,
                            birthDateController.text,
                            noOfChildrenController.text,
                            nationalityCode,
                            religionCode,
                            maritalStatusCode,
                            selectedGenderCode,
                            employeeEducationControllers,
                            employeeExperienceControllers,
                
                            //Document Tab Controllers
                            issueDateController.text,
                            issueDateNpController.text,
                            issueDistrictController.text,
                            citizenShipController.text,
                            panController.text,
                            passportNoController.text,
                            drivingLicenseCode,
                            personalVehicleCode,
                
                            //Contacts tabs 
                            phoneController.text,
                            //Permanent Address
                            finalPermanentStateCode.toString(),
                            finalPermanentDistrictCode.toString(),
                            permanentCityController.text,
                            permanentWardNoController.text,
                            permanentAddressController.text,
                            //Current Address
                            finalCurrentStateCode.toString(),
                            finalCurrentDistrictCode.toString(),
                            cityController.text,
                            wardNoController.text,
                            addressController.text,
                            contactPersonControllers,
                            employeeReferrenceFormTextControllers,
                          );
                        } else {
                          showMessage("Notice", "Please fill all the required form");
                        }
                      },
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  //Check Validation
  checkValidation(){
    if(_tabController.index == 0){
      _formKey1.currentState!.validate();
    }
    if(_tabController.index == 1){
      _formKey2.currentState!.validate();
    }
    if(_tabController.index == 2){
      _formKey3.currentState!.validate();
    }
  }


  //Change Profile Image Section
  profileAndEmail() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //Profile Image
        Stack(
          alignment: Alignment.center,
          children:  [
            InkWell(
              onTap: (){
                changeImageBottomSheet();
              },
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child : read("pickedImage") != null && read("pickedImage") != ''
                ? Image.file(
                  read("pickedImage"),
                  height: 102.sp,
                  width: 102.sp,
                  fit: BoxFit.cover,
                )
                : DisplayNetworkImage(
                  imageUrl: updateProfileUrl ?? "",
                  height:  102.sp,
                  width:  102.sp,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.085,
              left: MediaQuery.of(context).size.height * 0.095,
              child: InkWell(
                onTap: (){
                  changeImageBottomSheet();
                },
                child:  CircleAvatar(
                  radius: 13.5.r,
                  backgroundColor:Theme.of(context).primaryColor,
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 16.r,
                  ),
                ),
              ),
            )
          ]
        ),
        //Name, Email and Department
        SizedBox(
          width: 200.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 8.h,),
              //Full name engilsh
              Text(nameEngController.text.toUpperCase(), style: poppins(18, 0.0, FontWeight.bold),),
              // SizedBox(height: 6.h,),
              //Department
              Text(roleController.text, style: poppins1(Theme.of(context).primaryColor, 12, 0.5),),
              SizedBox(height: 6.h,),
              //Email
              Text(emailController.text, style: poppins(14, 0.0),),
            ],
          ),
        )
      ],
    );
  }

  //Personal Tab
  personalTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          upperPersonalTabSection(),
           //Employee Education Section ----------
          employeeEducationSection(),
          SizedBox(height: 30.h,),
          //Employee Experience Section ---------
          employeeExperienceSection(),
          const SizedBox(height: 80.0)
        ],
      )
    );
  }

  upperPersonalTabSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      //Geneder & Date of Birth
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            selectGender(),
            SizedBox(width: 8.0.w),
            Expanded(
              child: selectBirthDate()
            )
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
        //Nationality
        CustomTextField(
          readOnly: true,
          controller: nationalityController,
          labelText: 'nationality'.tr,
          suffixIcon: const Icon(Icons.expand_more_rounded, color: lightGrey,),
          onTap: (){
            selectValueFromDropDown(
              context,
              getNationalityDropDownIndex() ?? 0, //Initial Item
              (index){
                setState(() {
                  selectedNationality = nationalityList[index]["name"];
                  selectedNationalityCode = nationalityList[index]["code"];
                });  
              },//On select function
              nationalityList,//Drop down data list
              nationalityList.map((value) => Center(
                child: Text(value["name"],style: robotoWithColor(black, 16.0, 0.0),)
              )).toList(),//Display data in drop down
              (){
                setState(() {
                  nationalityController.text = selectedNationality != "" ? selectedNationality : nationalityList[0]["name"];
                  nationalityCode = selectedNationalityCode != "" ? selectedNationalityCode : nationalityList[0]["code"];
                });
                Get.back();
              },
              MediaQuery.of(context).size.height * 0.26, //Height of the bottom sheet
            );
          },
        ),
        SizedBox(
          height: 20.h,
        ),
        //Religion
        CustomTextField(
          readOnly: true,
          controller: religionController,
          labelText: 'religion'.tr,
          suffixIcon: const Icon(Icons.expand_more_rounded, color: lightGrey,),
          onTap: (){
            selectValueFromDropDown(
              context,
              getReligionDropDownIndex() ?? 0, //Initial Item
              (index){
                setState(() {
                  selectedReligion = religionList[index]["name"];
                  selectedReligionCode = religionList[index]["code"];
                });  
              },//On select function
              religionList,//Drop down data list
              religionList.map((value) => Center(
                child: Text(value["name"],style: robotoWithColor(black, 16.0, 0.0),)
              )).toList(),//Display data in drop down
              (){
                setState(() {
                  religionController.text = selectedReligion != "" ? selectedReligion : religionList[0]["name"];
                  religionCode = selectedReligionCode != "" ? selectedReligionCode : religionList[0]["code"];
                });
                Get.back();
              },
              MediaQuery.of(context).size.height * 0.24, //Height of the bottom sheet
            );
          },
        ),
        SizedBox(
          height: 20.h,
        ),
        //Marital Status
        CustomTextField(
          readOnly: true,
          controller: maritalStatusController,
          labelText: 'maritalStatus'.tr,
          suffixIcon: const Icon(Icons.expand_more_rounded, color: lightGrey,),
          validator: (value) {
            return value == null || value.isEmpty ? 'Marital Status is required' : null;
          },
          onTap: (){
            selectValueFromDropDown(
              context,
              getMaritalStatusDropDownIndex() ?? 0, //Initial Item
              (index){
                setState(() {
                  selectedMaritalStatus = maritalStatusList[index]["name"];
                  selectedMaritalStatusCode = maritalStatusList[index]["code"];
                });  
              },//On select function
              maritalStatusList,//Drop down data list
              maritalStatusList.map((value) => Center(
                child: Text(value["name"],style: robotoWithColor(black, 16.0, 0.0),)
              )).toList(),//Display data in drop down
              (){
                setState(() {
                  maritalStatusController.text = selectedMaritalStatus != "" ? selectedMaritalStatus : maritalStatusList[0]["name"];
                  maritalStatusCode = selectedMaritalStatusCode != "" ? selectedMaritalStatusCode : maritalStatusList[0]["code"];
                });
                Get.back();
              },
              MediaQuery.of(context).size.height * 0.24, //Height of the bottom sheet
            );
          },
        ),
        SizedBox(
          height: 20.h,
        ),
        //No of childern
        CustomTextField(
          readOnly: false,
          controller: noOfChildrenController,
          labelText: 'noOfChildren'.tr,
          keyboardType: TextInputType.number,
        ),
        SizedBox(
          height: 20.h,
        ),
      ],
    );
  }

  employeeEducationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Employee Education", style: poppins(15, 0, FontWeight.w500)),
        SizedBox(height: 16.h,),
        //Employee Education Form
        ListView.separated(
          separatorBuilder: (context, index) => SizedBox(height: 20.h),
          physics:  const NeverScrollableScrollPhysics(),
          itemCount: employeeEducationControllers.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(
                border: Border.all(color: grey500!, width: 1.sp),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                children:  [
                  //Delete Contact Person Form
                  Row(
                    children: [
                      Text("Employee Education Form ${index + 1}", style: poppins(16, 0, FontWeight.w400)),
                      const Spacer(),
                      Visibility(
                        visible: index == 0 ? false : true,
                        child: InkWell(
                          onTap: (){
                            employeeEducationControllers.removeAt(index);
                            setState(() {});
                          },
                          child: Container(
                            height: 30.sp,
                            width: 30.sp,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(2.r)
                            ),
                            child: const Icon(Icons.delete, color: white, size: 25,)
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h,),

                  //Employee Education
                    CustomTextField(
                    controller: employeeEducationControllers[index]["degree"],
                    readOnly: false,
                    labelText: "Degree",
                  ),
                  SizedBox(height: 20.h,),
                    CustomTextField(
                    controller: employeeEducationControllers[index]["institution"],
                    readOnly: false,
                    labelText: "Institute",
                  ),
                  SizedBox(height: 20.h,),
                    CustomTextField(
                    controller: employeeEducationControllers[index]["completion_year"],
                    readOnly: false,
                    labelText: "Completion Year",
                    keyboardType: TextInputType.datetime,
                  ),
                  SizedBox(height: 20.h,),
                    CustomTextField(
                    controller: employeeEducationControllers[index]["percentage"],
                    readOnly: false,
                    labelText: "Percentage/Grade",
                  ),
                  SizedBox(height: 20.h,),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 10.h,),
        CustomButton(
          text: "Add Employee Education",
          color: green,
          fontSize: 12.sp,
          height: 30.h,
          onPressed: (){
            if(employeeEducationControllers.length < 5){
              employeeEducationControllers.add(
                {
                  "degree" : TextEditingController(),
                  "institution" : TextEditingController(),
                  "completion_year" : TextEditingController(),
                  "percentage" : TextEditingController()
                }
              );
              setState(() {});
            } else{
              Get.snackbar("Denied", "You cannot add more than 5 Employee Education");
            }
          },
        ),
      ],
    );
  }

  employeeExperienceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Employee Experience", style: poppins(15, 0, FontWeight.w500)),
        SizedBox(height: 16.h,),
        //Employee Reference Form
        ListView.separated(
          separatorBuilder: (context, index) => SizedBox(height: 20.h),
          physics:  const NeverScrollableScrollPhysics(),
          itemCount: employeeExperienceControllers.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(
                border: Border.all(color: grey500!, width: 1.sp),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                children: [
                  //Delete Employee Form
                  Row(
                    children: [
                      Text("Employee Experience Form ${index + 1}", style: poppins(16, 0, FontWeight.w400)),
                      const Spacer(),
                      Visibility(
                        visible: index == 0 ? false : true,
                        child: InkWell(
                          onTap: (){
                            employeeExperienceControllers.removeAt(index);
                            setState(() {});
                          },
                          child: Container(
                            height: 30.sp,
                            width: 30.sp,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(2.r)
                            ),
                            child: const Icon(Icons.delete, color: white, size: 25,)
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h,),

                  CustomTextField(
                    controller: employeeExperienceControllers[index]["company"],
                    readOnly: false,
                    labelText: "Company",
                  ),
                  SizedBox(height: 20.h,),
                  CustomTextField(
                    controller: employeeExperienceControllers[index]["workFrom"],
                    readOnly: true,
                    labelText: "Work From",
                    onTap: () async{
                      employeeExperienceControllers[index]["workFrom"]!.text = await pickDate("English", "", convertedDate(employeeExperienceControllers[index]["workFrom"]!.text));
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 20.h,),
                  CustomTextField(
                    controller: employeeExperienceControllers[index]["workTo"],
                    readOnly: true,
                    labelText: "Work To",
                    onTap: () async{
                      employeeExperienceControllers[index]["workTo"]!.text = await pickDate("English", "", convertedDate(employeeExperienceControllers[index]["workTo"]!.text));
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 20.h,),
                  CustomTextField(
                    controller: employeeExperienceControllers[index]["position"],
                    readOnly: false,
                    labelText: "Position",
                  ),
                  SizedBox(height: 20.h,),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 10.h,),
        CustomButton(
          height: 30.h,
          text: "Add Employee Experience",
          color: green,
          fontSize: 12.sp,
          onPressed: (){
            if(employeeExperienceControllers.length <= 4){
              employeeExperienceControllers.add(
                {
                  "company" : TextEditingController(),
                  "workFrom" : TextEditingController(),
                  "workTo" : TextEditingController(),
                  "position" : TextEditingController()
                }
              );
              setState(() {});
            } else{
              showMessage("Denied", "You cannot add more than 5 Employee Experience");
            }
          },
        ),
      ],
    );
  }
  

  //Document Tab
  documentTab(){
    return SingleChildScrollView(
      child: Column(
        children: [
          //CitizenShip No
          CustomTextField(
            readOnly: false,
            controller: citizenShipController,
            labelText: 'citizenShipNo'.tr,
          ),
          SizedBox(height: 20.h,),
          //Issued Date
          selectIssuedDateNep('citizen'),
          SizedBox(height: 20.h,),
          //Issued Date Nep
          CustomTextField(
            readOnly: false,
            controller: issueDistrictController,
            labelText: 'issuedDistrict'.tr,
          ),
          SizedBox(height: 20.h,),
          //PAN no
          CustomTextField(
            readOnly: false,
            controller: panController,
            labelText: 'panNo'.tr,
          ),
          SizedBox(height: 20.h,),
          //Passport No.
          CustomTextField(
            readOnly: false,
            controller: passportNoController,
            labelText: 'passportNo'.tr,
          ),
          SizedBox(height: 20.h,),
          //Driving License
          CustomTextField(
            readOnly: true,
            controller: drivingLicenseController,
            labelText: 'drivingLicense'.tr,
            suffixIcon: const Icon(Icons.expand_more_rounded, color: lightGrey,),
            onTap: (){
              selectValueFromDropDown(
                context,
                getDrivingLicenseDropDownIndex() ?? 0, //Initial Item
                (index){
                  setState(() {
                    selectedDrivingLicense = drivingLicenseList[index]["name"];
                    selectedDrivingLicenseCode = drivingLicenseList[index]["code"];
                  });  
                },//On select function
                drivingLicenseList,//Drop down data list
                drivingLicenseList.map((value) => Center(
                  child: Text(value["name"],style: robotoWithColor(black, 16.0, 0.0),)
                )).toList(),//Display data in drop down
                (){
                  setState(() {
                    drivingLicenseController.text = selectedDrivingLicense != "" ? selectedDrivingLicense : drivingLicenseList[0]['name'] ;
                    drivingLicenseCode = selectedDrivingLicenseCode != "" ? selectedDrivingLicenseCode : drivingLicenseList[0]['code'];
                  });
                  Get.back();
                },
                MediaQuery.of(context).size.height * 0.24, //Height of the bottom sheet
              );
            },
          ),
          SizedBox(height: 20.h,),
          //Personal Vehicle
          CustomTextField(
            readOnly: true,
            controller: personalVechileController,
            labelText: 'personalVehicle'.tr,
            suffixIcon: const Icon(Icons.expand_more_rounded, color: lightGrey,),
            onTap: (){
              selectValueFromDropDown(
                context,
                getPersonalVehicleDropDownIndex() ?? 0, //Initial Item
                (index){
                  setState(() {
                    selectedPersonalVehicle = personalVehicleList[index]["name"];
                    selectedPersonalVehicleCode = personalVehicleList[index]["code"];
                  });  
                },//On select function
                personalVehicleList,//Drop down data list
                personalVehicleList.map((value) => Center(
                  child: Text(value["name"],style: robotoWithColor(black, 16.0, 0.0),)
                )).toList(),//Display data in drop down
                (){
                  setState(() {
                    personalVechileController.text = selectedPersonalVehicle != "" ? selectedPersonalVehicle : personalVehicleList[0]["name"];
                    personalVehicleCode = selectedPersonalVehicleCode != "" ? selectedPersonalVehicleCode : personalVehicleList[0]["code"] ;
                  });
                  Get.back();
                },
                MediaQuery.of(context).size.height * 0.24, //Height of the bottom sheet
              );
            },
          ),
          SizedBox(height: 80.h,),
        ],
      ),
    );
  }

  //Contacts Tab
  contactTab(){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          upperContactsTabSection(),
          SizedBox(height: 20.h,),
          //Current Address Section ----------
          currentAddressSection(),
          SizedBox(height: 30.h,),
          //Permanent Addrress Section ----------
          permanentAddressSection(),
          SizedBox(height: 30.h,),
          //Contact Person Section ----------
          contactPersonSection(),
          SizedBox(height: 30.h,),
          //Employee Refrence Section ---------
          employeeReferenceSection(),
          SizedBox(height: 80.h,),
        ],
      ),
    );
  }

  upperContactsTabSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Personal Email
        CustomTextField(
          readOnly: false,
          controller: personalEmailController,
          labelText: 'personalEmail'.tr,
        ),
        SizedBox(height: 20.h,),
        //Phone no
        CustomTextField(
          readOnly: false,
          validator: (value) {
            return value == null || value.isEmpty ? 'Contact is required' : null;
          },
          controller: phoneController,
          labelText: 'phoneNumber'.tr,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  currentAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("currentAddress".tr, style: poppins(15, 0, FontWeight.w500)),
        SizedBox(height: 10.h,),
        //state
        CustomTextField(
          controller: stateController,
          validator: (value) {
            return value == null || value.isEmpty ? 'Current State is required' : null;
          },
          onTap: (){
            selectValueFromDropDown(
              context, 
              getStateDropDownIndex() ?? 0,
              (value) {
                setState(() {
                  selectedCurrentState = stateList[value]["stateName"];
                  selectedCurrentStateCode = stateList[value]["stateCode"];
                  //Add district acc to selected provience
                  selectedCurrentDistrictList.clear(); //clear previous data
                  for(var data in stateList[value]["districts"]){
                    selectedCurrentDistrictList.add(
                      {
                        "districtName" : data.districtName,
                        "districtCode" : data.districtCode,
                        "stateCode" : data.stateCode,
                      }
                    );
                  }
                });
              },
              stateList, 
              stateList.map((value) => Center(
                child: Text(value["stateName"],style: robotoWithColor(black, 16.0, 0.0))
              )).toList(),
              (){
                setState(() {
                  stateController.text = selectedCurrentState != '' ? selectedCurrentState : stateList[0]["stateName"];
                  finalCurrentStateCode = selectedCurrentStateCode != '' && selectedCurrentStateCode != null ? selectedCurrentStateCode : stateList[0]["stateCode"];
                  //Add district acc to selected provience
                  districtList.clear(); //clear previous data
                  districtList = selectedCurrentDistrictList;
                  if(selectedCurrentDistrictList.isEmpty) {
                    int index = stateList.indexWhere((item) => item['stateName'] == stateController.text);
                    for(var data in stateList[index]["districts"]){
                      districtList.add(
                        {
                          "districtName" : data.districtName,
                          "districtCode" : data.districtCode,
                          "stateCode" : data.stateCode,
                        }
                      );
                    }
                  }
                  districtController.clear();
                });
                Get.back();
              }
            );
          },
          readOnly: true,
          labelText: "state".tr,
          suffixIcon: const Icon(Icons.expand_more_rounded, color: lightGrey,),
        ),
        SizedBox(height: 20.h,),
        //district
        CustomTextField(
          controller: districtController,
          validator: (value) {
            return value == null || value.isEmpty ? 'Current District is required' : null;
          },
          onTap: () {
            if(districtList.isEmpty){
              showMessage("Denied", "Select a Provience first!");
            } else{
              selectValueFromDropDown(
                context,
                getCurrentDistrictDropDownIndex() ?? 0,
                (value) => setState(() {
                  selectedCurrentDistrict = districtList[value]["districtName"];
                  selectedCurrentDistrictCode = districtList[value]["districtCode"];
                }),
                districtList,
                districtList.map((value) => Center(
                  child: Text(value["districtName"],style: robotoWithColor(black, 16.0, 0.0))
                )).toList(),
                (){
                  setState(() {
                    districtController.text = selectedCurrentDistrict != "" ? selectedCurrentDistrict : districtList[0]["districtName"];
                    finalCurrentDistrictCode = selectedCurrentDistrictCode != "" && selectedCurrentDistrictCode != null ? selectedCurrentDistrictCode : districtList[0]["districtCode"];
                  });
                  Get.back();
                }
              );
            }
          },
          readOnly: true,
          labelText: "district".tr,
          suffixIcon: const Icon(Icons.expand_more_rounded, color: lightGrey,),
        ),
        SizedBox(height: 20.h,),
        //city
        CustomTextField(
          readOnly: false,
          controller: cityController,
          labelText: 'city'.tr,
          validator: (value) {
            return value == null || value.isEmpty ? 'Current City is required' : null;
          },
        ),
        SizedBox(height: 20.h,),
        //Issued Date Nep
        CustomTextField(
          readOnly: false,
          controller: wardNoController,
          labelText: 'ward'.tr,
          keyboardType: TextInputType.number,
          validator: (value) {
            return value == null || value.isEmpty ? 'Current Ward is required' : null;
          },
        ),
        SizedBox(height: 20.h,),
        //address
        CustomTextField(
          readOnly: false,
          controller: addressController,
          labelText: 'addr'.tr,
          validator: (value) {
            return value == null || value.isEmpty ? 'Current Address is required' : null;
          },
        ),
      ],
    );
  }

  permanentAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("permanentAddress".tr, style: poppins(15, 0, FontWeight.w500)),
        SizedBox(height: 10.h,),
        //state
        CustomTextField(
          controller: permanentStateController,
          onTap: (){
            selectValueFromDropDown(
              context, 
              getPermanentStateDropDownIndex() ?? 0,
              (value) {
                setState(() {
                  selectedPermanentState = stateList[value]["stateName"];
                  selectedPermanentStateCode = stateList[value]["stateCode"];
                  //Add district acc to selected provience
                  selectedPermanentDistrictList.clear(); //clear previous data
                  for(var data in stateList[value]["districts"]){
                    selectedPermanentDistrictList.add(
                      {
                        "districtName" : data.districtName,
                        "districtCode" : data.districtCode,
                        "stateCode" : data.stateCode,
                      }
                    );
                  }
                });
              },
              stateList, 
              stateList.map((value) => Center(
                child: Text(value["stateName"],style: robotoWithColor(black, 16.0, 0.0))
              )).toList(),
              (){
                setState(() {
                  permanentStateController.text = selectedPermanentState != "" ? selectedPermanentState : stateList[0]["stateName"];
                  finalPermanentStateCode = selectedPermanentStateCode != "" && selectedPermanentStateCode != null ? selectedPermanentStateCode : stateList[0]["stateCode"];
                  int index = stateList.indexWhere((item) => item['stateName'] == permanentStateController.text);
                  //Add district acc to selected provience
                  permanentDistrictList.clear(); //clear previous data
                  permanentDistrictList = selectedPermanentDistrictList;
                  if(selectedPermanentDistrictList.isEmpty) {
                    for(var data in stateList[index]["districts"]){
                      permanentDistrictList.add(
                        {
                          "districtName" : data.districtName,
                          "districtCode" : data.districtCode,
                          "stateCode" : data.stateCode,
                        }
                      );
                    }
                  }
                  permanentDistrictController.clear();
                });
                Get.back();
              }
            );
          },
          readOnly: true,
          labelText: "state".tr,
          suffixIcon: const Icon(Icons.expand_more_rounded, color: lightGrey,),
        ),
        SizedBox(height: 20.h,),
        //district
        CustomTextField(
          controller: permanentDistrictController,
          onTap: () {
            if(permanentDistrictList.isEmpty){
              showMessage("Denied", "Select a Provience first!");
            } else{
              selectValueFromDropDown(
                context,
                getPermanentDistrictDropDownIndex() ?? 0,
                (value) => setState(() {
                  selectedPermanentDistrict = permanentDistrictList[value]["districtName"];
                  selectedPermanentDistrictCode = permanentDistrictList[value]["districtCode"];
                }),
                permanentDistrictList,
                permanentDistrictList.map((value) => Center(
                  child: Text(value["districtName"],style: robotoWithColor(black, 16.0, 0.0))
                )).toList(),
                (){
                  setState(() {
                    permanentDistrictController.text = selectedPermanentDistrict != "" ? selectedPermanentDistrict : permanentDistrictList[0]["districtName"];
                    finalPermanentDistrictCode = selectedPermanentDistrictCode != "" && selectedPermanentDistrictCode != null ? selectedPermanentDistrictCode : permanentDistrictList[0]["districtCode"];
                  });
                  Get.back();
                }
              );
            }
          },
          readOnly: true,
          labelText: "district".tr,
          suffixIcon: const Icon(Icons.expand_more_rounded, color: lightGrey,),
        ),
        SizedBox(height: 20.h,),
        //city
        CustomTextField(
          readOnly: false,
          controller: permanentCityController,
          labelText: 'city'.tr,
        ),
        SizedBox(height: 20.h,),
        //Issued Date Nep
        CustomTextField(
          readOnly: false,
          controller: permanentWardNoController,
          labelText: 'ward'.tr,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 20.h,),
        //address
        CustomTextField(
          readOnly: false,
          controller: permanentAddressController,
          labelText: 'addr'.tr,
        ),
      ],
    );
  }

  employeeReferenceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("employeeRefrence".tr, style: poppins(15, 0, FontWeight.w500)),
        SizedBox(height: 16.h,),
        //Employee Reference Form
        ListView.separated(
          separatorBuilder: (context, index) => SizedBox(height: 20.h),
          physics:  const NeverScrollableScrollPhysics(),
          itemCount: employeeReferrenceFormTextControllers.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(
                border: Border.all(color: grey500!, width: 1.sp),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                children: [
                  //Delete Employee Form
                  Row(
                    children: [
                      Text("Employee Reference Form ${index + 1}", style: poppins(16, 0, FontWeight.w400)),
                      const Spacer(),
                      Visibility(
                        visible: index == 0 ? false : true,
                        child: InkWell(
                          onTap: (){
                            employeeReferrenceFormTextControllers.removeAt(index);
                            setState(() {});
                          },
                          child: Container(
                            height: 30.sp,
                            width: 30.sp,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(2.r)
                            ),
                            child: const Icon(Icons.delete, color: white, size: 25,)
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h,),

                  CustomTextField(
                    controller: employeeReferrenceFormTextControllers[index]["name"],
                    readOnly: false,
                    labelText: "Name",
                  ),
                  SizedBox(height: 20.h,),
                  CustomTextField(
                    controller: employeeReferrenceFormTextControllers[index]["company"],
                    readOnly: false,
                    labelText: "Company",
                  ),
                  SizedBox(height: 20.h,),
                  CustomTextField(
                    controller: employeeReferrenceFormTextControllers[index]["address"],
                    readOnly: false,
                    labelText: "Address",
                  ),
                  SizedBox(height: 20.h,),
                  CustomTextField(
                    controller: employeeReferrenceFormTextControllers[index]["phone"],
                    readOnly: false,
                    labelText: "Phone",
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 20.h,),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 10.h,),
        CustomButton(
          text: "Add Employee Reference",
          color: green,
          height: 30.h,
          fontSize: 12.sp,
            onPressed:(){
            if(employeeReferrenceFormTextControllers.length <= 4){
              employeeReferrenceFormTextControllers.add(
                {
                  "name" : TextEditingController(),
                  "company" : TextEditingController(),
                  "address" : TextEditingController(),
                  "phone" : TextEditingController()
                }
              );
              setState(() {});
            } else{
              showMessage("Denied", "You cannot add more than 5 Employee Reference");
            }
          },
        ),
      ],
    );
  }

  contactPersonSection() {
    return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("contactPerson".tr, style: poppins(15, 0, FontWeight.w500)),
        SizedBox(height: 16.h,),
        //Contact person Form
        ListView.separated(
          separatorBuilder: (context, index) => SizedBox(height: 20.h),
          physics:  const NeverScrollableScrollPhysics(),
          itemCount: contactPersonControllers.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(
                border: Border.all(color: grey500!, width: 1.sp),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                children:  [
                  //Delete Contact Person Form
                  Row(
                    children: [
                      Text("Contact Person Form ${index + 1}", style: poppins(16, 0, FontWeight.w400)),
                      const Spacer(),
                      Visibility(
                        visible: index == 0 ? false : true,
                        child: InkWell(
                          onTap: (){
                            contactPersonControllers.removeAt(index);
                            setState(() {});
                          },
                          child: Container(
                            height: 30.sp,
                            width: 30.sp,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(2.r)
                            ),
                            child: const Icon(Icons.delete, color: white, size: 25,)
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h,),
                  CustomTextField(
                    controller: contactPersonControllers[index]["title"],
                    readOnly: false,
                    labelText: "Title",
                  ),
                  SizedBox(height: 20.h,),
                  CustomTextField(
                    controller: contactPersonControllers[index]["relationship"],
                    readOnly: false,
                    labelText: "Relationship",
                  ),
                  SizedBox(height: 20.h,),
                  CustomTextField(
                    controller: contactPersonControllers[index]["name"],
                    readOnly: false,
                    labelText: "Name",
                  ),
                  SizedBox(height: 20.h,),
                  CustomTextField(
                    controller: contactPersonControllers[index]["phone"],
                    readOnly: false,
                    labelText: "Phone",
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 20.h,),
                  CustomTextField(
                    controller: contactPersonControllers[index]["email"],
                    readOnly: false,
                    labelText: "Email",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20.h,),
                  CustomTextField(
                    controller: contactPersonControllers[index]["address"],
                    readOnly: false,
                    labelText: "Address",
                  ),
                  SizedBox(height: 20.h,),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 10.h,),
        //Add contact person
        CustomButton(
          color: green,
          height: 30.h,
          fontSize: 12.sp,
          text: "Add Contact Person",
          onPressed:(){
            if(contactPersonControllers.length < 5){
              contactPersonControllers.add(
                {
                  "title" : TextEditingController(),
                  "relationship" : TextEditingController(),
                  "name" : TextEditingController(),
                  "phone" : TextEditingController(),
                  "email" : TextEditingController(),
                  "address" : TextEditingController(),
                }
              );
              setState(() {});
            } else{
              showMessage("Denied", "You cannot add more than 5 contact person");
            }
          },
        ),
      ],
    );
  }


  //ConvertDate
  convertedDate(date){
    if(date != null && date != ""){
      var splitDate = date.toString().split("-");
      var convertedDate = DateTime(int.parse(splitDate[0]), int.parse(splitDate[1]), int.parse(splitDate[2]));
      return convertedDate;
    } else{
      return null;
    }
  }

  //Pick Image Function
  Future pickImage(ImageSource source) async {
    final croppedImageFile = await PickAndCropImage().pickAndCropImage(source);
    if (croppedImageFile == null) return;
    setState(() {
      write('pickedImage', croppedImageFile);
    });
  }

  //Pick Image bottom sheet
  changeImageBottomSheet(){
    showModalBottomSheet(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.2,
      ),
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 10.0) ,
        child: Column(
          children: [
            InkWell(
              onTap: () {
                pickImage(ImageSource.camera)
                .then((value) => Navigator.pop(context));
              },
              child: SizedBox(
                width: 280.0,
                height: 50.0,
                child:  Row(
                  children: const[
                    Icon(Icons.camera),
                    SizedBox(width: 15,),
                    Text('Camera', style: TextStyle(fontSize: 16),),
                  ],
                ),
              ),
            ),
            const Divider(),
            const SizedBox(height: 15,),
            InkWell(
              onTap: () {
                pickImage(ImageSource.gallery)
                .then((value) => Navigator.pop(context));
              },
              child:  SizedBox(
                width: 280.0,
                height: 50.0,
                child:  Row(
                  children: const[
                    Icon(Icons.image),
                    SizedBox(width: 15,),
                    Text('Gallery', style: TextStyle(fontSize: 16),),
                  ],
                ),
              ),
            ),
          ],
        )
      ),
    );
  }

  //Select Gender
  selectGender() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          width: 140.w,
          readOnly: true,
          controller: genderController,
          labelText: 'selectGender'.tr,
          suffixIcon: const Icon(Icons.expand_more_rounded, color: lightGrey,),
          validator: (value) {
            return value == null || value.isEmpty ? 'Gender is required' : null;
          },
          onTap: (){
            selectValueFromDropDown(
              context,
              getGenderDropDownIndex() ?? 0, //Initial Item
              (index){
                setState(() {
                  selectedGender = genderList[index]["name"];
                  selectedGenderCode = genderList[index]["code"];
                });  
              },//On select function
              genderList,//Drop down data list
              genderList.map((value) => Center(
                child: Text(value["name"],style: robotoWithColor(black, 16.0, 0.0),)
              )).toList(),//Display data in drop down
              (){
                setState(() {
                  genderController.text = selectedGender != "" ? selectedGender : genderList[0]["name"];
                  genderCode = selectedGenderCode != "" ? selectedGenderCode : genderList[0]["code"];
                });
                Get.back();
              },
              MediaQuery.of(context).size.height * 0.24, //Height of the bottom sheet
            );
          },
        ),
      ],
    );
  }

  //Select District Bottom sheet
  Future<dynamic> selectDistrictBottomSheet(type) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: white,
          height: MediaQuery.of(context).size.height*0.3,
          child: Column(
            children: [
              Expanded(
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(initialItem:type == "Current Address" ? getCurrentDistrictDropDownIndex() : getPermanentDistrictDropDownIndex()),
                  onSelectedItemChanged: (value) => setState(() {
                    if(type == "Current Address"){
                      districtController.text = districtList[value]["districtName"];
                      finalCurrentDistrictCode = districtList[value]["districtCode"];
                    } else {
                      permanentDistrictController.text = permanentDistrictList[value]["districtName"];
                      finalPermanentDistrictCode = districtList[value]["districtCode"];
                    }
                  }),
                  itemExtent: 40.sp,
                  children: type == "Current Address"
                    ? districtList.map((value) => Center(
                      child: Text(value["districtName"],style: robotoWithColor(black, 16.0, 0.0))
                    )).toList()
                    : permanentDistrictList.map((value) => Center(
                      child: Text(value["districtName"],style: robotoWithColor(black, 16.0, 0.0))
                    )).toList()
                ),
              )
            ],
          ),
        );
      }
    );
  }

  //Select Birth Date
  selectBirthDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          // width: 160.w,
          onTap: () async{
            var pickedBirthDate = await pickDate("English", "", convertedDate(widget.userData.data!.birthdayAd));
            birthDateController.text = pickedBirthDate;
            setState(() {});
          },
          controller: birthDateController,
          readOnly: true,
          keyboardType: TextInputType.number,
          labelText: "dateOfBirth".tr,
          suffixIcon: const Icon(Icons.calendar_month, color: pink,),
        ),
      ],
    );
  }

  //Select Issued Date Eng
  selectIssuedDateEng() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          onTap: () async{
            var date = await pickDate("English", "", convertedDate(issueDateController.text));
            issueDateController.text = date;
            setState(() {});
          },
          controller: issueDateController,
          readOnly: true,
          keyboardType: TextInputType.number,
          labelText: "issuedDate".tr,
          suffixIcon: const Icon(Icons.calendar_month, color: pink,),
        ),
      ],
    );
  }

  //Select Issued Date Nep
  selectIssuedDateNep([from]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          // width: 169.w,
          onTap: () async{
            var date = await pickDate("Nepali", from, convertedDate(issueDateNpController.text));
            issueDateNpController.text = date;
            setState(() {});
          },
          controller: issueDateNpController,
          readOnly: true,
          keyboardType: TextInputType.number,
          labelText: "issuedDateNp".tr,
          suffixIcon: const Icon(Icons.calendar_month, color: pink,),
        ),
      ],
    );
  }

  //PickDate
  pickDate(type, [from, initialDate]) async{
    if(type == "English"){
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
      var englishDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day).toString();
        return DateFormat('yyyy-MM-dd').format((DateTime.parse(englishDateTime))).toString();
      } else{
        return;
      }
    } else{
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

        //Formatt date
        if(pickedDate != null ){
        var nepaliDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day).toString();
        //if for issue date
        if(from == 'citizen') {
          issueDateController.text = DateFormat('yyyy-MM-dd').format(NepaliDateTime(pickedDate.year, pickedDate.month, pickedDate.day).toDateTime()).toString();
          setState(() { });
        }
          return DateFormat('yyyy-MM-dd').format((DateTime.parse(nepaliDateTime))).toString();
        } else{
          return;
        }
      }
    }
  }

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}