import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/logger.dart';
import 'package:notrip/constants/material_color.dart';
import 'package:notrip/constants/string_address.dart';
import 'package:notrip/models/article_model.dart';
import 'package:notrip/models/comfortable_options.dart';

class ArticleSpot extends StatefulWidget {
  ArticleSpot(this.id, {Key key}) : super(key: key);
  int id = -1;
  @override
  _ArticleSpotState createState() => _ArticleSpotState();
}

class _ArticleSpotState extends State<ArticleSpot> {
  var _icons = [['assets/icons/ic_wheelchair.png', 'assets/icons/ic_nokids.png'],
    ['assets/icons/ic_toilet.png', 'assets/icons/ic_parking.png'],
    ['assets/icons/ic_wifi.png' , 'assets/icons/ic_pet.png']];
  List _comfortableOptions=[];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getLocation(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
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
        Location locationSnapshotData = snapshot.data;
        _comfortableOptions =  [[
          ComfortableOptions(checked: locationSnapshotData.isWheelchair, label: "휠체어 가능"),
          ComfortableOptions(checked: locationSnapshotData.isNokids, label: "노키즈존")
        ],[
          ComfortableOptions(checked: locationSnapshotData.isToilet, label: "화장실 있음"),
          ComfortableOptions(checked: locationSnapshotData.isParking, label: "주차 가능")
        ],[
          ComfortableOptions(checked: locationSnapshotData.isWifi, label: "와이파이 있음"),
          ComfortableOptions(checked: locationSnapshotData.isPet, label: "반려동물 가능")
        ]];
      return Scaffold(
        appBar: AppBar(
          title: Text(locationSnapshotData.subject),
          actions: [
            IconButton(onPressed: (){
              print("bookmark");
            }, icon: locationSnapshotData.isScrap ? SvgPicture.asset('assets/icons/ic_scrap_filled.svg',color: Colors.black87,):
                 SvgPicture.asset('assets/icons/ic_scrap.svg', color: Colors.black87,)
            ),
            IconButton(onPressed: (){
              print("share");
            }, icon: Icon(Icons.share_outlined)),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _networkImage(),
              Padding(
                padding: const EdgeInsets.all(common_main_gap),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(locationSnapshotData.subject, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
                    Text(locationSnapshotData.title, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: grey666666, height: 1.4),),
                    Container(
                      padding: const EdgeInsets.all(common_main_gap),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: yellowD3DE15.withOpacity(0.15)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Text("주소"),
                              Text(locationSnapshotData.address),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Text("연락처"),
                              Text(locationSnapshotData.address),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Text("영업시간"),
                              Text("${locationSnapshotData.openTime} ~ ${locationSnapshotData.closeTime}"),
                              Text("${locationSnapshotData.note}", style: TextStyle(color: Colors.red),)
                            ],
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(onPressed: (){}, child: Text("길찾기", style: TextStyle(color: grey333333, fontWeight: FontWeight.w700),),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(yellowD3DE15),
                      elevation: MaterialStateProperty.all<double>(0)
                    ),
                    )
                  ],
                ),
              ),
              Divider(thickness: 8, height: 8,),
              Container(
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
              Html(data: locationSnapshotData.memo)
            ],
          ),
        ),
      );}});

  }

  CachedNetworkImage _networkImage() {
    return CachedNetworkImage(
              width: double.maxFinite,
              fit: BoxFit.fill,
              imageBuilder: (context, imageProvider) => AspectRatio(
                aspectRatio: 1.2,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                  ),),
              ),
              imageUrl: "https://picsum.photos/400",
              placeholder: (context, url) =>  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>  SizedBox.shrink(),
            );
  }

  Future<Location> _getLocation({bool isViewCount= true}) async {
    var response = await Dio().get("$mainUrl/api/v1/user/article/location/${widget.id}/1/detail",
        queryParameters : {"isViewCount": isViewCount});
    logger.d("장소 가져오기, 결과는" + response.statusCode.toString());
    print("data: " + response.data.toString());
    var locationModel = Location();
    if (response.statusCode.toString() == "200"){
      locationModel = Location.fromJson(response.data["data"]);
      //Get.find<ApiDataController>().refreshCommunityModel(widget.index, articleModel);
    }
    return locationModel;
  }
}
