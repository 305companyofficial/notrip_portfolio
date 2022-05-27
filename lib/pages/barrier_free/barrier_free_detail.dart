import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/logger.dart';
import 'package:notrip/constants/material_color.dart';
import 'package:notrip/controllers/location_info_controller.dart';
import 'package:notrip/models/moojangae_model.dart';

class BarrierFreeDetail extends StatefulWidget {
   BarrierFreeDetail(this._moojangaeModel, {Key key}) : super(key: key);
    MoojangaeModel _moojangaeModel;
  @override
  _BarrierFreeDetailState createState() => _BarrierFreeDetailState();
}

class _BarrierFreeDetailState extends State<BarrierFreeDetail> {


  Future<Map<String, dynamic>> _fetch1() async {
    Map<String, dynamic> resultMap={};
    resultMap = await Get.find<LocationInFoController>().getMoojangaeDetail(widget._moojangaeModel.contentid.toString());
    resultMap.remove('contentid');
    return resultMap;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("배리어프리장소"),
      ),
      body: FutureBuilder(
        future: _fetch1(),
           builder:  (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot){
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
            Map<String, dynamic> moojangaeInfo = snapshot.data;
            return  SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(common_main_gap),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("${widget._moojangaeModel.title}", style: TextStyle(color: black333333, fontSize: 16, ),),
                          SizedBox(height: 5,),
                          Text("${widget._moojangaeModel.addr1}", style: TextStyle(color: greyB2B2B2, fontSize: 16, ),),
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
                            List.generate(moojangaeInfo.length, (index) =>
                                Text("·${moojangaeInfo.values.toList()[index]}", style: TextStyle(height: 1.5, fontSize: 16,),),
                            )..addAll([
                              SizedBox(height: common_s_gap,),

                              // _networkImage(moojangaeModel.)
                            ])
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: common_main_gap),
                      child: _networkImage(widget._moojangaeModel.firstimage),
                    ),
                  ]
              ),
            );}},
      ),
    );
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
