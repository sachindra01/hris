import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hris/src/controller/auth_controller.dart';
import 'package:hris/src/helper/read_write.dart';
import 'package:hris/src/model/option_item_model.dart';
import 'package:hris/src/model/state_list_model.dart';
import 'package:hris/src/widgets/show_message.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:hris/src/repositary/api_repo.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class AppController extends GetxController {
  final LocalAuthentication auth = LocalAuthentication();
  final AuthController _authCon = Get.put(AuthController());

  bool canUseBiometic = false;
  RxBool online = true.obs;
  RxBool isLoading = false.obs;
  bool canAuthenticateWithBio = false;
  List provinces = [];
  List provinceList = [];
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;

  @override
  void onInit() {
    getDeviceId();
    super.onInit();
  }

  startLoading(){
    isLoading(true);
    update();
  }

  stopLoading(){
    isLoading(false);
    update();
  }

  checkInitialConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      try {
        var response = await http.get(Uri.parse("https://www.google.com"));
        if (response.statusCode == 200) {
          online.value = true;
        } else {
          online.value = false;
        }
      } catch(e) {
        online.value = false;
      }
    } else {
      online.value = false;
    }
    checkForConnectivityChange();
    return online.value;
  }

  checkForConnectivityChange() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
        try {
          var response = await http.get(Uri.parse("https://www.google.com"));
          if (response.statusCode == 200) {
            online.value = true;
          } else {
            online.value = false;
          }
        } catch(e) {
          online.value = false;
        }
      } else {
        online.value = false;
      }
    });
  }

  getDeviceId() async {
    String? deviceId = await PlatformDeviceId.getDeviceId;
    write('deviceId', deviceId);
    if (kDebugMode) {
      print(deviceId);
    }
    return deviceId;
  }

  canUseBiometric() async {
    final bool canAuthenticateWithBiometrics  = await auth.canCheckBiometrics;
    final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    var biometricsEnabled = read('biometricsEnabled') == "" ? false : read('biometricsEnabled') == false ? false : true;
    canAuthenticateWithBio = canAuthenticate;
    if(canAuthenticate && biometricsEnabled) {
      canUseBiometic = true;
    } else {
      canUseBiometic = false;
    }
  }

  authenticate(context) async {
    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to login',
        options: const AuthenticationOptions(useErrorDialogs: false)
      );
      if(didAuthenticate) {
        var data = read('loginInfo');
        await _authCon.logIn(data['official_email'], data['password'], data['organization_code'], context);
      }
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        // Add handling of no hardware here.
      } else if (e.code == auth_error.notEnrolled) {
        // ...
      } else {
        // ...
      }
    }
  }

  getState() async{
    try {
      startLoading();
      var response = await ApiRepo.apiGet('api/stateList', '');
      if(response["success"] == true){
        final data = StateListModel.fromJson(response);
        return data;
      } else {
        showMessage("An Error Occured!", "Cannot load Data");
      }
    } catch (e) {
      showMessage("An Error Occured!", e.toString());
    } finally{
    }
  }

  getOptionItemLists() async{
    try {
      var response = await ApiRepo.apiGet('api/optionItemList', '');
      if(response["success"] == true){
        final data = OptionItemModel.fromJson(response);
        return data;
      } else {
        showMessage("An Error Occured!", "Cannot load Data");
      }
    } catch (e) {
      showMessage("An Error Occured!", e.toString());
    } finally{
      stopLoading();
    }
  }

  void getGeoLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (kDebugMode) {
          print('Location permissions are denied');
        }
      }else if(permission == LocationPermission.deniedForever){
        if (kDebugMode) {
          print("'Location permissions are permanently denied");
        }
      }else{
        if (kDebugMode) {
          print("GPS Location service is granted");
        }
        getLocation();
      }
    }
    else{
      if (kDebugMode) {
        print("GPS Location permission granted.");
      }
      getLocation();
    }
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (kDebugMode) {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457
    }
    long = position.longitude.toString();
    lat = position.latitude.toString();
    write('longitude', long);
    write('latitude',lat);
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a 
      //device must move horizontally before an update event is generated;
    );
    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings).listen((Position position) {
      long = position.longitude.toString();
      lat = position.latitude.toString();
      write('longitude', long);
      write('latitude',lat);
    });
    if (kDebugMode) {
      print(positionStream);
    }
  }

  getDayInWord(String dateString, datePref){
    DateTime date = DateTime.parse(dateString);
    final formatter = DateFormat.EEEE(); // 'EEEE' for full day name, 'EEE' for abbreviated day name
    final nepFormatter = NepaliDateFormat.EEEE();
    
    if(read('datePref') == "" || read('datePref') == "AD" || read('datePref' ) == null){
      return formatter.format(date).substring(0,3);
    } else {
      return nepFormatter.format(NepaliDateTime(date.year, date.month, date.day)).substring(0,3);
    }
  }
}