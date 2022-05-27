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
import 'package:notrip/constants/material_color.dart';
import 'package:notrip/interface/page_move.dart';
import 'package:notrip/pages/articles/articles_page.dart';
import 'package:notrip/pages/scraps/scrap_page.dart';
import 'package:notrip/pages/community/community_page.dart';
import 'package:notrip/pages/home/home_page.dart';
import 'package:notrip/pages/mypages/my_page.dart';
import 'package:notrip/tools/permision_tool.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screen_state/screen_state.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'constants/common_size.dart';
import 'controllers/notification_controller.dart';
import 'controllers/shared_pref_controller.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: BindingsBuilder((){
        Get.put(SharedPrefController());
        //Get.put(LoginController());
        Get.put(NotificationController());
      }),
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: maincolor,
        appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: accentColor)),
        primaryTextTheme: Theme.of(context).primaryTextTheme.apply(bodyColor: accentColor),
      ),
      home: Get.put(SharedPrefController()).getBooleanPref("TutorialDone") ? MyMainPage() : MyMainPage(),
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



class MyMainPage extends StatefulWidget {
  MyMainPage({Key key,}) : super(key: key);
  @override
  _MyMainPageState createState() => _MyMainPageState();
}
class _MyMainPageState extends State<MyMainPage> implements PageMove{
  List<BottomNavigationBarItem> btmnavItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home_outlined, size: bottomNavigationBarItemSize, ), label: '홈', ),
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.search, size: bottomNavigationBarItemSize,), label: '검색'),
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.add, size: bottomNavigationBarItemSize,), label: '추가'),
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.floppy_disk, size: bottomNavigationBarItemSize,), label: '관리'),
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.person, size: bottomNavigationBarItemSize,), label: '마이'),
  ];
  int _pageindex = 0;
  List<Widget> _screens ;

  @override
  void initState() {
    _screens = <Widget>[
      CommunityPage(), ArticlesPage(), Homepage(goPage),   ScrapPage(), MyPage()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        Scaffold(
            body: IndexedStack(
              index: _pageindex,
              children : _screens,
            ),
            /* floatingActionButton: FloatingActionButton(
                  onPressed: (){
                    Get.find<LoginController>().signOut();
                  },
                  //tooltip: 'Increment',
                  child: Icon(Icons.filter_alt_outlined),
                ),*/
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              items: btmnavItems,
              unselectedItemColor : Colors.black54,
              selectedItemColor : maincolor,
              onTap: (index){
                setState(() {
                  _pageindex = index;
                });
              },
              currentIndex: _pageindex,)
        ),
        Visibility(
          visible: false,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height:  double.infinity,
                color: Colors.black87.withOpacity(0.7),
              ),
              Center(child: SizedBox(
                width: 50, height: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 8,
                  color: Colors.white,
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void goPage(int pagenum) {

  }


}
