import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/logger.dart';
import 'package:notrip/constants/material_color.dart';
import 'package:notrip/constants/string_address.dart';
import 'package:notrip/controllers/api_data_controller.dart';
import 'package:notrip/interface/dialog.dart';
import 'package:notrip/models/comfortable_options.dart';
import 'package:notrip/models/community_model.dart';
import 'package:notrip/models/comment_model.dart';
import 'package:notrip/wigets/image_viewer.dart';
import 'package:notrip/pages/community/write_community_page.dart';
import 'package:notrip/tools/times.dart';
import 'package:notrip/wigets/community.dart';
import 'package:notrip/wigets/contents.dart';
import 'package:notrip/wigets/round_wigets.dart';
import 'package:notrip/wigets/show_toast.dart';
import 'package:share/share.dart';

class DetailCommunityPage extends StatefulWidget {
  CommunityModel _communityModel;
   DetailCommunityPage(this._communityModel, {@required this.index ,Key key}) : super(key: key);
  int index= -1;
  @override
  _DetailCommunityPageState createState() => _DetailCommunityPageState();
}

class _DetailCommunityPageState extends State<DetailCommunityPage> implements DialogInterface{

  TextEditingController _commentTextController;
  FocusNode _commentFocusNode;
  var _icons = [['assets/icons/ic_wheelchair.png', 'assets/icons/ic_nokids.png'],
    ['assets/icons/ic_toilet.png', 'assets/icons/ic_parking.png'],
    ['assets/icons/ic_wifi.png' , 'assets/icons/ic_pet.png']];
  List _comfortableOptions=[];
  var _isgood = false;
  Future<CommunityModel> _communityFuture;
  Future<List<CommentModel>> _commentFuture;
  List<CommentModel> lastCommentList=[];
  int nextCommentIdx = -1;
  int lastCallCommentIdx = -1;
  int communityCommentSize = 30;
  int communityCommentPageIndex = -1;
  int totalElements = -1;
  int _commentIndex=-1;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _commentTextController = TextEditingController();
    _commentFocusNode = FocusNode();
    _communityFuture = _fetch1();
    _commentFuture = _fetch2();
    communityCommentPageIndex = 0;

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
       // logger.d("max scroll에 근접함");
        if (nextCommentIdx == lastCallCommentIdx) {
          logger.d("새로운 댓글 로드");
          return;
        }
        if (nextCommentIdx * communityCommentSize >= totalElements) {
         // logger.d("모두 로드 함");
          return;
        }
        setState(() {
          _commentFuture = _fetch2(commentlist: lastCommentList);
        });
      }
    });
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        logger.d("키보드: $visible");
        if(visible==false){
          _commentFocusNode.unfocus();
          _commentTextController.text ="";
          _commentIndex = -1;
        }
      },
    );
   
  }
  @override
  void dispose() {
    _scrollController.dispose();
    _commentTextController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.d("${widget._communityModel.id}의 데이터->");
    return FutureBuilder(
        future: Future.wait([_communityFuture, _commentFuture]),
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
           CommunityModel communitySnapshotData = snapshot.data[0];
           List<CommentModel> commentSnapshotData  = snapshot.data[1];

           lastCommentList = snapshot.data[1];
           _isgood = communitySnapshotData.isGood;
           _comfortableOptions= [[
             ComfortableOptions(checked: communitySnapshotData.isWheelchair, label: "휠체어 가능"),
             ComfortableOptions(checked: communitySnapshotData.isNokids, label: "노키즈존")
           ],[
             ComfortableOptions(checked: communitySnapshotData.isToilet, label: "화장실 있음"),
             ComfortableOptions(checked: communitySnapshotData.isParking, label: "주차 가능")
           ],[
             ComfortableOptions(checked: communitySnapshotData.isWifi, label: "와이파이 있음"),
             ComfortableOptions(checked: communitySnapshotData.isPet, label: "반려동물 가능")
           ]];
           //logger.d("이미지 데이터 : $mainUrl$imageStoragePath${snapshotData.images[0]}");
            return WillPopScope(
                onWillPop: () {
                  logger.d("백버튼");
                  if(1==1){
                    return Future(() => true);
                  }else{return Future(() => false);}
                },
              child: Scaffold(
                resizeToAvoidBottomInset : true,
                appBar: AppBar(
                  title: Text("${communitySnapshotData.nickName}님의 글",),
                  centerTitle: true,
                  actions: [communitySnapshotData.id != 1?
                  MyCommunityDotButton(communitySnapshotData, diloagModify, dialogDelete, dialogShare) :
                  OtherCommunityDotButton(communitySnapshotData, dialogReport, dialogShare)
                  ],
                ),
                body:  Column(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: CustomScrollView(
                          controller: _scrollController,
                        scrollDirection: Axis.vertical,
                          slivers: [
                            SliverToBoxAdapter(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  headerWidget(communitySnapshotData, context, ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: common_main_gap),
                                    child: Text(communitySnapshotData.memo, ),
                                  ),
                                  SizedBox(height: 20,),
                                  _imageList(communitySnapshotData),
                                  _comportableInfo(),
                                  Column(
                                      children: [
                                        heartReplyButton(communitySnapshotData),
                                        Divider(height: 8, thickness: 8, color: greyF1F1F1,),
                                      ]
                                  ),
                                ],
                              ),
                            ),
                            SliverList(delegate: SliverChildListDelegate(
                                List.generate(commentSnapshotData.length, (index) =>
                                    _commentsListWidget(communitySnapshotData,commentSnapshotData[index], index))
                              ..add(BottomProgressBar(totalElements: totalElements, nextCommentIdx: nextCommentIdx, communityCommentSize: communityCommentSize)),)
                            )],),),),
                    Divider(thickness: 1, height: 1,),
                    _commentWriteWidget(communitySnapshotData, commentSnapshotData)
                  ],
                ),
              ),
            );
          }
        });
  }

  Widget heartReplyButton(CommunityModel communitySnapshotData) {
    return Padding(
                                        padding: const EdgeInsets.fromLTRB(common_main_gap,0,common_main_gap,common_s_gap),
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () async{
                                                print("좋아요 클릭");
                                                await _likefetch();
                                                refreshCommunityModel();
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(Icons.favorite_border, color: _isgood? Colors.red:greyCCCCCC,),
                                                  Text(communitySnapshotData.goodCount.toString()),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 10,),
                                            SvgPicture.asset('assets/icons/ic_talk_bubble.svg', color: greyCCCCCC,),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: common_sss_gap),
                                              child: Text(communitySnapshotData.replyCount.toString()),
                                            ),
                                            Spacer(),
                                            scrapButton(communitySnapshotData)
                                          ],
                                        ),
                                      );
  }
  Future refreshCommunityModel() async{
    print(widget.index.toString());
    setState(() {
      _communityFuture = _fetch1(isViewCount: false);  //이거 말고 더 좋은 방법은 없을까
    });
  }
  Future refreshCommentModel() async{
    print(widget.index.toString());
    setState(() {
      _commentFuture = _fetch2();  //이거 말고 더 좋은 방법은 없을까
    });
  }
  IconButton scrapButton(CommunityModel communitySnapshotData) {
    return IconButton(onPressed: () async{
            logger.d("스크랩 클릭");
            var response = await Dio().get("$mainUrl/api/v1/user/community/${communitySnapshotData.id}/1/scrap",
                queryParameters : {"communityId": communitySnapshotData.id, "memberId": 1});
            print("결과는" + response.statusCode.toString());
            print("data: " + response.data.toString());
            if(response.statusCode.toString() == "200"){
              refreshCommunityModel();
            }
          }, icon: communitySnapshotData.isScrap ? SvgPicture.asset('assets/icons/ic_scrap_filled.svg',)
                                                  : SvgPicture.asset('assets/icons/ic_scrap.svg',)
                  );
  }

  Padding _comportableInfo() {
    return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: common_main_gap),
                                child: Container(
                                  padding: const EdgeInsets.all(common_main_gap),
                                  width: double.maxFinite,
                                  //  height: 190,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: greyF1F1F1
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("편의정보", style: TextStyle(fontWeight: FontWeight.w700),),
                                      SizedBox(height: 10,),
                                      Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: List.generate(3, (index1) => Row(
                                            children: List.generate(2, (index2) => Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(common_ss_gap),
                                                child: Row(
                                                  children: [
                                                    //Text("안녕하세요")
                                                    //Icon(Icons.ac_unit)
                                                    SizedBox(
                                                        width : 32,
                                                        height: 32,
                                                        child: Image.asset(_icons[index1][index2], )),
                                                    SizedBox(width: 10,),
                                                    Text((_comfortableOptions[index1][index2] as ComfortableOptions).checked? (_comfortableOptions[index1][index2] as ComfortableOptions).label:"-")
                                                  ],
                                                ),
                                              ),
                                            )),
                                          ),)
                                      )
                                    ],
                                  ),
                                ),
                              );
  }

  Column _imageList(CommunityModel communitySnapshotData) {
    return Column(
    children: List.generate(communitySnapshotData.images.length, (index) => Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: common_main_gap),
          child: InkWell(
            onTap: (){
              logger.d("사진 클릭");
              Get.to(ImageViewer(communitySnapshotData.images, communitySnapshotData.nickName, communitySnapshotData.createdAt, initImgIndex: index,));
            },
            child: Hero(
              tag: communitySnapshotData.images[index].id,
              child: CachedNetworkImage(
                width: double.maxFinite,
                fit: BoxFit.fill,
                imageBuilder: (context, imageProvider) => AspectRatio(
                  aspectRatio: 1/double.parse(communitySnapshotData.images[index].ratio),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                    ),),
                ),
                imageUrl: "$mainUrl$imageStoragePath${communitySnapshotData.images[index].path}",
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
              ),
            ),
          ),
        ),
        SizedBox(height: 16,),
      ],
    ),),
  );
  }

  Widget _commentWriteWidget(CommunityModel communitySnapshotData, List<CommentModel> commentSnapshotData)  {
    return  SizedBox(
    height: 50,
    child: Row(
      children: [
        SizedBox(width: 15,),
        Expanded(child: TextField(
          onSubmitted: (text){
            submitComment(communitySnapshotData, commentSnapshotData);
          },
          focusNode: _commentFocusNode,
          controller: _commentTextController,
          decoration: InputDecoration(
          border: InputBorder.none, hintText: '댓글을 남겨주세요.',
          hintStyle: TextStyle(color: greyB7B7B7)
          ),),
        ), TextButton(
            onPressed: () async{
             submitComment(communitySnapshotData, commentSnapshotData );
            }, child: Text("등록",
            style: TextStyle(fontWeight: FontWeight.bold),))
      ],
    ),
  );
  }
  void submitComment(CommunityModel communitySnapshotData, List<CommentModel> commentModelList) async{
    if (_commentTextController.text.isEmpty){
      logger.d("빈 텍스트 댓글 등록!");
      return;}
    logger.d("댓글 등록!");
    var params = {
      "communityId": communitySnapshotData.id,
      "memberId": 2,
      "memo": _commentTextController.text
    };
    if(_commentIndex != -1){params["topReply"] = commentModelList[_commentIndex].id;}

    var response = await Dio().post('$mainUrl/api/v1/user/community/reply/', data: params);
    print("결과는" + response.statusCode.toString());
    print("data: " + response.data.toString());
    if(response.statusCode.toString() == "200"){
      logger.d("댓글 업로드 성공!");
      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      refreshCommunityModel();
      setState(() {
        _commentFuture = _fetch2();
      });
      //  Get.find<ApiDataController>().refreshCommnityModel();
      //  Get.back();
      _commentFocusNode.unfocus();
      _commentTextController.text ="";
    }else{
      logger.d("댓글 업로드 실패!");
      showToast("잠시 후에 시도해주세요.");
    }
  }
  Container _naverMapWidget() {
    return Container(
        padding: const EdgeInsets.all(common_main_gap),
        width: double.maxFinite,
        height: Get.width,
        child:
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: NaverMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(37.566570, 126.978442),
              zoom: 17,
            ),
            locationButtonEnable: true,
            indoorEnable: true,
          ),
        ),
        //MapSample(),
      );
  }

