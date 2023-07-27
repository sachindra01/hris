import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hris/src/controller/app_controller.dart';
import 'package:hris/src/controller/auth_controller.dart';
import 'package:hris/src/helper/read_write.dart';
import 'package:hris/src/helper/style.dart';
import 'package:hris/src/view/profile/edit_profile.dart';
import 'package:hris/src/widgets/cached_network_image.dart';
import 'package:hris/src/widgets/custom_alert_dialog.dart';
import 'package:hris/src/widgets/gradient_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //Controllers
  final AuthController _authCon = Get.put(AuthController());
  final AppController _appCon = Get.put(AppController());

  bool _isDarkMode = false;
  bool notification = false;
  bool biometrics = false;
  List language = ['English', 'नेपाली'];
  List datePref = ['AD','BS'];

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        getProfileData();       //Get necessary profile data for edit profile
        var biometricsEnabled = read('biometricsEnabled');      //Check Biometrics
        biometrics = biometricsEnabled == "" ? false : biometricsEnabled;        
        _isDarkMode = read('isDarkMode');     // ThemeMOde
      });
    }
  }

  getProfileData() async {
    await _authCon.getProfileData();
    notification = _authCon.userProfileData!.data!.notification!;
    if(mounted){
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40.h),
            //Profile Section
            profileSection(),
            SizedBox(height: 15.h),
            //Settings Section
            settingsSection(context),
            //Version
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('version'.tr),
                const Text(" : 1.0.0"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //Profile section
  profileSection() {
    var profileInfo = read('loginInfo');
    return Container(
      padding: EdgeInsets.all(15.sp),
      child: SizedBox(
        height: 210.h,
        child: Column(
          children: [
            // Profile Image
            DisplayNetworkImage(
              imageUrl: profileInfo['profile_image_url'],
              height: 100.h,
              width: 100.h,
            ),
            SizedBox(
              height: 10.h,
            ),
            //UserName
            Text(
              profileInfo['full_name']!,
              style: poppins(16, 0),
            ),
            //User Email
            Text(
              profileInfo['official_email']!,
              style: poppins(14, 0),
            ),
            SizedBox(
              height: 15.h,
            ),
            //Edit Profile Button
            Obx(() => _authCon.isProfileLoading.value
              ? GradientButton(
                text: "loading".tr,
                height: 35.h,
                borderRadius: 100.r,
                onPressed: () {}
              )
              : GradientButton(
                text: "editProfile".tr,
                height: 35.h,
                borderRadius: 100.r,
                onPressed: () {
                  Get.to(() => EditProfilePage(
                    userData: _authCon.userProfileData!,
                  ));
                }
              )
            ),
          ],
        ),
      )
    );
  }

  //Settings Section
  settingsSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0.sp),
      child: Container(
        decoration: BoxDecoration(
            color: _isDarkMode ? black : grey100,
            borderRadius: BorderRadius.circular(30.r)),
        padding: EdgeInsets.all(6.sp),
        child: Column(
          children: [
            //Notification
            ListTile(
              leading: const Icon(Icons.notifications),
              title: Text('notification'.tr, style: poppins(16, 0)),
              trailing: Switch(
                activeColor: Theme.of(context).primaryColor,
                value: notification,
                onChanged: (value) async {
                  setState(() {
                    notification = value;
                  });
                  await _authCon.updateNotification(value);
                  await getProfileData();
                  write('notificationEnabled', value);
                  setState(() {});
                },
              ),
            ),
            //Dark Mode
            ListTile(
              leading: const Icon(Icons.color_lens_rounded),
              title: Text('darkMode'.tr, style: poppins(16, 0)),
              trailing: Switch(
                activeColor: Theme.of(context).primaryColor,
                value: _isDarkMode,
                onChanged: (value) {
                  Get.changeThemeMode(
                    _isDarkMode ? ThemeMode.light : ThemeMode.dark,
                  );
                  setState(() {
                    _isDarkMode = !_isDarkMode;
                  });
                  write('isDarkMode', _isDarkMode);
                },
              ),
            ),
            //Biometrics
            Visibility(
              visible: _appCon.canAuthenticateWithBio,
              child: ListTile(
                leading: const Icon(Icons.color_lens_rounded),
                title: Text('biometric'.tr, style: poppins(16, 0)),
                trailing: Switch(
                  activeColor: Theme.of(context).primaryColor,
                  value: biometrics,
                  onChanged: (value) {
                    setState(() {
                      biometrics = value;
                    });
                    write('biometricsEnabled', biometrics);
                  },
                ),
              ),
            ),
            //Language
            ListTile(
              leading: const Icon(Icons.language),
              title: Row(
                children: [
                  Text("${'language'.tr}  (${Get.locale!.languageCode == "en" ? "Eng" : "नेपाली"})" , style: poppins(16, 0)),
                ],
              ),
              trailing: DropdownButtonHideUnderline(
                child: DropdownButton(
                  icon: const Icon(Icons.keyboard_arrow_down),
                  borderRadius: BorderRadius.circular(0.0),
                  items: language.map<DropdownMenuItem<String>>((val) {
                    return DropdownMenuItem<String>(
                        value: val, child: Text(val));
                  }).toList(),
                  onChanged: (newVal) {
                    var locale = Locale(newVal == 'English' ? 'en' : 'np');
                    write('lang', newVal == 'English' ? 'en' : 'np');
                    setState(() {});
                    Get.updateLocale(locale);
                  },
                ),
              )
            ),
            //Date Preference
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: Row(
                children: [
                  Text(
                    '${'datePreference'.tr} (${"${read('datePref') == "" || read('datePref') == null ? 'AD' : read('datePref')}".tr})'  , 
                    style: poppins(16, 0)
                  ),
                ],
              ),
              trailing: DropdownButtonHideUnderline(
                child: DropdownButton(
                  icon: const Icon(Icons.keyboard_arrow_down),
                  borderRadius: BorderRadius.circular(0.0),
                  items: datePref.map<DropdownMenuItem<String>>((val) {
                    return DropdownMenuItem<String>(
                        value: val, child: Text(val));
                  }).toList(),
                  onChanged: (newVal) {
                    write('datePref', newVal);
                    setState(() {});
                  },
                ),
              )
            ),
            //About us
            ListTile(
              leading: const Icon(Icons.info_rounded),
              title: Text('aboutUs'.tr, style: poppins(16, 0)),
              onTap: () => aboutUsDialog(),
            ),
            //Logout
            ListTile(
              leading: const Icon(Icons.logout_rounded),
              title: Text('logOut'.tr, style: poppins(16, 0)),
              onTap: () {
                customAlertDialog(
                    'Yes',
                    () => _authCon.logOut(read("apiToken"), context),
                    'No',
                    () => Get.back(),
                    'You are about to logout. Are you sure?');
                // Get.to(()=> const Login());
              },
            ),
          ],
        ),
      ),
    );
  }

  aboutUsDialog() {
    return Get.dialog(
      AlertDialog(
        title: const Center(child: Text('About HRIS')),
        content: SizedBox(
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(' - Manage Employee Data'),
                  Text(' - Paperless Leave Application'),
                  Text(' - Centralized HR Information'),
                  SizedBox(height: 12.0),
                  Text('Contact Us'),
                  Text('Miracle Interface'),
                  Text('www.miracleinterface.com.np'),
                  Text('01-5011302 / 01-5011303'),
                  Text('Jwagal, Kupondole, Lalitpur'),
                ]),
          ),
        ),
        contentPadding: const EdgeInsets.only(top: 8.0),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor),
              onPressed: () => Get.back(),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              )),
        ],
      ),
    );
  }

  //Check notification permission status
  // checkStatus() async{
  //   var notificationPermissionStatus = await Permission.notification.status;
  //   if(notificationPermissionStatus.isGranted){
  //     setState(() {
  //       notification = true;
  //     });
  //   } else {
  //     setState(() {
  //       notification = false;
  //     });
  //   }
  // }
}
