import 'package:flutter/material.dart';

customDialogBox(context, widget){
  return showDialog(
    context: context, 
    builder: (context){
      return StatefulBuilder(builder: (ctx, setState) {
          return Dialog(
            insetPadding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04,
                vertical: MediaQuery.of(context).size.height * 0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: widget,
          );
        }
      );
    },
  );
}

