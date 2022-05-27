import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notrip/controllers/login_controller.dart';
import 'package:notrip/pages/login/auth_screen.dart';
import 'package:notrip/pages/home/home_page.dart';
import 'package:notrip/tools/enums.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({Key key}) : super(key: key);

  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  @override
  Widget build(BuildContext context) {
    //Get.find<LoginController>().firebaseUser!=null? Get.off(() =>Homepage()): Get.off(() =>AuthScreen());
    return  Container(
      color:  Colors.white,
    );
  }
}
