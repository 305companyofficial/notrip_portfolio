import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/logger.dart';
import 'package:notrip/constants/material_color.dart';
import 'package:notrip/constants/string_address.dart';
import 'package:notrip/constants/styles.dart';
import 'package:notrip/controllers/api_data_controller.dart';
import 'package:notrip/models/article_model.dart';
import 'package:notrip/pages/articles/article_spot.dart';
import 'package:notrip/tools/times.dart';

class DetailArticlePage extends StatefulWidget {
   DetailArticlePage( {this.articleModel,Key key}) : super(key: key);
  ArticleModel articleModel;
  @override
  _DetailArticlePageState createState() => _DetailArticlePageState();
}

class _DetailArticlePageState extends State<DetailArticlePage> {
  ScrollController scrollController;
  Color _appColor = Color(0x77FFFFFF);
  bool changedAppbar= false;
  @override
  void initState() {
    //TODO :스크롤 하는 도중에 setstate를 먹여버리면.. 스크롤이 이상하게 됨.
    //**scroll->
    super.initState();
    scrollController= ScrollController();
   /*   scrollController.addListener(() {
        if(scrollController.position.pixels ==0 && changedAppbar){
          changedAppbar=false;
          setState(() {
            _appColor = Color(0x77FFFFFF);
          });
        }
        else if(scrollController.position.pixels > 100 && !changedAppbar){
          changedAppbar=true;
          setState(() {
            _appColor = Color(0xFFFFFFFF);
          });
        }
      });*/
  }
  @override
  void dispose() {
   // scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([_loadArticleModel(), _loadArticleModelList()]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
          if (snapshot.hasData == false) {
          return Scaffold(
          body: Center(child:
          CircularProgressIndicator()
          ),
          );
          }
          //error가 발생하게 될 경우 반환하게 되는 부분
          else if (snapshot.hasError) {
          return Scaffold(
          body: Center(
          child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
          'Error: ${snapshot.error}',
          style: TextStyle(fontSize: 15),
          ),
          ),
          ),
          );
          }
          // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
          else {
            ArticleModel articleSnapshotData = snapshot.data[0];
            List<ArticleModel> moreArticleSnapshotData  = snapshot.data[1];

            return  Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: _appColor,
                elevation: 0,
                //title: Text("아티클 제목1"),
                // centerTitle: true,
                actions: [
                  IconButton(onPressed: (){
                    print("bookmark");
                  }, icon: articleSnapshotData.isScrap ? SvgPicture.asset('assets/icons/ic_scrap_filled.svg',color: Colors.black87,)
                      : SvgPicture.asset('assets/icons/ic_scrap.svg', color: Colors.black87,)
                  ),
                  IconButton(onPressed: (){
                    print("share");
                  }, icon: Icon(Icons.share_outlined)),
                ],
              ),
              body: SingleChildScrollView(
                controller: scrollController,
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    coverImage(articleSnapshotData),
                    header(articleSnapshotData),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: common_main_gap),
                      child: Text("${articleSnapshotData.memo}", style: TextStyle(fontSize: 14, color: grey666666),),
                    ),
                    SizedBox(height: 20,),
                    Divider(color: yellowD3DE15,
                    thickness: 4,height: 4,
                      indent: Get.width/2-44,
                      endIndent: Get.width/2-44,
                    ),
                    pathList(articleSnapshotData),
                    SizedBox(height: 32,),
                    Divider(thickness: 8, height: 8,),
                    SizedBox(height: common_l_gap,),
                    moreArticle(),
                    SizedBox(
                      width: double.maxFinite,
                      height: 164,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: common_s_gap),
                        scrollDirection: Axis.horizontal,
                        children: List.generate(moreArticleSnapshotData.length, (index) => Padding(
                          padding: const EdgeInsets.all(common_s_gap),
                          child: Container(
                            width: 242,
                            height: 164,
                            child: Stack(
                              children: [
                                _networkImage(moreArticleSnapshotData, index),
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
                                            child: Text("${moreArticleSnapshotData[index].subject}", style: articleTitle,)),
                                        SizedBox(height: 10,),
                                        Container(
                                            color: grey333333.withOpacity(0.6),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: common_ss_gap
                                            ),
                                            child: Text("${printSavedDate2(moreArticleSnapshotData[index].createdAt)}", style: articleDate,)),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                      ),
                    ),
                    SizedBox(height: common_l_gap,),
                  ],
                ),
              ),
            );

    }
    });

  }

  Padding moreArticle() {
    return Padding(
                    padding: const EdgeInsets.only(left : common_main_gap,),
                    child: Row(
                      children: [
                        Text("더 많은 아티클", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ), Spacer(),TextButton(onPressed: (){}, child: Text("더보기", style: TextStyle(color: blue0191B6),)),
                      ],
                    ),
                  );
  }
  CachedNetworkImage _networkImage(List<ArticleModel> articlelist, int index) {
    return CachedNetworkImage(

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
  Column pathList(ArticleModel articleSnapshotData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(articleSnapshotData.paths.length, (index) =>
                    Column(
                      children: [
                    Html(data: articleSnapshotData.paths[index].memo,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: common_main_gap),
                          child: InkWell(
                            onTap: (){
                              Get.to(ArticleSpot(articleSnapshotData.paths[index].location.id));
                            },
                            child: Container(
                              width: double.maxFinite,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(5),
                                border: Border.all( color: greyECECEC, )
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 54,
                                    height: 54,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: CachedNetworkImage(imageUrl: "https://picsum.photos/100",)),
                                  ),
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 54,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          children: [
                                            Text(articleSnapshotData.paths[index].location.subject,
                                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
                                            SizedBox(width: 4,),
                                            Text(articleSnapshotData.paths[index].location.category,
                                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: greyB2B2B2)
                                            )
                                          ],
                                        ),
                                        SizedBox(height: common_ss_gap,),
                                        Text(articleSnapshotData.paths[index].location.address)
                                      ],
                                    ),
                                  ),
                                )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                    ),
                  );
  }

  Column header(ArticleModel articleSnapshotData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 30,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: common_main_gap),
                        child: Text("${articleSnapshotData.subject}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
                      ),
                      SizedBox(height: 4,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: common_main_gap),
                        child: Text("${articleSnapshotData.title}", style: TextStyle(fontSize: 14, color: grey666666),),
                      ),
                    ],
                  );
  }

  Container coverImage(ArticleModel articleSnapshotData) {
    return Container(
                    width: double.maxFinite,
                    /*decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
                    //color: Colors.grey[300],
                  ),*/
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
                          child: AspectRatio(aspectRatio: 360/285,
                              child:
                              CachedNetworkImage(
                                fit: BoxFit.fill,
                                imageUrl: "https://picsum.photos/500",
                                placeholder: (context, url) =>  Center(child: CircularProgressIndicator()),
                                /*errorWidget: (context, url, error) =>  CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: imgsize*0.5,
                              child: Icon(replaceicon, size: imgsize,
                                color: Colors.black54,
                              )),*/
                              )
                          ),
                        ),
                        Positioned.fill(
                          right: 16,
                          bottom: 24,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text("${printSavedDate2(articleSnapshotData.createdAt)}",
                                style: TextStyle(fontSize: 14, color: Colors.white)),
                          ),
                        )
                      ],
                    ),
                  );
  }

  Future<ArticleModel> _loadArticleModel({bool isViewCount= true}) async {
    var response = await Dio().get("$mainUrl/api/v1/user/article/${widget.articleModel.id}/1/detail",
        queryParameters : {"isViewCount": isViewCount});
    logger.d("아티클 상세 가져오기, 결과는" + response.statusCode.toString());
    print("data: " + response.data.toString());
    var articleModel = ArticleModel();
    if (response.statusCode.toString() == "200"){
      articleModel = ArticleModel.fromJson(response.data["data"]);
      //Get.find<ApiDataController>().refreshCommunityModel(widget.index, articleModel);
    }
    return articleModel;
  }
    Future<List<ArticleModel>> _loadArticleModelList() async {
      var response = await Dio().get("$mainUrl/api/v1/user/article/list",
      queryParameters: {"page":0, "size":"4"}
      );
      logger.d("아티클 가져오기, 결과는" + response.statusCode.toString());
      print("data: " + response.data.toString());
      List<ArticleModel> articleModelList = [];
      if (response.statusCode.toString() == "200"){
        articleModelList.addAll(List.generate(response.data["content"].length, (index) => ArticleModel.fromJson(response.data["content"][index])));
      }
      return articleModelList;
    }
}
