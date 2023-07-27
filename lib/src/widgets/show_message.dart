import 'package:get/get.dart';
import 'package:hris/src/helper/style.dart';

showMessage(title, content) {
  return Get.snackbar(
    title, 
    content,
    colorText: Get.isDarkMode ? white : black
  );
}