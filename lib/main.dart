import 'dart:async';
import 'dart:isolate';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:notrip/constants/material_color.dart';
import 'package:notrip/controllers/location_info_controller.dart';
import 'package:notrip/pages/articles/articles_page.dart';
import 'package:notrip/pages/login/auth_screen.dart';
import 'package:notrip/pages/scraps/scrap_page.dart';
import 'package:notrip/pages/community/community_page.dart';
import 'package:notrip/pages/home/home_page.dart';
import 'package:notrip/pages/initial_page.dart';
import 'package:notrip/pages/mypages/my_page.dart';
import 'package:notrip/tools/permision_tool.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screen_state/screen_state.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'constants/common_size.dart';
import 'controllers/api_data_controller.dart';
import 'controllers/login_controller.dart';
import 'controllers/notification_controller.dart';
import 'controllers/shared_pref_controller.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}
void main() async{
  KakaoContext.clientId = "926b197ec58d6ad48ed184a7cfa02f88";
 // KakaoContext.javascriptClientId= "카카오 javascript 키";
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: BindingsBuilder((){
        Get.put(SharedPrefController());
        Get.put(LoginController());
        Get.put(NotificationController());
        Get.put(LocationInFoController());
        Get.put(ApiDataController());
      }),
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: maincolor,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          color: appbarBackgroundColor,
          titleTextStyle: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(color: accentColor),
        elevation: 1,
        ),
        primaryTextTheme: Theme.of(context).primaryTextTheme.apply(bodyColor: accentColor),
      ),
     home: Get.put(SharedPrefController()).getBooleanPref("TutorialDone") ? InitialPage(): InitialPage(),
      //home: Get.put(SharedPrefController()).getBooleanPref("TutorialDone") ? AuthScreen() : AuthScreen(),
    );
  }
}

class TutorialPage extends StatefulWidget {
  const TutorialPage({Key key}) : super(key: key);

  @override
  _TutorialPageState createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  int _page = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(
        children: [
          Image.network("https://picsum.photos/200"),
          Text('안녕하세요'),
        ],
      )),

    );
  }
}



