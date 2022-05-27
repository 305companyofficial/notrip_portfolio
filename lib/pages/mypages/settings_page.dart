import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/material_color.dart';
import 'package:notrip/pages/mypages/settings_alarm.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("설정"),),
      body: Column(
        children: [
          _settingCategoryWidget("정보"),
          _settingContentsWidget("버전", rightWidget : Text("1.0",style: TextStyle(color: grey868181),)),
          _settingContentsWidget("업데이트 정보", rightWidget : Text("바로가기>", style: TextStyle(color: grey868181),)),
          _settingCategoryWidget("알림설정"),
          _settingContentsWidget("알림 설정", rightWidget : Text(">",style: TextStyle(color: grey868181),),
          function: (){
            print("알림설정으로 이동");
            Get.to(SettingsAlarm());
          }
          ),

        ],
      ),
    );
  }

  Widget _settingContentsWidget(String txt, {Widget rightWidget, GestureTapCallback function}) {
    return InkWell(
      onTap: function ?? (){},
      child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(common_main_gap),
                child: Row(children: [
                  Text(txt), Spacer(),
                  rightWidget??SizedBox.shrink()
                ],),
              ),
              Divider(height: 1, thickness: 1,),
            ],
          ),
    );
  }

  Column _settingCategoryWidget(String txt) {
    return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(common_main_gap,common_lll_gap,common_main_gap,common_s_gap),
              child: Row(
                children: [
                  Text(txt, style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1,),
          ],
        );
  }
}