/*  IconButton dotdotdotButton(BuildContext context) {
    return IconButton(onPressed: (){
                  showCupertinoModalBottomSheet(
                      expand: false,
                      context: context, builder: (context) => Material(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _bottomSheetOption(Text("공유하기"), (){print('공유하기 '); Share.share("12345", subject: "678910");}),
                        _bottomSheetOption(Text("수정하기"), (){print('수정하기 ');}),
                        _bottomSheetOption(Text("삭제하기"), (){print('삭제하기 ');}),
                        _bottomSheetOption(Text("신고하기"), (){print('신고하기 ');}),
                      ],
                    ),
                  ));

                }, icon: Icon(Icons.more_vert));
  }*/

  IconButton myCommentDotdotdotButton(BuildContext context, CommentModel commentModel) {
    return IconButton(
        onPressed: () async {
          await showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) => CupertinoActionSheet(
              // title: const Text('Title'),
                message: const Text('내가 쓴 글'),
                actions: <CupertinoActionSheetAction>[
                  CupertinoActionSheetAction(
                    child: const Text(
                      '수정하기',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  CupertinoActionSheetAction(
                    child: const Text(
                      '삭제하기',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      Get.back();
                      dialogDelete(commentModel);
                    },
                  ),
                  /* CupertinoActionSheetAction(
                child: const Text('Action Two'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )*/
                ],
                cancelButton: CupertinoActionSheetAction(
                  child: const Text(
                    '취소',
                    style: TextStyle(color: Colors.blue),
                  ),
                  isDefaultAction: true,
                  onPressed: () {
                    //returnValue = false;
                    Get.back();
                  },
                )),
          );
        }, icon: Icon(Icons.more_vert));
  }
