import 'package:flutter/material.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/material_color.dart';

class MyAccountInfomation extends StatelessWidget {
  const MyAccountInfomation({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("내 계정 정보"),
        actions: [
          IconButton(onPressed: (){}, icon: Text("완료")),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(common_main_gap),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("계정 정보",style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: common_s_gap,),
            Text("닉네임"),
            SizedBox(height: common_s_gap,),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: const EdgeInsets.all(common_ss_gap),
                      hintText: "홍길동",)
                  ),
                ),
                SizedBox(width: common_s_gap,),
                Container(
                  height: 44*screenSizeFactor,
                  decoration: BoxDecoration(
                    color: greyECECEC,
                    borderRadius: BorderRadius.circular(5*screenSizeFactor)
                  ),
                  child: Center(child: Padding(
                    padding: const EdgeInsets.all(common_s_gap),
                    child: Text("중복확인"),
                  )),
                )
              ],
            ),
            SizedBox(height: common_s_gap,),
            Text("휴대폰번호"),
            SizedBox(height: common_s_gap,),
            TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: const EdgeInsets.all(common_ss_gap),
                  hintText: "01028519936",)
            ),
            SizedBox(height: common_s_gap,),
            Row(
             mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("변경하기", ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
