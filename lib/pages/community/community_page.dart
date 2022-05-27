import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/logger.dart';
import 'package:notrip/constants/material_color.dart';
import 'package:notrip/constants/string_address.dart';
import 'package:notrip/controllers/api_data_controller.dart';
import 'package:notrip/interface/dialog.dart';
import 'package:notrip/models/community_model.dart';
import 'package:notrip/pages/community/detail_community_page.dart';
import 'package:notrip/pages/community/write_community_page.dart';
import 'package:notrip/tools/enums.dart';
import 'package:notrip/tools/times.dart';
import 'package:notrip/wigets/community.dart';
import 'package:notrip/wigets/contents.dart';
import 'package:notrip/wigets/round_wigets.dart';

class CommunityPage extends StatefulWidget {
  CommunityPage({Key key}) : super(key: key);
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> implements DialogInterface{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('커뮤니티'),
        centerTitle: true,
        /*actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.edit))
        ],*/
      ),
      body: GetBuilder<ApiDataController>(builder: (apiController){
        return Stack(
          children: [
            CustomScrollView(
              scrollDirection: Axis.vertical,
              slivers: [
                SliverToBoxAdapter(
                  child:   radioQueryBts(),
                ),
              SliverList(delegate: SliverChildListDelegate(
                  List.generate(apiController.communityList.length, (index) =>
                  Visibility(
                    visible: !apiController.communityList[index].isReport,
                    child: InkWell(
                      onTap: (){
                        Get.to(DetailCommunityPage(
                            apiController.communityList[index],
                          index: index,
                        )
                        );
                      } ,
                      child: Column(
                        children: [

                          Container(
                              width: double.maxFinite,
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  headerWidget(apiController.communityList[index],  context, dotbutton1:
                                   apiController.communityList[index].memberId !=1?
                                   MyCommunityDotButton(apiController.communityList[index], diloagModify, dialogDelete, dialogShare):
                                  OtherCommunityDotButton(apiController.communityList[index], dialogReport, dialogShare)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: common_main_gap),
                                    child: Text(apiController.communityList[index].memo, overflow: TextOverflow.ellipsis, maxLines: 5,),
                                  ),
                                  apiController.communityList[index].images.length == 0 ?
                                  SizedBox.shrink():
                                  Padding(
                                    padding: const EdgeInsets.all(common_main_gap),
                                    child: SizedBox(
                                      height: 228,
                                      child:
                                      apiController.communityList[index].images.length == 1 ?
                                      _networkImage(apiController, index, 0)
                                          : Row(
                                        children: [
                                          Expanded(
                                            flex: 192,
                                            child: _networkImage(apiController, index, 0),
                                          ),
                                          SizedBox(width: common_ss_gap,),
                                          apiController.communityList[index].images.length == 2 ?
                                          Expanded(
                                            flex: 129,
                                            child: _networkImage(apiController, index, 1),
                                          )
                                              :
                                          Expanded(
                                            flex: 129,
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: _networkImage(apiController, index, 1),
                                                ),
                                                SizedBox(height: common_ss_gap,),
                                                Expanded(
                                                    child: Stack(
                                                      children: [
                                                        _networkImage(apiController, index, 2),
                                                        apiController.communityList[index].images.length > 3?   Container(
                                                          width: double.maxFinite,
                                                          height: double.maxFinite,
                                                          decoration: BoxDecoration(
                                                            color: alphagrey.withOpacity(0.4),
                                                            borderRadius: BorderRadius.circular(5)
                                                          ),
                                                        child: Center(child: Text("더보기")),
                                                        ):SizedBox.shrink(),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(common_main_gap,0,common_main_gap,common_s_gap),
                                    child: Row(
                                      children: [
                                        Icon(Icons.favorite_border, color: apiController.communityList[index].isGood ? Colors.red : greyCCCCCC,), Text(apiController.communityList[index].goodCount.toString()),
                                       SizedBox(width: 10,),
                                        SvgPicture.asset('assets/icons/ic_talk_bubble.svg', color: greyCCCCCC,), Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: common_sss_gap),
                                          child: Text(apiController.communityList[index].replyCount.toString()),
                                        ),
                                        Spacer(),
                                        Icon(Icons.remove_red_eye, color: greyCCCCCC), Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: common_sss_gap),
                                          child: Text(apiController.communityList[index].viewCount.toString()),
                                        )
                                      ],
                                    ),
                                  ),

                                ],
                              )),
                         index== apiController.communityList.length-1 ? SizedBox.shrink(): SizedBox(height: 24,)
                        ],
                      ),
                    ),
                  )
              ),
                  semanticIndexCallback : (wiget, int){
                    logger.d("semanticIndexCallback  wiget : $wiget,  int : $int");
                    if(int>=(Get.find<ApiDataController>().communitySize*(Get.find<ApiDataController>().communityPageIndex+1)-4)){
                      Get.find<ApiDataController>().addCommunityModelList();
                    }
                    return 0;
                  }

              ))
              ],
            ),
            Visibility(
                visible: apiController.isCommunityLoading,
                child: Center(child: CircularProgressIndicator()))
          ],
        );
      }
        ,),
    );

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

  Widget lastImage(ApiDataController apiController, int index) {
    if(apiController.communityList[index].images.length < 2) {return Expanded(
        flex: 0,
        child: SizedBox.shrink());}
    return Column(
                                                children: [
                                                  SizedBox(height: common_sss_gap*2,),
                                                  Expanded(
                                                    child:  Container(
                                                      child:  _networkImage(apiController, index, 0),
                                                    ),
                                                  ),
                                                ],
                                              );
  }

  CachedNetworkImage _networkImage(ApiDataController apiController, int index, int imgnum) {
    return CachedNetworkImage(
          width: double.maxFinite,
          height: double.maxFinite,
          fit: BoxFit.fill,
          imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
          image: imageProvider, fit: BoxFit.fill),
          ),),
          imageUrl: "$mainUrl$thumbnailImageStoragePath${apiController.communityList[index].images[imgnum].path}",
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

