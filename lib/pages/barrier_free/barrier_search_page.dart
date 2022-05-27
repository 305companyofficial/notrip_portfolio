import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/logger.dart';
import 'package:notrip/constants/material_color.dart';
import 'package:notrip/controllers/location_info_controller.dart';
import 'package:notrip/models/moojangae_model.dart';
import 'package:notrip/pages/barrier_free/barrier_free_detail.dart';
import 'package:notrip/tools/enums.dart';

class BarrierSearchPage extends StatefulWidget {
  const BarrierSearchPage({Key key}) : super(key: key);

  @override
  _BarrierSearchPageState createState() => _BarrierSearchPageState();
}

class _BarrierSearchPageState extends State<BarrierSearchPage> {
  SearchMode _searchMode = SearchMode.INPUT;
  final data = GetStorage();
  List<dynamic> searchHistory =[];
  Future<List<MoojangaeModel>> _locations;
  TextEditingController searchTextController;
  @override
  Future<void> initState() {
    super.initState();
    loadSearchHistory();
    searchTextController = TextEditingController();
  }
  void loadSearchHistory() async{
   setState(()  {
     searchHistory.addAll( (data.read("searchHistory") as List<dynamic>)??[]);
   });
  }
  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text( _searchMode == SearchMode.INPUT ? "검색": "배리어프리 시설찾기"),),
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.fromLTRB(common_main_gap,common_main_gap,common_main_gap,0),
        child: Column(
         children: [
            searchBar(),

            Visibility(
              visible: _searchMode == SearchMode.INPUT,
              child: Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Visibility(
                     visible: searchHistory.length!=0,
                     child: Row(
                       children: [
                         Text("최근검색어", style: TextStyle(fontSize: 14, color: greyB2B2B2)),
                         Spacer(),
                         TextButton(
                             onPressed: (){
                               data.remove("searchHistory");
                               setState(() {
                                 searchHistory.clear();
                               });
                             },
                             child: Text("전체삭제")),
                       ],
                     ),
           ),
         Expanded(
           child: ListView(
             children: List.generate(searchHistory.length, (index) =>
                 InkWell(
                   onTap: (){logger.d("history clicked- $index");
                   _onSeachSubmit(searchHistory[index]);
                   },
                   child: Row(
                     children: [
                       Text(searchHistory[index], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: black333333,),),
                       Spacer(),
                       IconButton(onPressed: (){
                         setState(() {
                           searchHistory.removeAt(index);
                         });
                         data.write("searchHistory", searchHistory);
                       }, icon: SvgPicture.asset('assets/icons/ic_close.svg',))
                     ],
                   ),
                 )),
           ),
         ),
                  ],
                ),
              ),
            ),
           Visibility(
               visible: _searchMode == SearchMode.SEARCHING,
               child: Expanded(
                 child:
                 FutureBuilder(
                   future: _locations,
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
                       List<MoojangaeModel> moojangaeList = snapshot.data;
                       return  ListView(
                         padding: EdgeInsets.symmetric(vertical: common_gap),
                         children: List.generate(moojangaeList.length, (index) =>
                             InkWell(
                               onTap: (){
                                logger.d("${moojangaeList[index].title}의 상세정보");
                                Get.to(BarrierFreeDetail(moojangaeList[index]));
                               },
                               child: Column(
                                 children: [
                                   Container(
                                     padding: EdgeInsets.all(common_gap),
                                     width: double.maxFinite,
                                     decoration: BoxDecoration(
                                         border: Border.all(color: greyECECEC),
                                         borderRadius: BorderRadius.circular(5)
                                     ),
                                     child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.stretch,
                                       children: [
                                         Text(moojangaeList[index].title), SizedBox(height: common_ss_gap,),
                                         Text(moojangaeList[index].addr1, style: TextStyle(color: greyB2B2B2), ),
                                       ],
                                     ),
                                   ),
                                   SizedBox(height: 5,)
                                 ],
                               ),
                             )
                         ),
                       );}},),
               ))
         ]
        ),
      ),
    );
  }

  Container searchBar() {
    return Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5),
            border: Border.all(color: greyECECEC)
            ),
            child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: common_main_gap),
                    child: Icon(Icons.search, color: yellowFFE000,),
                  ),

                  Expanded(
                    child: TextField(
                      controller: searchTextController,
                      onSubmitted: _onSeachSubmit,
                      decoration: InputDecoration.collapsed(
                      hintText: '검색어를 입력해주세요.',
                      hintStyle: TextStyle(fontSize: 14, color: greyB2B2B2, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  IconButton(onPressed: (){
                    setState(() {
                      print('clear text');
                      searchTextController.text="";
                    });

                  }, icon: SvgPicture.asset('assets/icons/ic_close.svg',))
                ]
            ),
          );
  }
  void _onSeachSubmit(text) async{
      logger.d('검색 실행 $text');
      searchHistory.removeWhere((element) => element== text);
      setState(() {
        searchHistory.insert(0, text);
      });
      data.write("searchHistory", searchHistory);

      setState(() {
        _searchMode = SearchMode.SEARCHING;
      });
      _locations =  _fetch2(text);
    }
  Future<List<MoojangaeModel>> _fetch2(String text) async {
    List<MoojangaeModel> moojangaeList =  await Get.find<LocationInFoController>().searchMoojangaeWithKeyword(text);
    return moojangaeList;
  }

}
