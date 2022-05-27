import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/material_color.dart';
import 'package:notrip/pages/mypages/notice_detail_page.dart';

class NoticeListPage extends StatefulWidget {
  const NoticeListPage({Key key}) : super(key: key);

  @override
  _NoticeListPageState createState() => _NoticeListPageState();
}

class _NoticeListPageState extends State<NoticeListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("공지사항"),

      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, position) {
          return InkWell(
            onTap: (){
              print("공지사항 클릭!");
              Get.to(NoticeDetailPage());
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(common_main_gap),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("전체공지", style: TextStyle(color:  greyB7B7B7),),
                         Spacer(),
                          Text("2021-10-01", style: TextStyle(color:  greyB7B7B7),),
                        ],
                      ),
                      SizedBox(height: 16*screenSizeFactor,),
                      SizedBox(
                          width: double.maxFinite,
                          child: Text("공지에 관한 제목입니다.", style: TextStyle(fontWeight: FontWeight.bold),)),
                    ],
                  ),
                ),
                Divider(height: 1, thickness: 1,)
              ],
            ),
          );
        },
      ),
    );
  }
}
