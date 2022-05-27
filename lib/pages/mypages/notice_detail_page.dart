import 'package:flutter/material.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/material_color.dart';

class NoticeDetailPage extends StatefulWidget {
  const NoticeDetailPage({Key key}) : super(key: key);
  @override
  _NoticeDetailPageState createState() => _NoticeDetailPageState();
}

class _NoticeDetailPageState extends State<NoticeDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("공지사항"),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(common_main_gap),
            child: Column(
              children: [
                SizedBox(
                    width: double.maxFinite,
                    child: Text("공지에 관한 제목입니다.",
                      style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 16
                      ),)),
                SizedBox(height: 16,),
                Row(
                    children:[  Text("전체공지", style: TextStyle(color: greyB7B7B7,
                    fontSize: 14
                    ),),
                      Spacer(),
                      Text("2021-10-01", style: TextStyle(color: greyB7B7B7,
                      fontSize: 14),)]
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(common_main_gap),
            child: Text("하는 같이 보내는 풀이 이상이 역사를 철환하였는가? "
                "때에, 이상은 위하여, 피고 얼마나 이것이다. 끓는 수 청춘의 운다. "
                "얼마나 심장은 있으며, 있으랴? 되려니와, 용감하고 많이 부패뿐이다. "
                "끓는 예수는 모래뿐일 너의 같지 이 사라지지 위하여서, 아름다우냐? "
                "군영과 무엇을 피부가 목숨을 자신과 꽃이 것이다.보라, 것이다. 불어 "
                "못할 커다란 부패뿐이다. 피가 기쁘며, 얼음과 희망의 현저하게 생의 "
                "거선의 이상이 것이다. 낙원을 사랑의 방황하여도, 커다란 부패뿐이다. "
                "무엇을 봄바람을 온갖 더운지라 우는 뼈 청춘의 긴지라 꽃 것이다.",
                style: TextStyle(fontSize: 16)),
          ),

        ],

      ),
    );
  }
}
