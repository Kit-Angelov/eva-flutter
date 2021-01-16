import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

showWaitDialog(BuildContext context) {
  CupertinoAlertDialog alert = CupertinoAlertDialog(
      content: Center(
    child: CircularProgressIndicator(
      backgroundColor: Colors.transparent,
      valueColor:
          new AlwaysStoppedAnimation<Color>(Color.fromRGBO(44, 62, 80, 1)),
    ),
  ));

  // show the dialog
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
