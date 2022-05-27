import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/string_address.dart';
import 'package:notrip/pages/alarm_page.dart';
import 'package:notrip/pages/home/home_home_page.dart';
import 'package:notrip/wigets/round_wigets.dart';

import '../alarm_list_page.dart';
bool searchmode = false;
class Homepage extends StatefulWidget {
  Homepage(this.gopage, {Key key}) : super(key: key);
  Function gopage;
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Visibility(
          visible: !searchmode,
          child: IconButton(
              onPressed: () {
                print('검색버튼 클릭');
                setState(() {
                  searchmode = true;
                });
              },
              icon: Icon(Icons.search)),
        ),
        title: searchmode? Text('검색'):Text('구구팔팔GO'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                print('알림 버튼 클릭');
                Get.to(AlarmListPage());
              },
              icon: Icon(Icons.notifications_none_outlined))
        ],
      ),
      body: searchmode? HomeSearch() :  HomeHomePage(widget.gopage),
    );
  }
 Widget HomeSearch(){
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(common_main_gap),
        child: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
          child: Row(
              children: [
                Icon(Icons.search),

                Expanded(
                  child: TextField(
                      decoration: new InputDecoration.collapsed(
                          hintText: '검색어를 입력해주세요.'
                      )),
                ),
                IconButton(onPressed: (){
                  setState(() {
                    searchmode = false;
                    print('false');
                  });

                }, icon: Icon(Icons.close))
              ]
          ),
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("인기검색어"),
            ],
          ),

        ]..addAll([
          Text("부산"),
          Text("서울근교"),
          Text("경남"),
        ]),
      )
    ],);
 }
}
