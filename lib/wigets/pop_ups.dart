

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notrip/pages/login/auth_screen.dart';

CupertinoButton popUpMenu(String msg, {TextStyle style, VoidCallback goPressed, Color color}) {
  return CupertinoButton(
      child: Text(
        msg,
        style: style??TextStyle(color: color??Colors.blue),
      ),
      onPressed: goPressed
  );
}
Future<bool> exitApp(BuildContext context) {
   return showDialog(
      context: context,
      builder: (context) =>  CupertinoAlertDialog(
        title:  Text('앱을 종료하시겠습니까?'),
        actions: <Widget>[
          popUpMenu('아니오',  goPressed: ()=>Navigator.of(context).pop(false), style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          popUpMenu('예',  goPressed: ()=>Navigator.of(context).pop(true), style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        ],
      ),
  );
}

Future<bool> cancelEnroll() {
  return Get.dialog(
      CupertinoAlertDialog(
        title:  Text('이전으로 돌아가시면 저장이 되지 않습니다.\n그래도 돌아가시겠습니까?'),
        actions: <Widget>[
          popUpMenu('아니오',  goPressed: ()=>Get.back(), style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          popUpMenu('예',  goPressed: ()=>Get.off(AuthScreen()), style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        ],
      )
  );
}

Future<bool> secessionEnroll() {
  return Get.dialog(
      CupertinoAlertDialog(
        title:  Text('정말 탈퇴하시겠습니까?'),
        content: Text("탈퇴하면 해당 계정의 모든 정보가 삭제되며 다시 복구할 수 없습니다."),
        actions: <Widget>[
          popUpMenu('취소',  goPressed: ()=>Get.back(), style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          popUpMenu('탈퇴',  goPressed: ()=>Get.back(), style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        ],
      )
  );
}
