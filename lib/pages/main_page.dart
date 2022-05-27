import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/logger.dart';
import 'package:notrip/constants/material_color.dart';
import 'package:notrip/interface/page_move.dart';

import 'articles/articles_page.dart';
import 'scraps/scrap_page.dart';
import 'community/community_page.dart';
import 'home/home_page.dart';
import 'mypages/my_page.dart';
import 'community/write_community_page.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key,}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}
class _MainPageState extends State<MainPage> implements PageMove {

  int _pageindex = 0;
  List<Widget> _screens;
  double _iconPadding= 4.0;
  @override
  void initState() {
    super.initState();
    _screens = <Widget>[
      CommunityPage(), ArticlesPage(), Homepage(goPage), ScrapPage(), MyPage()
    ];
  }
  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [
        Scaffold(
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 10.0, ),
              child: Visibility(
                visible: _pageindex== 0,
                child: FloatingActionButton(
                  onPressed: (){
                    print('floating button clicked');
                    Get.to(WriteCommunityPage());
                  },
                  backgroundColor: Colors.white,
                  child: Icon(Icons.mode_edit, color: Colors.black87,),
                ),
              ),
            ),
            body: IndexedStack(
              index: _pageindex,
              children : _screens,
            ),
            bottomNavigationBar: BottomNavigationBar(
              //showSelectedLabels: false,
              //showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              items: [
                BottomNavigationBarItem(icon:
                Padding(
                  padding: EdgeInsets.all(_iconPadding),
                  child: SvgPicture.asset('assets/icons/ic_community.svg', color: _pageindex==0? Colors.yellow: greyCCCCCC,),
                ),
                    label: '커뮤니티'),
                BottomNavigationBarItem(icon: Padding(
                  padding: EdgeInsets.all(_iconPadding),
                  child: SvgPicture.asset('assets/icons/ic_article.svg', color: _pageindex==1? Colors.yellow: greyCCCCCC,),
                ),label:'아티클'),
                BottomNavigationBarItem(icon: Padding(
                  padding: EdgeInsets.all(_iconPadding),
                  child: SvgPicture.asset('assets/icons/ic_home.svg', color: _pageindex==2? Colors.yellow: greyCCCCCC,),
                ), label:'홈'),
                BottomNavigationBarItem(icon: Padding(
                  padding: EdgeInsets.all(_iconPadding),
                  child: SvgPicture.asset('assets/icons/ic_scrap.svg', color: _pageindex==3? Colors.yellow: greyCCCCCC,),
                ), label: '스크랩'),
                BottomNavigationBarItem(icon: Padding(
                  padding: EdgeInsets.all(_iconPadding),
                  child: SvgPicture.asset('assets/icons/ic_user.svg', color: _pageindex==4? Colors.yellow: greyCCCCCC,),
                ), label: '내 정보'),
              ],
              unselectedItemColor : greyCCCCCC,
              selectedLabelStyle: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
              selectedIconTheme: IconThemeData(color:Colors.yellow ),
              //selectedItemColor : Colors.yellow,
              onTap: (index){
                setState(() {
                  _pageindex = index;
                });
              },
              currentIndex: _pageindex,)
        ),
        Visibility(
          visible: false,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height:  double.infinity,
                color: Colors.black87.withOpacity(0.7),
              ),
              Center(child: SizedBox(
                width: 50, height: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 8,
                  color: Colors.white,
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void goPage(int pagenum) {
    logger.d("페이지 이동");
    setState(() {
      _pageindex = pagenum;
    });
  }
}
goArticle(){
  print("아티클로 이동");
}
goCommunity(){
  print("커뮤니티로 이동");
}