/*  IconButton dotButton(BuildContext context) {
    return IconButton(onPressed: (){
                                    showCupertinoModalBottomSheet(
                                        expand: false,
                                        context: context, builder: (context) => Material(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _bottomSheetOption(Text("신고하기"), (){print('신고하기 ');}),
                                          SizedBox(height: common_ll_gap,)
                                        ],
                                      ),
                                    ));
                                  }, icon: Icon(Icons.more_vert));
  }*/
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
  InkWell _bottomSheetOption(Text textview, GestureTapCallback function) {
    return InkWell(
        onTap: function,
        child: Padding(
          padding: const EdgeInsets.all(common_ll_gap),
          child: SizedBox(
              width: double.maxFinite,
              child: textview),
        ));
  }
  void tabCliked(TapOption value){
    print("TapOption : $value");
    if(_tapOption == value){
      logger.d("이미 선택 됨");
      return;
    }
    setState(() {
      _tapOption = value;
    });
    Get.find<ApiDataController>().communityTabOption = _tapOption;
    Get.find<ApiDataController>().refreshCommunityModelList(taboption:_tapOption );
    //if ()
  }

  @override
  void dialogDelete(Object object) async{
    var thisCommunityModel = object as CommunityModel;
    logger.d("override dialog Delete");
    var response = await Dio().delete('$mainUrl/api/v1/user/community/${thisCommunityModel.id}',
    data: {"communityId":thisCommunityModel.id});
    print("결과는" + response.statusCode.toString());
    print("data: " + response.data.toString());
    if(response.statusCode.toString() == "200"){
    Get.find<ApiDataController>().refreshCommunityModelList(taboption: Get.find<ApiDataController>().communityTabOption);
    }
  }

  @override
  void diloagModify(Object object) {
    logger.d("override dialog Modify");
    Get.to(WriteCommunityPage(communityModel: object as CommunityModel));
  }

  @override
  void dialogReport(object) async{
    logger.d("override dialog Report");
    var thisCommunityModel = object as CommunityModel;
    var response = await Dio().get("$mainUrl/api/v1/user/community/${thisCommunityModel.id}/1/report",
    queryParameters : {"communityId": thisCommunityModel.id, "memberId": 1});
    print("결과는" + response.statusCode.toString());
    print("data: " + response.data.toString());
    if(response.statusCode.toString() == "200"){
      Get.find<ApiDataController>().refreshCommunityModelList(taboption: Get.find<ApiDataController>().communityTabOption);
    }
  }

  @override
  void dialogShare(object) {
    //
  }
}
