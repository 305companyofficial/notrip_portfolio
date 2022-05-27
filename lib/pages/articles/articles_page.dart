import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/logger.dart';
import 'package:notrip/constants/material_color.dart';
import 'package:notrip/constants/styles.dart';
import 'package:notrip/controllers/api_data_controller.dart';
import 'package:notrip/tools/enums.dart';
import 'package:notrip/tools/times.dart';

import 'detail_article_page.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({Key key}) : super(key: key);

  @override
  _ArticlesPageState createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  bool favoriteMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("아티클"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          radioQueryBts(),
        GetBuilder<ApiDataController>(builder: (apiController){
          return  Expanded(
            child: Stack(
              children: [
                ListView(
                    scrollDirection: Axis.vertical,
                    children:  List.generate(apiController.articleList.length, (index) =>
                        InkWell(
                          onTap: (){
                            Get.to(DetailArticlePage(articleModel: apiController.articleList[index],));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(common_main_gap),
                            child: Stack(
                              children: [
                                _networkImage(apiController, index),
                                Positioned.fill(
                                  left: 16,
                                  bottom: 16,
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                   mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                            color: grey333333.withOpacity(0.6),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: common_ss_gap
                                            ),
                                            child: Text("${apiController.articleList[index].subject}", style: articleTitle,
                                            )),
                                        SizedBox(height: 10,),
                                        Container(
                                            color: grey333333.withOpacity(0.6),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: common_ss_gap
                                            ),
                                            child: Text("${printSavedDate2(apiController.articleList[index].createdAt)}", style: articleDate,)),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                    )
                ),
                Visibility(
                    visible: apiController.isArtcleLoading,
                    child: Center(child: CircularProgressIndicator()))
              ],
            ),
          );
        }),

        ],
      ),
    );
  }

  CachedNetworkImage _networkImage(ApiDataController apiController, int index) {
    return CachedNetworkImage(
      width: Get.width,
      height: Get.width*0.5,
      fit: BoxFit.fill,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
              image: imageProvider, fit: BoxFit.fill),
        ),),
      imageUrl: "https://picsum.photos/400",
      placeholder: (context, url) =>  Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) =>  Container(
          decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(5)
          ),
          child: Icon(Icons.image_not_supported
            , size: iconsize_l,
            color: Colors.black54,
          )),
    );
  }

  Padding searchBar() {
    return Padding(
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
                      print('false');
                    });
                  }, icon: Icon(Icons.close))
                ]
            ),
          ),
        );
  }
  InkWell Tabpost(String label, GestureTapCallback action, bool setfavorite) {
    return InkWell(
        onTap: action,
        child: Padding(
          padding: const EdgeInsets.all(common_l_gap),
          child: favoriteMode == setfavorite ?
          Text(label, style:  TextStyle(fontSize: fontsize_L, fontWeight: FontWeight.bold),):
          Text(label, style:  TextStyle(fontSize: fontsize_m),),
        ));
  }


  Row radioQueryBts() {
    return Row(
        children: [
          tabPost('인기글', () {
            setState(() {
              _tapOption = TapOption.GOOD;
            });
          }, TapOption.GOOD),
          /*
              VerticalDivider(
              color: Colors.black87,
            ),
            */
          SizedBox(width: 5,),
          tabPost('최신글', () {
            setState(() {
              _tapOption = TapOption.LATEST;
            });
          }, TapOption.LATEST),
        ]
    );
  }

  TapOption _tapOption = TapOption.GOOD;
  Widget tabPost(String label, GestureTapCallback action, TapOption taboption) {
    return InkWell(
      onTap: (){
        tabCliked(taboption);
      },
      child: Row(
        children: [
          Radio(
              activeColor: Colors.yellow[600],
              value: taboption, groupValue: _tapOption, onChanged: (value){
            tabCliked(value);
          }),
          Text(label)
        ],
      ),
    );
  }

  void tabCliked(TapOption value){
    print("TapOption : $value");
   if(_tapOption == value){
      logger.d("article $value 이미 선택 됨");
      return;
    }
    setState(() {
      _tapOption = value;
    });
    Get.find<ApiDataController>().articleTabOption = _tapOption;
    Get.find<ApiDataController>().refreshArticleModelList(taboption:_tapOption );

  }
}
