import 'dart:async';
import 'dart:isolate';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:notrip/tools/permision_tool.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screen_state/screen_state.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() => runApp(ExampleApp());

// The callback function should always be a top-level function.
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(FirstTaskHandler());
}
int checkinterval = 2000;
int totalcheckmin= 60000;


class FirstTaskHandler implements TaskHandler {
  int updateCount = 0;

  @override
  Future<void> onStart(DateTime timestamp, SendPort sendPort) async {
    // You can use the getData function to get the data you saved.
    final customData = await FlutterForegroundTask.getData<String>(key: 'customData');
    startListeningScreen();
    print('start customData: $customData');

  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort sendPort) async {
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final getat = await FlutterForegroundTask.getData<double>(key: 'at');
    final customData2 = await FlutterForegroundTask.getData<String>(key: 'speed');
    sensing();
    if(updateCount==0){
      initialValueSetting();
    }
    var distance = Geolocator.distanceBetween(initialx, initialy, position.latitude, position.longitude);
    //count*interval/6000>totalcheckmin
    print('->시간 체크! ${updateCount*checkinterval~/1000}초');
    print('${updateCount*checkinterval~/1000}초\n 거리(m): $distance, 가속도:${getat.toString()}');
   /* if(_screenstate!= lastScreenstate && _screenstate== ScreenStateEvent.SCREEN_OFF){
      print('구독 시작, 스크린 체크 : $_screenstate');
      updateCount= 0;
    }*/
    FlutterForegroundTask.updateService(
        notificationTitle: 'FirstTaskHandler',
        notificationText: "${updateCount*checkinterval~/1000}초\n 거리(m): $distance, 가속도:${getat.toString()}",
        callback: updateCount*checkinterval/60000 >= totalcheckmin ? updateCallback : null);

    // Send data to the main isolate.
    sendPort?.send(timestamp);
    sendPort?.send(updateCount);
    // _receivePort?.listen((message)으로 보내는 자료임-> 해당에서 정리해서, 연산해서 서버로 보내도 될 듯?
    if(_screenstate == ScreenStateEvent.SCREEN_OFF) updateCount++;
    lastScreenstate = _screenstate; //이거 하면 다시 초기화 될 거임..
    //if(_screenstate == ScreenStateEvent.SCREEN_OFF ){updateCount=0;}
    if((getat??0 >1) ){updateCount=0;}
  }
  void initialValueSetting(){
      initialx = position.latitude;
      initialy = position.longitude;
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    // You can use the clearAllData function to clear all the stored data.
    await FlutterForegroundTask.clearAllData();
  }

  void sensing() {
    accelerometerEvents.listen((AccelerometerEvent event) async{
      //print("가속도 센서: $event");
      var ax = event.x;
      var ay = event.y;
      var az = event.z;// - 9.79;
      at = (sqrt((ax*ax) + (ay*ay) + (az*az) ) - 9.79).abs();
      await Future.delayed(Duration(seconds: 1));
      await FlutterForegroundTask.saveData('at', at);
    });
  }

  void startListeningScreen() {
    _screen = new Screen();
    try {
      _subscription = _screen.screenStateStream.listen(onData);
    } on ScreenStateException catch (exception) {
      print(exception);
    }
  }
  void onData(ScreenStateEvent event) {
    print("스크린 $event");
    if(event == ScreenStateEvent.SCREEN_OFF){
      _screenstate = event;
    }else {
      _screenstate = ScreenStateEvent.SCREEN_ON;
    }
  }
}

void updateCallback() {
  FlutterForegroundTask.setTaskHandler(SecondTaskHandler());
}

class SecondTaskHandler implements TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, SendPort sendPort) async {

  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort sendPort) async {
    final customData = await FlutterForegroundTask.getData<String>(key: 'customData');
    final customData2 = await FlutterForegroundTask.getData<String>(key: 'speed');
    final y = await FlutterForegroundTask.getData<String>(key: 'latitude');
    final x = await FlutterForegroundTask.getData<String>(key: 'longitude');

    FlutterForegroundTask.updateService(
        notificationTitle: 'SecondTaskHandler',
       notificationText: timestamp.second.toString()+"\n위치: $y,$x, 속도$at",
    );

    // Send data to the main isolate.
    sendPort?.send(timestamp);
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {

  }
}


class ExampleApp extends StatefulWidget {
  @override
  _ExampleAppState createState() => _ExampleAppState();
}
Screen _screen;

var at = 0.0;
Position position;
var initialx = 0.0;
var initialy =0.0;
var lastScreenstate = ScreenStateEvent.SCREEN_ON;
var _screenstate = ScreenStateEvent.SCREEN_ON;
StreamSubscription<ScreenStateEvent> _subscription;
class _ExampleAppState extends State<ExampleApp> {
  ReceivePort _receivePort;

  void _initForegroundTask() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'notification_channel_id',
        channelName: 'Foreground Notification',
        channelDescription: 'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
        ),
      ),
      iosNotificationOptions: IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        interval: checkinterval,
        autoRunOnBoot: true,
      ),
      printDevLog: true,
    );
  }

  void _startForegroundTask() async {
    // You can save data using the saveData function.
    await FlutterForegroundTask.saveData('customData', 'hello');

    _receivePort = await FlutterForegroundTask.startService(
      notificationTitle: 'Foreground Service is running',
      notificationText: 'Tap to return to the app',
      callback: startCallback,
    );

    _receivePort?.listen((message) async{
      await FlutterForegroundTask.saveData('at', at.toString());
      if (message is DateTime)
       {
       //  print('receive timestamp: $message');
          position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        // print("위치 ->${position.toString()}");
         await FlutterForegroundTask.saveData('latitude', position.latitude.toString());
         await FlutterForegroundTask.saveData('longitude', position.longitude.toString());

         //sensing();
       }
      else if (message is int)
        print('receive updateCount: $message');
    });
  }

  void _stopForegroundTask() {
    FlutterForegroundTask.stopService();
  }

  @override
  void initState() {
    super.initState();
    _initForegroundTask();
  }

  @override
  void dispose() {
    _receivePort?.close();
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {
    Future.microtask(() async{

      try{
      if (await Permission.ignoreBatteryOptimizations.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
        print('battery 무시 성공');
      }}catch(e){
        print('battery 확인 실패');
      }
      checkIfLocationPermissionGranted();

    });

    return MaterialApp(
      // A widget that prevents the app from closing when the foreground service is running.
      // This widget must be declared above the [Scaffold] widget.
      home: WithForegroundTask(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('구구팔팔GO Foreground Task'),
            centerTitle: true,
          ),
          body: _buildContentView(),
        ),
      ),
    );
  }

  Widget _buildContentView() {
    final buttonBuilder = (String text, {VoidCallback onPressed}) {
      return ElevatedButton(
        child: Text(text),
        onPressed: onPressed,
      );
    };

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buttonBuilder('start', onPressed: _startForegroundTask),
          buttonBuilder('stop', onPressed: _stopForegroundTask),
        ],
      ),
    );
  }
}