import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hris/src/controller/app_controller.dart';
import 'package:hris/src/helper/read_write.dart';
import 'package:hris/src/helper/themes.dart';
import 'package:hris/src/helper/translations.dart';
import 'package:hris/src/services/notification_services.dart';
import 'package:hris/src/view/common/splash.dart';

Future<void> backgroundHandler(RemoteMessage message)async{
  debugPrint(message.data.toString());
  //Display notification
  NotificationService.display(message);
  // debugPrint(message.notification!.title.toString());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppController _con = Get.put(AppController());

  @override
  void initState() {
    super.initState();
    _con.checkInitialConnectivity();
    NotificationService().requestNotificationPermission();
    NotificationService().getPushedNotification(context);
    NotificationService().getFcmToken();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 780),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context,child) {
        return NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator(); //hide overscroll color
            return true;
          },
          child: GetMaterialApp(
            builder: FToastBuilder(),
            title: 'HRIS',
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.system, 
            theme: MyTheme.lightTheme,
            darkTheme: MyTheme.darkTheme,
            home: const SplashScreen(),
            translations: AppTranslations(),
            locale: read('lang') == "" ? Get.deviceLocale : Locale(read('lang')) ,
            fallbackLocale: const Locale('en', 'US'),
          ),
        );
      }
    );
  }
}