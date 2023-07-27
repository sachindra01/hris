import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hris/src/helper/style.dart';

class NoticeTile extends StatelessWidget {
  final String title;
  final Color statusColor;
  final VoidCallback ontap;
  const NoticeTile({
    super.key, required this.title, required this.statusColor, required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        color: Theme.of(context).cardColor,
        height: 62.h,
        child: Row(
          children: [
            //Status Indicator
            Container(
              width: 3.w,
              decoration: BoxDecoration(
                color: statusColor,
              ),
            ),
            const SizedBox(
              width: 14.0,
            ),
            //Manifest info
            Container(
              width : MediaQuery.of(context).size.width*0.69,
              padding: const EdgeInsets.only(
                top: 12,
                bottom: 10,
              ),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //Manifest Name
                  Text(
                    title,
                    style: roboto(14, 0.5),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ] 
              ),
            ),
            const Spacer(),
            //Arrow
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left : 8.0),
                child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade600, size: 19,),
              ),
            ),
            SizedBox(width: 14.w,)
          ],
        ),
      ),
    );
  }
}