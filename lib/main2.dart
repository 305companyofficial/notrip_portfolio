import 'dart:async';
import 'dart:isolate';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screen_state/screen_state.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(MyApp());
}

class FirstTaskHandler implements TaskHandler {
  int updateCount = 0;

  @override
  Future<void> onStart(DateTime timestamp, SendPort sendPort) async {
    // You can use the getData function to get the data you saved.
    final customData = await FlutterForegroundTask.getData<String>(key: 'customData');
    print('customData: $customData');
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort sendPort) async {
    FlutterForegroundTask.updateService(
        notificationTitle: 'FirstTaskHandler',
        notificationText: timestamp.toString(),
        callback: updateCount >= 10 ? updateCallback : null);

    // Send data to the main isolate.
    sendPort?.send(timestamp);
    sendPort?.send(updateCount);

    updateCount++;
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    // You can use the clearAllData function to clear all the stored data.
    await FlutterForegroundTask.clearAllData();
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
    FlutterForegroundTask.updateService(
        notificationTitle: 'SecondTaskHandler',
        notificationText: timestamp.toString());

    // Send data to the main isolate.
    sendPort?.send(timestamp);
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {

  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, }) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _platformVersion = 'Unknown';
   Screen _screen;
   StreamSubscription<ScreenStateEvent> _subscription;
  ReceivePort _receivePort;
  void onData(ScreenStateEvent event) {
    print("스크린 $event");
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
    final buttonBuilder = (String text, {VoidCallback onPressed}) {
      return ElevatedButton(
        child: Text(text),
        onPressed: onPressed,
      );
    };

    Future.microtask(() {
      //sensing();
      startListening();
      getPermission();

    });
    return WithForegroundTask(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          children: <Widget>[
            buttonBuilder('start', onPressed: _startForegroundTask),
            buttonBuilder('stop', onPressed: _stopForegroundTask),
          ],
        ),
      ),
    );
  }
  void getPermission() async{
    print("get permission!");
    if (await Permission.location.request().isGranted ) {
      // Either the permission was already granted before or the user just granted it.
      getlocation();
    }

  }
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
        interval: 5000,
        autoRunOnBoot: true,
      ),
      printDevLog: true,
    );
  }
  void startListening() {
    _screen = new Screen();
    try {
      _subscription = _screen.screenStateStream.listen(onData);
    } on ScreenStateException catch (exception) {
      print(exception);
    }
  }
  void getlocation() async{
    int index= 0;
    _screen = new Screen();
    while(true) {


      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print("$index 번째 위치 ->${position.toString()}");
      print("mounted -> $mounted");
     await Future.delayed(Duration(seconds: 10));
    index++;
    }
  }

  void sensing(){
    accelerometerEvents.listen((AccelerometerEvent event) {
      print("가속도 센서: $event");
    });
// [AccelerometerEvent (x: 0.0, y: 9.8, z: 0.0)]

    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      print("유저 가속도 센서: $event");
    });
// [UserAccelerometerEvent (x: 0.0, y: 0.0, z: 0.0)]

    gyroscopeEvents.listen((GyroscopeEvent event) {
      print("자이로 센서: $event");
    });
// [GyroscopeEvent (x: 0.0, y: 0.0, z: 0.0)]

    magnetometerEvents.listen((MagnetometerEvent event) {
      print("자기장 센서: $event");
    });
// [MagnetometerEvent (x: -23.6, y: 6.2, z: -34.9)]
  }


  void globalForegroundService() {
    debugPrint("current datetime is ${DateTime.now()}");
  }

  void _startForegroundTask() async {
    // You can save data using the saveData function.
    await FlutterForegroundTask.saveData('customData', 'hello');

    _receivePort = await FlutterForegroundTask.startService(
      notificationTitle: 'Foreground Service is running',
      notificationText: 'Tap to return to the app',
      callback: startCallback,
    );

    _receivePort?.listen((message) {
      print("message 받음");
      if (message is DateTime)
        print('receive timestamp: $message');
      else if (message is int)
        print('receive updateCount: $message');
    });
  }
  void startCallback() {
    // The setTaskHandler function must be called to handle the task in the background.
    FlutterForegroundTask.setTaskHandler(FirstTaskHandler());
  }

  void _stopForegroundTask() {
    FlutterForegroundTask.stopService();
  }


}