/*  IconButton othersCommunityDotdotdotButton(BuildContext contex, CommunityModel _communityModel) {
    return IconButton(
        onPressed: () async {
          await showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) => CupertinoActionSheet(
              // title: const Text('Title'),
                message:  Text('${_communityModel.nickName}이 쓴 글'),
                actions: <CupertinoActionSheetAction>[
                  CupertinoActionSheetAction(
                    child: const Text(
                      '신고하기',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  *//* CupertinoActionSheetAction(
                child: const Text('Action Two'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )*//*
                ],
                cancelButton: CupertinoActionSheetAction(
                  child: const Text(
                    '취소',
                    style: TextStyle(color: Colors.blue),
                  ),
                  isDefaultAction: true,
                  onPressed: () {
                    //returnValue = false;
                    Get.back();
                  },
                )),
          );
        }, icon: Icon(Icons.more_vert));
  }*/
  IconButton othersCommentDotdotdotButton(BuildContext contex, CommentModel _commentModel) {
    return IconButton(
        onPressed: () async {
          await showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) => CupertinoActionSheet(
              // title: const Text('Title'),
                message:  Text('${_commentModel.nickName}님의 댓글'),
                actions: <CupertinoActionSheetAction>[
                  CupertinoActionSheetAction(
                    child: const Text(
                      '신고하기',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      dialogReport(_commentModel);
                      Get.back();
                    },
                  ),
                  /* CupertinoActionSheetAction(
                child: const Text('Action Two'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )*/
                ],
                cancelButton: CupertinoActionSheetAction(
                  child: const Text(
                    '취소',
                    style: TextStyle(color: Colors.blue),
                  ),
                  isDefaultAction: true,
                  onPressed: () {
                    //returnValue = false;
                    Get.back();
                  },
                )),
          );
        }, icon: Icon(Icons.more_vert));
  }

  Future<CommunityModel> _fetch1({bool isViewCount= true}) async {
    var response = await Dio().get("$mainUrl/api/v1/user/community/${widget._communityModel.id}/1/detail",
        queryParameters : {"isViewCount": isViewCount});
    logger.d("커뮤니티 가져오기, 결과는" + response.statusCode.toString());
    print("data: " + response.data.toString());
    var communitymodel = CommunityModel();
    if (response.statusCode.toString() == "200"){
    communitymodel = CommunityModel.fromJson(response.data["data"]);
    Get.find<ApiDataController>().refreshCommunityModel(widget.index, communitymodel);
    }
    return communitymodel;
  }

  Future<List<CommentModel>> _fetch2({List<CommentModel> commentlist}) async {
    lastCallCommentIdx = nextCommentIdx;
    var params = {
      //"communityId": widget._communityModel.id,
      "page": commentlist==null ? 0 : nextCommentIdx,
      "size": communityCommentSize
    };
    var response = await Dio().get("$mainUrl/api/v1/user/community/reply/${widget._communityModel.id}/1", queryParameters: params);
    logger.d("댓글 가져오기, 결과는" + response.statusCode.toString());
    print("data: " + response.data.toString());
    nextCommentIdx = int.parse(response.data["page"].toString())+1;
    totalElements = int.parse(response.data["totalElements"].toString());
    List<CommentModel> commentmodelList=commentlist??[];
     commentmodelList.addAll(List.generate(response.data["data"].length, (index) => CommentModel.fromJson(response.data["data"][index])));
    return commentmodelList;
  }

  Future<bool> _likefetch() async {
    var response = await Dio().get("$mainUrl/api/v1/user/community/${widget._communityModel.id}/1/good");
    var resposnValue = false;
    logger.d("결과는" + response.statusCode.toString());
    print("data: " + response.data.toString());
    resposnValue = response.data;
    return resposnValue;
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

  Widget _commentsListWidget(CommunityModel _communityModel1,CommentModel commentModel, int index1) {
    return Column(
      children: [
        InkWell(
          onTap: (){
            logger.d("답글 달기 클릭 $index1");
            //_commentTextController.
            if(index1 !=  _commentIndex) {
              _commentFocusNode.unfocus();
              _commentFocusNode.requestFocus();
              _commentIndex = index1;
            }

          },
          child: Row( crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Padding(
                              padding: const EdgeInsets.all(common_gap*screenSizeFactor),
                              child: networkCircleImg(imgurl: "https://picsum.photos/200",
                                  imgsize: iconsize_ll*screenSizeFactor, replaceicon: Icons.person),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: common_gap),
                                child: Column(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        commentModel.isCommunityReport?   SizedBox.shrink() : Text(commentModel.nickName, style: TextStyle(
                                        fontWeight: FontWeight.w700
                                      ),),
                                      SizedBox(width: 10,),
                                      Expanded(child: commentModel.isCommunityReport? Text("신고 된 댓글입니다."):Text(commentModel.memo, maxLines: 100,)
                                      )
                                    ],),
                                    SizedBox(height: 5,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                      Text(printSavedDate(commentModel.createdAt), style: TextStyle(color: greyCCCCCC,fontSize: 14)),
                                        SizedBox(width: 10,),
                                        Text("답글달기", style: TextStyle(color: greyB2B2B2, fontSize: 14, fontWeight: FontWeight.bold),),
                                    ],)
                                  ],
                                ),
                              ),
                            ),
                           // Spacer(),
                            (commentModel.isCommunityReport||commentModel.deleteStatus)? SizedBox.shrink():   _communityModel1.memberId ==1 ? myCommentDotdotdotButton(context,commentModel) : othersCommentDotdotdotButton(context, commentModel),
                          ],
                        ),
        ),
      ]..addAll(
          List.generate(commentModel.children.length, (index) => InkWell(
            onTap: (){
              logger.d("답글 달기 클릭 $index1");
              //_commentTextController.
              if(index1 !=  _commentIndex) {
                _commentFocusNode.unfocus();
                _commentFocusNode.requestFocus();
                _commentIndex = index1;
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:

              [
                SizedBox(width: 50,),
                Padding(
                  padding: const EdgeInsets.all(common_gap*screenSizeFactor),
                  child: networkCircleImg(imgurl: "https://picsum.photos/200",
                  imgsize: iconsize_ll*screenSizeFactor, replaceicon: Icons.person),
                ),
                Expanded(
                  child: Padding(
                  padding: const EdgeInsets.only(top: common_gap),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            commentModel.children[index].isCommunityReport?   SizedBox.shrink() :  Text(commentModel.children[index].nickName, style: TextStyle(
                                fontWeight: FontWeight.w700
                            ),),
                            SizedBox(width: 10,),
                            Expanded(child: Text(
                              commentModel.children[index].isCommunityReport? "신고 된 댓글입니다.":
                              commentModel.children[index].memo, maxLines: 100,))
                          ],),
                        SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(printSavedDate(commentModel.children[index].createdAt), style: TextStyle(color: greyCCCCCC,fontSize: 14)),
                            SizedBox(width: 10,),
                            Text("답글달기", style: TextStyle(color: greyB2B2B2, fontSize: 14, fontWeight: FontWeight.bold),),
                          ],)
                      ],
                    ),
                  ),
                ),
                (commentModel.children[index].isCommunityReport||commentModel.children[index].deleteStatus)? SizedBox.shrink(): commentModel.children[index].memberId !=1 ? myCommentDotdotdotButton(context, commentModel.children[index]) : othersCommentDotdotdotButton(context, commentModel.children[index]),
              ],
            ),
          ))
      ),
    );
  }

  @override
  void dialogDelete(Object object) async{
    if (object is CommunityModel) {
    var thisCommunityModel = object;
    logger.d("detail community -> delete");
    var response = await Dio().delete('$mainUrl/api/v1/user/community/${thisCommunityModel.id}',
        data: {"communityId":thisCommunityModel.id});
    print("결과는" + response.statusCode.toString());
    print("data: " + response.data.toString());
    if(response.statusCode.toString() == "200"){
      Get.back();
      Get.find<ApiDataController>().refreshCommunityModelList(taboption: Get.find<ApiDataController>().communityTabOption);
    }}else if(object is CommentModel) {
      logger.d('commentModel delete');
      var thisCommentModel = object;
      var response = await Dio().delete('$mainUrl/api/v1/user/community/reply/${thisCommentModel.id}');
      print("결과는" + response.statusCode.toString());
      print("data: " + response.data.toString());
      refreshCommentModel();
    }
  }

  @override
  void dialogReport(Object object) async{
    logger.d("detail community -> report");
    logger.d("override dialog Report");

    if (object is CommunityModel) {
      var thisCommunityModel = object;
      var response = await Dio().get("$mainUrl/api/v1/user/community/${thisCommunityModel.id}/1/report",
          queryParameters : {"communityId": thisCommunityModel.id, "memberId": 1});
      print("결과는" + response.statusCode.toString());
      print("data: " + response.data.toString());
      if(response.statusCode.toString() == "200"){
        Get.back();
        Get.find<ApiDataController>().refreshCommunityModelList(taboption: Get.find<ApiDataController>().communityTabOption);
      }
      }else if (object is CommentModel){
      logger.d('commentmodel report ${object.id}');
      var thisCommentModel = object;
      var response = await Dio().post("$mainUrl/api/v1/user/community/reply/report",
      data: {
          "communityReplyId": thisCommentModel.id,
          "memberId": 1 });
      print("결과는" + response.statusCode.toString());
      print("data: " + response.data.toString());
      refreshCommentModel();
    }


  }

  @override
  void diloagModify(Object object) {
    logger.d("detail community -> modify");
    if (object is CommunityModel) Get.off(WriteCommunityPage(communityModel: object as CommunityModel));

  }

  @override
  void dialogShare(object) {
    logger.d("detail community -> share");
    Share.share("12345", );
  }
}
