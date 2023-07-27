import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

customLoading(context){
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: SizedBox(
          height:  35.h,
          width: 35.h,
          child: const CircularProgressIndicator()
        ),
      ),
    ),
  );
}