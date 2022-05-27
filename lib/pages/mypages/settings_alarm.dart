import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/material_color.dart';

class SettingsAlarm extends StatefulWidget {
  const SettingsAlarm({Key key}) : super(key: key);

  @override
  _SettingsAlarmState createState() => _SettingsAlarmState();
}
var _switchValue1=false;
var _switchValue2=false;
var _switchValue3=false;
class _SettingsAlarmState extends State<SettingsAlarm> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("알림설정"),),
      body: Column(
        children: [
          SizedBox(height: 20,),
          Divider(height: 1, thickness: 1,),
          _settingContentsWidget("푸시 알림",
           rightWidget: CupertinoSwitch(
              value: _switchValue1,
              onChanged: (value) {
                setState(() {
                  _switchValue1 = value;
                });
              },
            ),
            function: (){
            setState(() {
              _switchValue1 = !_switchValue1;
            });
            }
          ),
          SizedBox(
            width: double.maxFinite,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: common_main_gap, vertical: common_s_gap),
              child: Text("푸시 알림 설정은 \n아이폰 설정 > 알림 > 구구팔팔GO에서 바꾸실 수 있습니다.",
              style: TextStyle(color: grey868181, fontSize: 11),),
            ),
          ),
          Divider(height: 1, thickness: 1,),
          _settingContentsWidget("구구팔팔고 소식 알림 받기",
              rightWidget: CupertinoSwitch(
                value: _switchValue2,
                onChanged: (value) {
                  setState(() {
                    _switchValue2 = value;
                  });
                },
              ),
              function: (){
                setState(() {
                  _switchValue2 = !_switchValue2;
                });
              }
          ),
          SizedBox(
            width: double.maxFinite,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: common_main_gap, vertical: common_s_gap),
              child: Text("다양한 이벤트 및 혜택을 푸시로 알려드립니다. 동의하지 않아도 서비스 이용이 가능합니다.",
                style: TextStyle(color: grey868181, fontSize: 11),),
            ),
          ),
          Divider(height: 1, thickness: 1,),
          _settingContentsWidget("구구팔팔고 소식 알림 받기",
              rightWidget: CupertinoSwitch(
                value: _switchValue3,
                onChanged: (value) {
                  setState(() {
                    _switchValue3 = value;
                  });
                },
              ),
              function: (){
                setState(() {
                  _switchValue3 = !_switchValue3;
                });
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
}
