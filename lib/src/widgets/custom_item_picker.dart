import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hris/src/helper/style.dart';

Future<dynamic> selectValueFromDropDown(
    context,
    initialItem, 
    Function(int)? onSelectedItemChanged, 
    List<Map<String, 
    dynamic>> dataList, 
    List<Widget> displayWidgets,
    onTap,
    [dropDownHeight]
  ) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: white,
          height: dropDownHeight ?? MediaQuery.of(context).size.height*0.3,
          child: Column(
            children: [
              Expanded(
                child: InkWell(
                  onTap: onTap,
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(initialItem: initialItem),
                    onSelectedItemChanged: onSelectedItemChanged,
                    itemExtent: 40.sp,
                    children: displayWidgets
                  ),
                ),
              )
            ],
          ),
        );
      }
    );
  }