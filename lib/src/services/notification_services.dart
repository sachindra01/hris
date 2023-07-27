import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationService{
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //Ask for notification permission
  void requestNotificationPermission() async {
    await _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.requestPermission();
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // User granted permission
      messaging.subscribeToTopic('your_topic_name');
      // Initialize notification services
      // ...
    } else {
      _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.requestPermission();
      // User denied permission or notifications are disabled by the device
      // await messaging.requestPermission(
      //   alert: true,
      //   badge: true,
      //   sound: true,
      // );
      // ...
    }
  }

  //Recieve Push Notification
  getPushedNotification(BuildContext context){
    //On Backgorund Message app terminated
    FirebaseMessaging.instance.getInitialMessage().then((message){
      if(message != null){
        display(message);
      // final routeFromNotification = message.data["route"];
      // navigatorKey.currentState!.pushNamed(routeFromNotification);
      // Navigator.pushNamed(context, routeFromNotification);
      }
    });

    //On Foreground Message
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint(message.notification!.title);
      debugPrint(message.notification!.body);
      if(kIsWeb){
        Get.snackbar(
          message.notification!.title.toString(), 
          message.notification!.body.toString(),
          // icon: CachedNetworkimage(
          // imageUrl :message.data["imageUrl"].toString(),
          // ),
        );
      } else{
        //initialize local notification
        initialize(context);
        display(message);
      }
    });

    //On Backgorund Message
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      display(message);
      // final routeFromNotification = message.data["route"];
      // navigatorKey.currentState!.pushNamed(routeFromNotification);
    });
  }

  //initialize local notification and creating channel
  void initialize(BuildContext context){
    //local notification initialization
    final InitializationSettings initializationSettings = InitializationSettings( 
      android: const AndroidInitializationSettings("@drawable/app_icon"),
      iOS: IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) => {
          1,
          "IOS Title", 
          "IOS Body", 
            {
              "to" : "my_fcm_token",
              "notification" : {
                "body" : "sample body",
                "OrganizationId":"2",
                "content_available" : true,
                "mutable_content": true,
                "priority" : "high",
                "subtitle":"sample sub-title",
                "Title":"hello"
                },
              "data" : {
                "msgBody" : "Body of your Notification",
                "msgTitle": "Title of your Notification",
                "msgId": "000001",
                "data" : "This is sample payloadData"
              }
            }
          },
      ),
    );
    _notificationsPlugin.initialize(initializationSettings, onSelectNotification: (String? payload) async{
      // if(payload != null){
      //   navigatorKey.currentState!.pushNamed(payload);
      // }
    });
  }

  //Get Fcm Token
  getFcmToken() async{
    String? fcm = await messaging.getToken();
    debugPrint("fcm -> $fcm");
    return fcm;
  }

  //To display on foreground and create a channel
  static void display(RemoteMessage message) async{
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/1000;
      const   NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "Hris", //channelId
          "channel Hris", //channelName
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: IOSNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          sound: "Sd",
          badgeNumber: 2,
          threadIdentifier: "IOs",
          subtitle: "IOStrue",)
      );
      
      await _notificationsPlugin.show(
        id,
        message.notification!.title, 
        message.notification!.body, 
        notificationDetails,
        // payload: message.data['route'],
      );
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  //For Ios
  notificationInitialization() async {
    if (Platform.isIOS) {
      iosPermissionHandler();
    }
    _requestPermissions();
    String? fcm = await messaging.getToken();
    debugPrint('FCM Token => $fcm');
  }

  iosPermissionHandler() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    debugPrint('User granted permission: ${settings.authorizationStatus}');
  }

  void _requestPermissions() {
    _notificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
      );
    _notificationsPlugin.resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
      );
  }
}