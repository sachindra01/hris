import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

showCustomToast(context, title, [message, icon]){
  FToast fToast = FToast();
  fToast.init(context);
  
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    width: MediaQuery.of(context).size.width *0.9,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
        color: const Color.fromARGB(141, 105, 240, 175),
      ),
      child: Row(
        children: [
          const Icon(Icons.check),
          const SizedBox(
            width: 12.0,
          ),
          Text(title ?? "Toast Message"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      toastDuration: const Duration(seconds: 2),
      positionedToastBuilder: (context, child) {
        return Positioned(
          top: 40.h,
          left: 17.4.w,
          child: child,
        );
      }
    );
  }