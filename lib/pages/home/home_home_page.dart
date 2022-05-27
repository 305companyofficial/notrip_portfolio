import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/logger.dart';
import 'package:notrip/constants/material_color.dart';
import 'package:notrip/constants/string_address.dart';
import 'package:notrip/constants/styles.dart';
import 'package:notrip/controllers/location_info_controller.dart';
import 'package:notrip/models/weather_model.dart';
import 'package:notrip/wigets/barrier_free.dart';
import 'package:notrip/wigets/round_wigets.dart';

import '../main_page.dart';

class HomeHomePage extends StatefulWidget {
  HomeHomePage(this.gopage, {Key key}) : super(key: key);
  Function gopage;
  @override
  _HomeHomePageState createState() => _HomeHomePageState();
}


class _HomeHomePageState extends State<HomeHomePage> {
  var _pageindex = 0;

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollDirection: Axis.vertical,
      slivers: [
        _articleLabel(),
        _articleList(),
        BarrierFreeWidget(),
        //"근처에 가볼만한 곳 👀"
        _near(),
        _communityLabel(),
        _communityList(),
        SliverToBoxAdapter(child:  SizedBox(height: common_l_gap,),)
      ],
    );
  }

  SliverPadding _articleList() {
    return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: common_main_gap, ),
        sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: common_s_gap,
                crossAxisSpacing: common_s_gap,
                childAspectRatio: 0.9
            ),
            delegate: SliverChildListDelegate(
              List.generate(4, (index) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1.2,
                    child: Container(
                      width: double.maxFinite,
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                  ),
                  Text("아티클 제목 $index", style: contentTitle),
                  Text("부산 근교 여행지 top$index..", style: contentContent)
                ],
              ))
              ,)
        ),
      );
  }
  Future<WeatherModel> _fetch1() async {
    //await Get.find<LocationInFoController>().getAddress();
    var resultstr = await Get.find<LocationInFoController>().getWeatherStart();
    logger.d("WeatherModel");
    return resultstr;
  }
  Future<Map<String, dynamic>> _fetch2() async {
    //await Get.find<LocationInFoController>().getAddress();
    Map<String, dynamic> resultMap = await Get.find<LocationInFoController>().getAddress();
    resultMap['covid'] =  await Get.find<LocationInFoController>().getCovidStart(resultMap['region']);
    logger.d("covid");
    return resultMap;
  }


  SliverToBoxAdapter _articleLabel() {
    return SliverToBoxAdapter(
        child: Column(
          children: [
            FutureBuilder(
              future: Future.wait([_fetch1(), _fetch2()]),
              builder:  (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot){
                if (snapshot.hasData == false) {
                  return Center(child: CircularProgressIndicator());
                }
                //error가 발생하게 될 경우 반환하게 되는 부분
                else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  );
                }
                // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
                else {
                  WeatherModel _weatherModel = snapshot.data[0];
                  Map coronaData  = snapshot.data[1];
                  return  homeTopView(_weatherModel, coronaData);}},
            ),
            familyProfiles(),
            Padding(
              padding: const EdgeInsets.only(left: common_main_gap, right: common_sss_gap),
              child: Row(
                children: [
                  Text("코이지 아티클", style: subtitle,),
                  Spacer(),
                  TextButton(
                    onPressed: () async{
                      //goArticle();
                      widget.gopage(1);
                  }, child: Text("더보기", style: TextStyle(color: Colors.blue,),
                  ),)],),),],),);}

  SliverToBoxAdapter _near() {
    return SliverToBoxAdapter(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: common_main_gap, right: common_sss_gap, top: common_lll_gap),
              child: Row(
                children: [
                  Text("근처에 가볼만한 곳 👀", style: subtitle,),
                ],
              ),
            ),
            SizedBox(height: common_gap,),
            _nearList(),
          ],
        ),
      );
  }

  SliverList _communityList() {
    return SliverList(
          delegate: SliverChildListDelegate(
            List.generate(3, (index) => InkWell(
              onTap: (){},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: common_main_gap),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: common_main_gap ),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(5)
                            ),
                          ),
                          SizedBox(width: common_gap,),
                          SizedBox(
                            height: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("커뮤니티 제목 어쩌고 저쩌고 $index", style: contentTitle,),
                                Text("김여행 $index   2021.08.21",style: contentContent,),
                                Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.favorite_border, size:  iconsize_ss,),
                                    Text("201"),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(Icons.chat_bubble, size:  iconsize_ss,),
                                    Text("$index")
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(thickness: 1, height: 1,)
                  ],
                ),
              ),
            ),
            )
            ,)
      );
  }

  SliverToBoxAdapter _communityLabel() {
    return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.only(left: common_main_gap, right: common_sss_gap),
          child: Row(
            children: [
              Text("커뮤니티", style: subtitle,),
              Spacer(),
              TextButton(
                onPressed: (){
                  //goCommunity();
                  widget.gopage(0);
                }, child: Text("더보기", style: TextStyle(color: Colors.blue,),
              ),
              )
            ],
          ),
        ),
      );
  }

  SizedBox _nearList() {
    return SizedBox(
              height: 200,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: common_main_gap - common_ss_gap),
                scrollDirection: Axis.horizontal,
                children:  List.generate( 10, (index) =>
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: common_ss_gap, vertical: common_ss_gap),
                      child: InkWell(
                        onTap: (){},
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 140,
                                height: 128,
                                child: ColoredBox(
                                  color: Colors.grey[300],
                                  child: Icon(CupertinoIcons.camera, color: Colors.black26,),
                                )
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: common_sss_gap),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("gd", style: TextStyle(fontSize: 16),),
                                  SizedBox(width: common_ss_gap,),
                                  Text("gd", style: TextStyle(
                                    color: greyB2B2B2,
                                    fontSize: 13
                                  ),),
                                ],
                              ),
                            ),
                            Text("600m", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                    ),)
              ),
            );
  }

  SizedBox homeTopView(WeatherModel weatherModel, Map coronadata) {
    var weathericon = "☀️"; //"⛈☀️🌤🌤⛅️🌥☁️🌦🌧⛈🌩🌨😷"
    switch(weatherModel.weather[0].main){
      case "Clear" : {weathericon = "☀️";}break;
      default:
    }
    return SizedBox(
              child: IndexedStack(
                  index: _pageindex,
                children: List.generate(3,
                        (index) => InkWell(
                      onTap: (){

                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(common_l_gap,0,common_l_gap,common_l_gap),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius:1,
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                        TextSpan(
                                            text:'안녕하세요, ',
                                            children: [
                                              TextSpan(text: '길동이', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                              TextSpan(text: '님!')
                                            ]
                                        )
                                    ),
                                    Text.rich(
                                        TextSpan(
                                            text:'지금 📍',
                                            children: [
                                              TextSpan(text: '${coronadata['address']}', style: TextStyle(fontWeight: FontWeight.w400, )),
                                              TextSpan(text: '에 있어요!')
                                            ]
                                        )
                                    ),

                                  ],
                                ),
                                Spacer(),
                                Padding(
                                  padding:
                                  const EdgeInsets.all(common_gap),
                                  child: networkCircleImg(
                                      imgurl: testImgurl,
                                      imgsize: iconsize_profile*0.9,
                                      replaceicon: Icons.person),
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: greyECECEC,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(common_s_gap),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [

                                    Text("$weathericon️${(weatherModel.main.temp-273.15).toInt()}℃", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: common_gap),
                                      child: Container(
                                        width: 1,
                                        height: 20,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text("😷${coronadata['covid']}명", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
              )
            );
  }
  int profileSelectedIndex = 0;
  Padding familyProfiles() {
    return Padding(
              padding: const EdgeInsets.all(common_main_gap),
              child: Row(
                children:
                [familyProfile("동이아빠",1),
                SizedBox(width: common_s_gap,),
                 familyProfile("동이아빠",2),
                 Spacer(),
                  familyProfile("나",0)
                ]
              ),
            );
  }

  Widget familyProfile(String name, int index) {
    return InkWell(
      onTap: (){
        setState(() {
          profileSelectedIndex = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: profileSelectedIndex ==index ? Colors.green:Colors.grey,//greyECECEC,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          children: [
            Container(
              //margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1000),
                border: Border.all(width: 2, color: Colors.white),
                color: greyC6C3C3
              ),
              child: networkCircleImg(
                  imgurl: testImgurl,
                  imgsize: iconsize_l,
                  replaceicon: Icons.person),
            ),

            Text(name), SizedBox(width: common_s_gap,)
          ],
        ),
      ),
    );
  }
}
