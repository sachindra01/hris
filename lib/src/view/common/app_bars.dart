import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hris/src/helper/style.dart';

AppBar homeAppBar(scaffoldKey) {
  return AppBar(
    backgroundColor: Colors.transparent,
    title: Text("Home", style: roboto(18, 0.5)),
    centerTitle: true,
    elevation: 0.0,
    // leading:  GestureDetector(
    //   child: const Icon(Icons.menu, color: pink,),
    //   onTap: () {
    //     scaffoldKey.currentState!.openDrawer();
    //   },
    // ),
    actions: [
      Padding(
        padding: EdgeInsets.all(10.0.sp),
        child: InkWell(
          onTap: (){
          },
          child: Stack(
            children: [
              Icon(Icons.notifications_outlined, color: Get.isDarkMode ? white : grey700,),
              //Use Later
              Positioned(
                top: 4,
                right: 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child:Container( 
                    height: 7.0,
                    width: 7.0,
                    color:  const Color(0xffF11F00),
                  ),
                ),
              )
            ],
          ),
        ),
      ) 
    ],
  );
}