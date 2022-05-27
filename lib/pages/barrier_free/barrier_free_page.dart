import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/logger.dart';
import 'package:notrip/constants/material_color.dart';
import 'package:notrip/controllers/location_info_controller.dart';
import 'package:notrip/models/moojangae_model.dart';
import 'package:notrip/pages/barrier_free/barrier_search_page.dart';

class BarrierFreePage extends StatefulWidget {
  const BarrierFreePage({Key key}) : super(key: key);
  @override
  _BarrierFreePageState createState() => _BarrierFreePageState();
}

class _BarrierFreePageState extends State<BarrierFreePage> {
  Position position;
  Future<Position> _positionFuture;
  Future<List<MoojangaeModel>> _locations;
  List<Marker> _markers = [];


  Future<Position> _fetch1() async {
    var myposition  = await Get.find<LocationInFoController>().getPosition();
    logger.d("fetch1 -> ${myposition.longitude}, ${myposition.latitude}");
    return myposition;
  }
  Future<List<MoojangaeModel>> _fetch2() async {
   OverlayImage myOverlayIcon;
   WidgetsBinding.instance.addPostFrameCallback((_) {
     OverlayImage.fromAssetImage(assetName: "assets/icons/ic_marker1.png", context: context).then((image) {
       if(mounted) setState(() => myOverlayIcon = image);
     }
     );
   });


    var myposition  = await Get.find<LocationInFoController>().getPosition();
    var moojaengaeList = await Get.find<LocationInFoController>().getMoojangae(myposition);
    logger.d("fetch2 -> ${moojaengaeList.length}");
    List<Marker> newmarker=[];
    moojaengaeList.asMap().forEach((index, value) async{
      newmarker.add(Marker(
            icon: myOverlayIcon,
          markerId: DateTime.now().toIso8601String()+index.toString(),
          // iconTintColor: green12D26B,
          position: LatLng(double.parse(value.mapy), double.parse(value.mapx)),
          //infoWindow: '테스트',
          onMarkerTab: (Marker marker, Map<String, int> iconSize){
            _onMarkerTap(marker, iconSize, value);
          },
          captionText: value.title
      )
      //LatLng(double.parse(value.mapx), double.parse(value.mapy))
      );
    });
    setState(() {
      _markers = newmarker;
    });
    return moojaengaeList;
  }
  @override
  void initState() {
    super.initState();
    _positionFuture = _fetch1();
    _locations =      _fetch2();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("배리어프리 시설찾기"),
      ),
      body: Container(
        child: FutureBuilder(
        future: Future.wait([_positionFuture, _locations]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot){
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
            Position myposition = snapshot.data[0];
            return  Stack(
              children: [
                NaverMap(
                    initialCameraPosition: CameraPosition(
                    target: LatLng(myposition.latitude, myposition.longitude),
                      zoom: 12
                    ),
                     markers: _markers,
                   // onMapTap: _onMapTap,
                ),
                Padding(
                  padding: const EdgeInsets.all(common_main_gap),
                  child: InkWell(
                    onTap: (){
                      print('search bar -on clicked');
                      Get.to(BarrierSearchPage());
                    },
                    child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.circular(5)),
                      child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: common_main_gap),
                              child: Icon(Icons.search, color: yellowFFE000,),
                            ),

                            Expanded(
                              child: Text('검색어를 입력해주세요.', style: TextStyle(fontSize: 14, color: greyB2B2B2),),
                            ),
                            IconButton(onPressed: (){
                              setState(() {
                                print('false');
                              });

                            }, icon: SvgPicture.asset('assets/icons/ic_close.svg',))
                          ]
                      ),
                    ),
                  ),
                ),
              ],);}},),
    ));
  }


  void _onMarkerTap(Marker marker, Map<String, int> iconSize, MoojangaeModel moojangaeModel) async {
    logger.d("무장애 정보-> ${moojangaeModel.contentid}");
    int pos = _markers.indexWhere((m) => m.markerId == marker.markerId);

    Map<String, dynamic> resultMap = await Get.find<LocationInFoController>().getMoojangaeDetail(moojangaeModel.contentid.toString());
    resultMap.remove('contentid');
   /* setState(() {
      _markers[pos].captionText = '선택됨';
    });*/
    showCupertinoModalBottomSheet(
        expand: false,
        context: context, builder: (context) => Material(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(common_main_gap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("${moojangaeModel.title}", style: TextStyle(color: black333333, fontSize: 16, ),),
                  SizedBox(height: 5,),
                  Text("${moojangaeModel.addr1}", style: TextStyle(color: greyB2B2B2, fontSize: 16, ),),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: common_main_gap, right: common_main_gap, bottom: common_main_gap),
              child: Container(
                padding: const EdgeInsets.all(common_s_gap),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: greyCCCCCC)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children:
                  List.generate(resultMap.length, (index) =>
                    Text("·${resultMap.values.toList()[index]}", style: TextStyle(height: 1.5, fontSize: 16,),),
                )
                ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(common_main_gap,0,common_main_gap,common_main_gap, ),
              child: _networkImage(moojangaeModel.firstimage),
            ),
    ]
    ),
      )));
  }
  CachedNetworkImage _networkImage(String imgUrl) {
    return CachedNetworkImage(
      fit: BoxFit.fill,
      imageBuilder: (context, imageProvider) => Container(
        width: Get.width,
        height: Get.width*0.5,
        decoration: BoxDecoration(
         // borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
              image: imageProvider, fit: BoxFit.fill),
        ),),
      imageUrl: imgUrl,
      placeholder: (context, url) =>  Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) =>  SizedBox.shrink(),
    );
  }

}
