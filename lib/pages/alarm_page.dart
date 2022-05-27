import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notrip/constants/common_size.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({Key key}) : super(key: key);
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("알림"),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("공지에 관한 제목입니다."),
          Row(
              children:[  Text("[]"), Spacer(), Text("2021-10-01")]
          ),
          Divider(),
          Text("공지의 내용입니다.")
        ],

      ),
    );
  }
}
