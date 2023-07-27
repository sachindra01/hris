import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris/src/helper/style.dart';

customAppbar(context, title, [leading, action]){
  return AppBar(
    elevation: 1,
    title: Text(title, style : notoSans(Get.isDarkMode ? white : black, 17.0, 0.0)),
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    leading: leading,
    actions: [
      action ?? const SizedBox(),
    ],
  );
}