import 'package:flutter/material.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/pages/scraps/scrap_article_list.dart';
import 'package:notrip/pages/scraps/scrap_community_list.dart';
import 'package:notrip/pages/scraps/scrap_location_list.dart';

class ScrapPage extends StatefulWidget {
  const ScrapPage({Key key}) : super(key: key);

  @override
  _ScrapPageState createState() => _ScrapPageState();
}

class _ScrapPageState extends State<ScrapPage> {
  int stackIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("스크랩"),
        centerTitle: true ,
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Row(
              children: [
                Tabpost('아티클', () {
                  setState(() {
                    stackIndex = 0;
                  });
                },  0),
                /*
                VerticalDivider(
                color: Colors.black87,
              ),
              */
                Container(
                  width: 1,
                  height: 20,
                  color: Colors.grey,
                ),
                Tabpost('커뮤니티', () {
                  setState(() {
                    stackIndex = 1;
                  });
                }, 1),

                Container(
                  width: 1,
                  height: 20,
                  color: Colors.grey,
                ),
                Tabpost('장소', () {
                  setState(() {
                    stackIndex = 2;
                  });
                }, 2),
              ]
          ),

        ]..add(
          IndexedStack(
            index: stackIndex,
            children: [
              ScrapArticleList(),
              ScrapCommunityList(),
              ScrapLocationList(),
            ],
          )
        ),
      ),
    );
  }


  InkWell Tabpost(String label, GestureTapCallback action,  int thisTabIndex) {
    return InkWell(
        onTap: action,
        child: Padding(
          padding: const EdgeInsets.all(common_l_gap),
          child: thisTabIndex == stackIndex ?
          Text(label, style:  TextStyle(fontSize: fontsize_L, fontWeight: FontWeight.bold),):
          Text(label, style:  TextStyle(fontSize: fontsize_m),),
        ));
  }
}
