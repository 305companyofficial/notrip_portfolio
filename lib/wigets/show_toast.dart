import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
void showToast(String message) {
  print('시스템 : toast message-> '+message);
  Fluttertoast.showToast(
    fontSize: 16,
      msg: message,
      textColor: Colors.grey[50],
      backgroundColor: Colors.black54,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM);
}

