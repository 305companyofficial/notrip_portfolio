import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/styles.dart';

import 'alarm_page.dart';

class AlarmListPage extends StatefulWidget {
  const AlarmListPage({Key key}) : super(key: key);

  @override
  _AlarmListPageState createState() => _AlarmListPageState();
}

class _AlarmListPageState extends State<AlarmListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("알림"),
        actions: [
          IconButton(onPressed: (){
          }, icon: Icon(Icons.more_vert))
        ],
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: List.generate(10, (index) => InkWell(
            onTap: (){
              print("1234");
              Get.to(AlarmPage());
            },
          child: Padding(
            padding: const EdgeInsets.all(common_gap),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("[공지]구구팔팔GO$index ", style: contentContent,), Spacer(),
                    Text("2021-10-01", style: contentContent,)
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: common_gap),
                      child: Text("공지에 관한 제목입니다.", style: contentTitle,),
                    ),
                  ],
                ),
                Divider(height: 1, thickness: 1,)
              ],
            ),

          ),
        )),
      ),
    );
  }
}
