import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notrip/constants/logger.dart';
import 'package:notrip/models/moojangae_model.dart';
import 'package:notrip/models/weather_model.dart';
import 'package:notrip/wigets/show_toast.dart';
import 'package:xml2json/xml2json.dart';

class LocationInFoController extends GetxController{
  var dio = Dio();
  Position position;
  final moojangaeKey = "upl%2BT0fXnEqRHICYWywPQcEWci9EtY6l7C1yiie5l%2FBbiG1pTe0DlpV6T2APP8cIMMlGDkc33nMSJ6aC8XW48g%3D%3D";

  @override
  void onInit() {
    super.onInit();
  }

  Future<String> getCovidStart(String resion) async {
   var lastdayDateTime = DateTime.now().subtract(Duration(days: 1));
   var todayDateTime = DateTime.now();
   var lastdayLetter = DateFormat("yyyyMMdd").format(lastdayDateTime);
   var todayLetter = DateFormat("yyyyMMdd").format(todayDateTime);
   var serviceKey ="=upl%2BT0fXnEqRHICYWywPQcEWci9EtY6l7C1yiie5l%2FBbiG1pTe0DlpV6T2APP8cIMMlGDkc33nMSJ6aC8XW48g%3D%3D";
    print('lastdayLetter : $lastdayLetter');
   print('todayLetter : $todayLetter');
    dio = Dio();
    print("covid start");
    print(resion);
    var response = await dio.get(
      'http://openapi.data.go.kr/openapi/service/rest/Covid19/getCovid19SidoInfStateJson?serviceKey$serviceKey&pageNo=1&numOfRows=300&startCreateDt=$lastdayLetter&endCreateDt=$todayLetter',
    options: Options(
      receiveTimeout: 3000,
      sendTimeout: 3000
    )
    );
    print("Covid 결과는" + response.statusCode.toString());
    if (response.statusCode == 200) {
      print("Covid 결과는1" +response.data.toString());
      Xml2Json xml2json = new Xml2Json();
      xml2json.parse(response.data);
      var jsondata = xml2json.toGData();
      var data = jsonDecode(jsondata);
     // var data =response.data;
      print("Covid 결과는3" +data.toString());
      print("Covid 결과는4" +data["response"]["body"].toString());
      List items = data["response"]["body"]["items"]["item"];
      print("covid 결과는 6 $resion"+ items.toString());
        if (items.length>0){
          print("1");
          var item = items.where((element) => element["gubun"]["\$t"]==resion).first;
          var createDt = item["createDt"]["\$t"]; //등록일시분초
          var gubun = item["gubun"]["\$t"];   //구분(시도명 한글
          var defCnt = item["defCnt"]["\$t"]; //확진자 수
          var incDec = item["incDec"]["\$t"]; //전일대비 증감수
          var deathCnt = item["deathCnt"]["\$t"]; //사망자
          print("createDt $createDt");
          print("deathCnt $deathCnt");
          print("defCnt $defCnt");
          print("gubun $gubun");
          print("incDec $incDec");
          return deathCnt.toString();
        }
    }
  }
  Future<Position> getPosition() async{
   if(position==null){position =   await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);}
   return position;
  }
  Future<WeatherModel> getWeatherStart() async{
    WeatherModel result;
    print("weather");
    position =   await getPosition();
    dio = Dio();
    var servicekey = "9209a9a8bfbd59274a12728b06b6269a";
    print(position.latitude);print(position.longitude);
    var response = await dio.get(
      'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$servicekey',
    );
    print("Weather 결과는" + response.statusCode.toString());
    print("Weather 결과는" + response.data.toString());
    result= WeatherModel.fromJson(response.data) ;
    return result;
  }

  Future<Map<String, dynamic>> getAddress() async{
    Map<String, dynamic> resultMap = {};
    logger.d("주소 찾기");
    position = await getPosition();
    dio = Dio();
    dio.options.headers['X-NCP-APIGW-API-KEY-ID'] = 'zu9a159v6z';
    dio.options.headers['X-NCP-APIGW-API-KEY'] = '9oVuvI0MpHaCk0DvQfujklBzj7gWwurhtAceJbJ7';
    print("position.latitude : ${position.latitude}\n position.longitude: ${position.longitude}");
    var response = await dio.get(
      'https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc',
        queryParameters: {
          "coords": "${position.longitude},${position.latitude}",
          "output" :"json",
          //"orders":"roadaddr" -> 이거 키면 데이터가 안나옴
        }
    );
    print("Address 결과는" + response.statusCode.toString());
    print("Address 결과는" + response.data.toString());

    if (response.statusCode == 200) {
      print("Address 결과는2" + response.statusCode.toString());

      resultMap['region'] = response.data["results"][0]['region']["area1"]["alias"];
      resultMap['address'] = "${response.data["results"][0]['region']["area1"]["name"]} ${response.data["results"][0]['region']["area2"]["name"]}";
      logger.d("resultMap.toString() :${resultMap.toString()}");
    }
    return resultMap;
  }
    Future<List<MoojangaeModel>> getMoojangae(Position position) async{
    var requesturl = 'http://api.visitkorea.or.kr/openapi/service/rest/KorWithService/locationBasedList?serviceKey=$moojangaeKey&numOfRows=100&pageNo=1&MobileOS=ETC&MobileApp=AppTest&listYN=Y&arrange=A&contentTypeId=14&mapX=${position.longitude}&mapY=${position.latitude}&radius=20000&_type=json';
    print("requesturl : $requesturl");
    List<MoojangaeModel> returnvalue = [];
    var response = await dio.get(requesturl);
      print("무장애 결과는" + response.statusCode.toString());
      print("무장애 결과는" + response.data.toString());
      if (response.statusCode == 200) {
        logger.d("무장애 리스트 가져오기 성공 ");
        List<MoojangaeModel> moojangaeInfoList=[];
        moojangaeInfoList.addAll(List.generate(response.data["response"]["body"]["items"]["item"].length, (index) => MoojangaeModel.fromJson(response.data["response"]["body"]["items"]["item"][index])));
        moojangaeInfoList.forEach((element) {print("무장애->${element.toString()}");});
        returnvalue.addAll(moojangaeInfoList);
      }
      logger.d("return getMoojangae ${returnvalue.length}");
      return returnvalue;
    }

    Future<Map<String, dynamic>> getMoojangaeDetail(String id) async{
      Map<String, dynamic> resultItem={};
      var requesturl = 'http://api.visitkorea.or.kr/openapi/service/rest/KorWithService/detailWithTour'
          '?serviceKey=$moojangaeKey'
         '&numOfRows=10&pageNo=1&MobileOS=ETC&MobileApp=봄&contentId=$id&_type=json';
      var response = await dio.get(requesturl,);
      print("무장애 결과는" + response.statusCode.toString());
      print("무장애 결과는" + response.data.toString());
      if (response.statusCode == 200) {
        logger.d("무장애 리스트 가져오기 성공 ");
        resultItem = response.data["response"]["body"]["items"]["item"];
        logger.d(resultItem.toString());
      }
      return resultItem;
    }

  Future<List<MoojangaeModel>> searchMoojangaeWithKeyword(String keyword) async{
    List<MoojangaeModel> returnvalue = [];
    logger.d("$keyword 검색");
    var requestUrl = 'http://api.visitkorea.or.kr/openapi/service/rest/KorWithService/searchKeyword'
        '?serviceKey=$moojangaeKey'
        '&numOfRows=1000&pageNo=1&MobileOS=ETC&MobileApp=봄&listYN=Y&arrange=A&contentTypeId=14&keyword=$keyword&totalCnt=3&_type=json';
    var response = await dio.get(requestUrl,);
    print("무장애 결과는" + response.statusCode.toString());
    print("무장애 결과는" + response.data.toString());
    if (response.statusCode == 200) {
      logger.d("무장애 리스트 가져오기 성공 ");
      List<MoojangaeModel> moojangaeInfoList=[];
      moojangaeInfoList.addAll(List.generate(response.data["response"]["body"]["items"]["item"].length, (index) => MoojangaeModel.fromJson(response.data["response"]["body"]["items"]["item"][index])));
      moojangaeInfoList.forEach((element) {print("무장애->${element.toString()}");});
      returnvalue.addAll(moojangaeInfoList);
    }
    return returnvalue;
  }
}