import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:notrip/constants/logger.dart';
import 'package:notrip/constants/string_address.dart';
import 'package:notrip/models/article_model.dart';
import 'package:notrip/models/comment_model.dart';
import 'package:notrip/models/community_model.dart';
import 'package:notrip/tools/enums.dart';

class ApiDataController extends GetxController {
  var dio = Dio();
  List<CommunityModel> communityList = [];
  var communityPageIndex = -1;
  var communitySize = 150;
  var communityTabOption = TapOption.GOOD;
  var isCommunityLoading = false;

  List<ArticleModel> articleList = [];
  var articlePageIndex = -1;
  var articleSize = 150;
  var articleTabOption = TapOption.GOOD;
  var isArtcleLoading = false;

  @override
  void onInit() {
    super.onInit();
    communityPageIndex = 0;
    refreshCommunityModelList();
    refreshArticleModelList();
  }

  Future<void> refreshCommunityModelList({TapOption taboption}) async {
    isCommunityLoading = true;
    update();
    communityPageIndex = 0;
    logger.d("커뮤니티 가져오기");
    var option = "GOOD";
    if (taboption!=null){
      if(taboption== TapOption.GOOD){option = "GOOD";}else{option = "LATEST";}
    }
    var response = await dio.get("$mainUrl/api/v1/user/community/1/list", queryParameters:
    {
      "sort": option,
      "page": communityPageIndex,
      "size" : communitySize,
    },
    );
    print("결과는 131" + response.statusCode.toString());
    print("data: " + response.data.toString());
    if (response.statusCode.toString() == "200") {
      logger.d("커뮤니티 가져오기 성공!");
      var communitylist = List.generate(
          response.data["content"].length, (index) =>
          CommunityModel.fromJson(response.data["content"][index]));
      communityList.clear();
      communityList.addAll(communitylist);
      //logger.d("커뮤니티 리스트 : ${communitylist.toString()}");
    }
    isCommunityLoading = false;
    update();
  }

  Future<void> refreshArticleModelList({TapOption taboption}) async {
    isArtcleLoading = true;
    update();
    articlePageIndex = 0;
    logger.d("아티클 가져오기");
    var option = "VIEW";
    if (taboption!=null){
      if(taboption== TapOption.GOOD){option = "VIEW";}else{option = "LATEST";}
    }
    var response = await dio.get("$mainUrl/api/v1/user/article/list", queryParameters:
    {
      "sort": option,
      "page": articlePageIndex,
      "size" : articleSize,
    },
    );
    print("아티클 결과는" + response.statusCode.toString());
    print("data: " + response.data.toString());
    if (response.statusCode.toString() == "200") {
      logger.d("아티클 가져오기 성공!");
      var preArticlelist = List.generate(
          response.data["content"].length, (index) =>
          ArticleModel.fromJson(response.data["content"][index]));
      articleList.clear();
      articleList.addAll(preArticlelist);
      logger.d("아티클 리스트 : ${articleList.toString()}");
    }
    isArtcleLoading = false;
    update();
  }

  void addCommunityModelList() async{
    isCommunityLoading = true;
    update();
    var response = await dio.get("$mainUrl/api/v1/user/community/1/list",
    queryParameters: {
      "memberId":1,
      "sort": communityTabOption,
      "page": ++communityPageIndex,
      "size" : communitySize,
    }
    );
    logger.d("커뮤니티 다음 페이지2 $communityPageIndex");
    print("결과는" + response.statusCode.toString());
    print("data: " + response.data.toString());
    if (response.statusCode.toString() == "200") {
      logger.d("커뮤니티 가져오기 성공!");
      var communitylist = List.generate(
          response.data["content"].length, (index) =>
          CommunityModel.fromJson(response.data["content"][index]));
      communityList.addAll(communitylist);
    }
    isCommunityLoading = false;
    update();
  }
  void refreshCommunityModel(int index, CommunityModel communityModel){
    communityList[index] = communityModel;
    update();
  }
}