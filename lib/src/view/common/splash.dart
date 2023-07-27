import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris/src/controller/app_controller.dart';
import 'package:hris/src/helper/read_write.dart';
import 'package:hris/src/view/auth_pages/login.dart';
import 'package:hris/src/view/common/bottom_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AppController _appCon = Get.put(AppController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(read('isDarkMode') == null || read('isDarkMode') == "") {
        write('isDarkMode', Get.isDarkMode);
      } else {
        Get.changeThemeMode(
          read('isDarkMode') ? ThemeMode.dark : ThemeMode.light
        );
      }
      _appCon.canUseBiometric();
    });
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () {
        if(read("apiToken") == null || read("apiToken") == ''){
          Get.off(() => const Login());
        } else{
          if (kDebugMode) {
            print("Bearer Token  => ${read("apiToken")}");
          }
          Get.off(() => const BottomNavigation()); 
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode()
          ? const Color(0xFF1C2A39)
          : const Color(0xFFFFFFFF),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width * 0.75,
          child: Image.asset(
            isDarkMode()
              ? 'assets/images/splash_dark.png'
              : 'assets/images/splash_light.png'
            )
        )
      )
    );
  }

  isDarkMode() {
    return read('isDarkMode') == ""
      ? Get.isDarkMode 
        ? true
        : false
      : read('isDarkMode')
        ? true
        : false;
  }
}