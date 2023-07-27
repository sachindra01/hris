import 'package:flutter/material.dart';
import 'package:get/get.dart';

customAlertDialog(yesText, yesAction, noText, noAction, message) {
  return Get.dialog(
    AlertDialog(
      content: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
        child: Text(
          message,
          textAlign: TextAlign.center
        ),
      ),
      contentPadding: const EdgeInsets.only(top: 8.0),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green
          ),
          onPressed: () {
            Get.back();
            yesAction();
          },
          child: Text(yesText)
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red
          ),
          onPressed: noAction, 
          child: Text(noText)
        )
      ],
    ),
  );
}