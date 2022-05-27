import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/material_color.dart';
import 'package:notrip/pages/main_page.dart';

class EnrollFamilyPage extends StatefulWidget {
  const EnrollFamilyPage({Key key}) : super(key: key);

  @override
  _EnrollFamilyPageState createState() => _EnrollFamilyPageState();
}

class _EnrollFamilyPageState extends State<EnrollFamilyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("가족 등록하기"),
      ),
      body: Column(
        children: [
          Text("연결할 가족의 휴대폰번호를 입력해주세요!"),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal : common_main_gap, vertical: common_lll_gap),
            child: InkWell(
              onTap: (){
                Get.offAll(MainPage());
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5*screenSizeFactor),
                    color: grey868181
                ),
                width: double.maxFinite,
                height: 40*screenSizeFactor,
                child: Center(child: Text("건너뛰기")),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal : common_main_gap, vertical: common_lll_gap),
            child: InkWell(
              onTap: (){

              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5*screenSizeFactor),
                    color: grey868181
                ),
                width: double.maxFinite,
                height: 40*screenSizeFactor,
                child: Center(child: Text("다음")),
              ),
            ),
          )
        ],
      ),
    );
  }
}
