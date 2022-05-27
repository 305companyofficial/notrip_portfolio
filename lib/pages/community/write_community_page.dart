import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/logger.dart';
import 'package:notrip/constants/material_color.dart';
import 'package:notrip/constants/material_color.dart';
import 'package:notrip/constants/string_address.dart';
import 'package:notrip/controllers/api_data_controller.dart';
import 'package:notrip/models/comfortable_options.dart';
import 'package:notrip/models/community_model.dart';
import 'package:notrip/wigets/show_toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart';

class WriteCommunityPage extends StatefulWidget {
  WriteCommunityPage({this.communityModel,Key key}) : super(key: key);
  CommunityModel communityModel;
  @override
  _WriteCommunityPageState createState() => _WriteCommunityPageState();
  }

class _WriteCommunityPageState extends State<WriteCommunityPage> {
  List<File> _images=[];
  double imagesize = 100;
  bool isProgressing = false;
  List<Images> _networkImages= [];
  List<int> removedImageIndex =[];
  List<ComfortableOptions> options = [];

  TextEditingController titleController;
  TextEditingController contentsController = TextEditingController();
  @override
  void initState() {
    super.initState();
    titleController =  widget.communityModel ==null ? TextEditingController(): TextEditingController(text: widget.communityModel.subject );
    contentsController =  widget.communityModel ==null ? TextEditingController(): TextEditingController(text: widget.communityModel.memo );
    if(widget.communityModel==null){
      options.add(ComfortableOptions(checked: false , label: "휠체어 가능"));
      options.add(ComfortableOptions(checked: false , label: "화장실 있음"));
      options.add(ComfortableOptions(checked: false , label: "와이파이 있음"));
      options.add(ComfortableOptions(checked: false , label: "노키즈존"));
      options.add(ComfortableOptions(checked: false , label: "주차가능"));
      options.add(ComfortableOptions(checked: false , label: "반려동물 가능"));
    }else{
      options.add(ComfortableOptions(checked: widget.communityModel.isWheelchair , label: "휠체어 가능"));
      options.add(ComfortableOptions(checked: widget.communityModel.isToilet , label: "화장실 있음"));
      options.add(ComfortableOptions(checked: widget.communityModel.isWifi , label: "와이파이 있음"));
      options.add(ComfortableOptions(checked: widget.communityModel.isNokids , label: "노키즈존"));
      options.add(ComfortableOptions(checked: widget.communityModel.isParking , label: "주차가능"));
      options.add(ComfortableOptions(checked: widget.communityModel.isPet , label: "반려동물 가능"));
      _networkImages.clear();
      _networkImages.addAll(widget.communityModel.images);
    }

  }
  @override
  void dispose() {
    titleController.dispose();
    contentsController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        print("WillPopScope");
        var returnValue = true;
        if(widget.communityModel== null) {
          if ((titleController.text.isEmpty &&
              contentsController.text.isEmpty)) {
            print("비어있음");
            return Future(() => returnValue);
          }
        }else{
          if ((titleController.text== widget.communityModel.subject   && contentsController.text==widget.communityModel.memo
          && _images.length==0 && removedImageIndex.length==0)) {
            print("비어있음");
            return Future(() => returnValue);
          }
        }
        await showCupertinoModalPopup<void>(
          context: context,
          builder: (BuildContext context) => CupertinoActionSheet(
           // title: const Text('Title'),
            message: const Text('뒤로 가시면 작성글이 저장되지 않습니다.\n작성을 취소하시겠습니까?'),
            actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                child: const Text('작성취소', style: TextStyle(color: Colors.red),),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
              cancelButton: CupertinoActionSheetAction(
                child: const Text('취소', style: TextStyle(color: Colors.blue),),
                isDefaultAction: true,
                onPressed: () {
                  returnValue = false;
                  Get.back();
                },
              )
          ),
        );
        print("returnValue:$returnValue");
        return Future(() => returnValue);
      },
      child: IgnorePointer(
        ignoring: isProgressing,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: widget.communityModel==null ? Text('글쓰기'): Text('글 수정하기'),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(common_main_gap),
                          hintText: '제목을 입력해주세요',
                        hintStyle: TextStyle(color: greyCCCCCC)
                      ),
                    ),
                    Divider(thickness: 1, height: 1,),
                    TextField(
                      controller: contentsController,
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(common_main_gap),
                          hintText: '내용을 입력해주세요',
                          hintStyle: TextStyle(color: greyCCCCCC)
                      ),
                      minLines: 5,
                      maxLines: 5,
                    ),
                    Divider(thickness: 1, height: 1,),
                    SizedBox(
                      height: 20,
                    ),
                    _imagesWidget(),
                    Padding(
                      padding: const EdgeInsets.all(common_main_gap),
                      child: Text("사진을 추가해주세요.(최대 5장)", style: TextStyle(color: greyCCCCCC)
                      ),
                    ),
                    SizedBox(height: 10,),
                    Divider(thickness: 1,height: 1,  ),
                    Padding(
                      padding: const EdgeInsets.all(common_main_gap),
                      child: Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color: greyF1F1F1,
                          borderRadius: BorderRadius.circular(5)
                        ),
                        padding: const EdgeInsets.all(common_s_gap),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("편의정보 입력하기(선택)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                            Column(
                              children: List.generate(options.length, (index) => checkOptions(index1: index, label: options[index].label)),
                            )
                          ],
                        ),
                      ),
                    ),
                    _confirmButton(),
                    SizedBox(height: common_l_gap,)
                    //Divider(thickness: 1, height: 1,),
                    /*Padding(
                      padding: const EdgeInsets.all(common_main_gap),
                      child: Row(
                        children: [
                          Icon(Icons.location_on_rounded),
                          Text("위치등록")
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: common_main_gap),
                      child: Text("위치정보를 공유해주세요."),
                    )*/
                  ],
                ),
              ),
              Visibility(
                visible: isProgressing,
                child: Center(child: SizedBox(
                    width: 50,height: 50,
                    child: CircularProgressIndicator(color: Colors.blue, strokeWidth: 10,)) ,),
              )
            ],
          ),
        ),
      ),
    );
  }

  InkWell checkOptions({@required int index1, @required String label}) {
    return InkWell(
                        splashColor: yellowD3DE15,
                          onTap: (){
                            setState(() {
                              options[index1].checked = !options[index1].checked ;
                              logger.d("$label Click ${options[index1].label} ");
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: common_s_gap),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(value: options[index1].checked, onChanged: (boolvalue){
                                    setState(() {options[index1].checked = boolvalue;});},
                                    checkColor: Colors.white,
                                    fillColor: MaterialStateProperty.all<Color>(yellowD3DE15),
                                  ),
                                ),
                                Text(label)
                              ],
                            ),
                          ),
                        );
  }

  Widget _confirmButton()  {
    return Padding(
                  padding: const EdgeInsets.all(common_main_gap),
                  child: InkWell(
                    onTap: () async{
                      if(titleController.text.isEmpty){showToast("제목을 입력해주세요."); return;}
                      if(contentsController.text.isEmpty){showToast("내용을 입력해주세요."); return;}
                      setState(() {
                        isProgressing = true;
                      });
                      print("서버 호출1");
                       var multiparts = [];
                       for(int i=0;i<_images.length;i++ ){
                         multiparts.add( await MultipartFile.fromFile(_images[i].path, filename: basename(_images[i].path)));
                       }
                      var formData = FormData.fromMap({
                        'memberId': '1',
                        'memo': "${contentsController.text}",
                        'subject': "${titleController.text}",
                        'images': multiparts,
                        'isWheelchair' : options[0].checked,
                        'isToilet' : options[1].checked,
                        'isWifi' : options[2].checked,
                        'isNokids' : options[3].checked,
                        'isParking' : options[4].checked,
                        'isPet' : options[5].checked,
                        'deleteFileIds':  widget.communityModel==null?[]:removedImageIndex
                      }
                      );
                      var response = await Dio().post(
                          widget.communityModel==null? '$mainUrl/api/v1/user/community' : '$mainUrl/api/v1/user/community/${widget.communityModel.id}'
                          , data: formData);
                      print("결과는" + response.statusCode.toString());
                      print("data: " + response.data.toString());
                      if(response.statusCode.toString() == "200"){
                        logger.d("커뮤니티 업로드 성공!");
                      await Get.find<ApiDataController>().refreshCommunityModelList(taboption: Get.find<ApiDataController>().communityTabOption);
                        setState(() {
                          isProgressing = false;
                        });
                      Get.back();
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: yellowD3DE15,
                        borderRadius: BorderRadius.circular(5)
                      ),
                      padding: const EdgeInsets.all(common_main_gap),
                      width: double.maxFinite,
                      child: Center(child: Text(widget.communityModel==null?"등록":"수정", style: TextStyle(fontWeight: FontWeight.bold),)),
                    ),
                  ),
                );
  }

  SizedBox _imagesWidget() {
    return SizedBox(
                  height: imagesize+20,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: common_gap),
                    scrollDirection: Axis.horizontal,
                    children:
                        List.generate(_networkImages.length, (index) =>
                            _networkImageCard(index, _networkImages[index]))
                        ..addAll(List.generate(
                          _images.length, (index) =>
                            _fileImageCard(index),
                        ))..add(   Visibility(
                          visible: maxImageLength - _images.length > 0,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, common_ss_gap+iconsize_m/2, common_ss_gap, 0),
                            child: InkWell(
                              onTap: (){
                                print("사진 추가하기");
                                loadAssets(_images.length);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                  width: imagesize,
                                  height: imagesize,
                                  color: greyE5E5E5,
                                  child: Icon(Icons.photo, color: greyCCCCCC,),
                                ),
                              ),
                            ),
                          ),
                        )),
                  ),
                );
  }

  Stack _fileImageCard(int index) {
    return Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top : common_l_gap, right : common_ss_gap),
                                child: InkWell(
                                  onTap: () async {
                                  print("이미지 클릭$index");
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Container(
                                       width: imagesize,
                                        height: imagesize,
                                        child: Image.file(
                                          _images[index],
                                            fit: BoxFit.fill
                                        )
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: imagesize+ common_ss_gap,
                                height: imagesize+ common_ss_gap+iconsize_m,
                                child: Align(
                                    alignment: Alignment.topRight,
                                    child: InkWell(
                                      onTap: (){
                                        print("사진 삭제 클릭 $index");
                                        setState(() {
                                          _images.removeAt(index);
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(common_ss_gap),
                                        child: Container(
                                          width: iconsize_m,
                                            height: iconsize_m,
                                            child: SvgPicture.asset('assets/icons/ic_delete.svg',)),
                                      ),
                                    )),
                              )
                            ],
                          );
  }
  Stack _networkImageCard(int index1, Images image) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top : common_l_gap, right : common_ss_gap),
          child: InkWell(
            onTap: () async {
              print("이미지 클릭${image.id}");
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                  width: imagesize,
                  height: imagesize,
                  child: CachedNetworkImage(
                      fit: BoxFit.fill,
                    imageUrl: "$mainUrl$imageStoragePath${image.path}",
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
                  )
              ),
            ),
          ),
        ),
        SizedBox(
          width: imagesize+ common_ss_gap,
          height: imagesize+ common_ss_gap+iconsize_m,
          child: Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: (){
                  logger.d("사진 삭제 클릭 ${image.id}");
                  removedImageIndex.add(image.id);
                  logger.d(removedImageIndex.toString());
                  setState(() {
                    _networkImages.removeAt(index1);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(common_ss_gap),
                  child: Container(
                      width: iconsize_m,
                      height: iconsize_m,
                      child: SvgPicture.asset('assets/icons/ic_delete.svg',)),
                ),
              )),
        )
      ],
    );
  }


  String _error = 'No Error Dectected';
  int maxImageLength = 5;

  Future<void> loadAssets(int length) async {
    List<Asset> resultList = <Asset>[];
    var loadImageLength = maxImageLength - length;
    String error = 'No Error Detected';
    await Permission.storage.request().isGranted;
    await Permission.manageExternalStorage.request().isGranted;
    if(widget.communityModel!=null){loadImageLength = loadImageLength- widget.communityModel.images.length;}

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: loadImageLength,
        enableCamera: true, //오류나서 끔
        //selectedAssets: multipickImages,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Fatto",
        ),
        materialOptions: MaterialOptions(
          actionBarColor: "#D3DE15",
          statusBarColor: "#D3DE15",
          actionBarTitle: "사진 가져오기",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    List<File> addingimages= [];
      _error = error;
      if(resultList.length==0) return;
      setState(() {
        isProgressing= true;
      });
      print("이미지 길이1 resultList.length : ${resultList.length}");
    for(int i=0; i<resultList.length; i++){
      addingimages.add(await writeToFile(await resultList[i].getByteData(), i, resultList[i].name)
      );
    }
     /* resultList.asMap().forEach((index, element) {
        addingimages.add(   await writeToFile(await element.getByteData(), index) );
      });*/
    print("이미지 길이2 addingimages.length : ${addingimages.length}");

    setState(() {
      _images.addAll(addingimages);
      addingimages.clear();
      print("이미지 길이3 : ${_images.length}");
      isProgressing= false;
    });
  }

  Future<File> writeToFile(ByteData data, int i, String imagename) async {
    final buffer = data.buffer;
    //DateTime date = DateTime.now();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var newImagename = imagename.replaceAll(" ", "").replaceAll("%20", "");
    var filePath = tempPath + '/$i$newImagename'; // file_01.tmp is dump file, can be anything
    print("filePath : $filePath");
    return new File(filePath).writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
  }
