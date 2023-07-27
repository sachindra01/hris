import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hris/src/helper/style.dart';

class TodaysUpdateTile extends StatelessWidget {
  final Icon icon;
  final String title;
  final Color borderColor;
  final Color backgroundColor;
  final String employeeCount;
  const TodaysUpdateTile({
    super.key, required this.icon, required this.title, required this.borderColor, required this.backgroundColor, required this.employeeCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 53.h,
      width: 99.w,
        padding: EdgeInsets.only(top: 10.h, bottom: 5.h, right: 8.w, left: 8.w),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: borderColor,
            width: 1.2.sp
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Icon
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: white
              ),
              height: 26.h,
              width: 26.w,
              child: icon,
            ),
            SizedBox(width: 8.0.w),
            //Tile Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 45.w,
                  child: Text(title,style: robotoWithColor(lightBlack, 12, 0.0, FontWeight.bold)),
                ),
                SizedBox(
                  width: 40.w,
                  child: Text(employeeCount,style: robotoWithColor(borderColor, 16, 0.0)),
                ),
              ],
            )
          ],
        ),
    );
  }
}