import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/material_color.dart';
import 'package:notrip/pages/login/set_profile_page.dart';
import 'package:notrip/tools/enums.dart';
import 'package:notrip/tools/times.dart';
import 'package:notrip/wigets/show_toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class VerifyPhonePage extends StatefulWidget {
  const VerifyPhonePage({Key key}) : super(key: key);

  @override
  _VerifyPhonePageState createState() => _VerifyPhonePageState();
}

class _VerifyPhonePageState extends State<VerifyPhonePage> {
  //TextEditingController phoneInputController;
  var verificationState = VerificationState.READY;
  var randomNum=-1;

  var reSendTime = Duration(seconds: 61);
  var remainTime = Duration(seconds: 300);

  var phoneNumtext = "";
  var validateText = "";
  var remainTimeString = "";
  final smsdata = GetStorage();
  @override
  void initState() {
    super.initState();
    //phoneInputController= TextEditingController(text: "010");
  }
  @override
  void dispose() {
    //phoneInputController.dispose();
    verificationState = VerificationState.FINISH;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("전화번호 인증"),),
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: common_l_gap),
                child: Row(
                  children: [
                    Expanded(child: TextField(
                  inputFormatters: [
                    MaskedInputFormatter("000-0000-0000")
                  ]
                  ,
                enableInteractiveSelection: false,
                // controller: phoneInputController,
                decoration: InputDecoration(
                  counterText: "",
                contentPadding: const EdgeInsets.symmetric(horizontal: common_gap),
                focusColor: Colors.grey[100],
                hintStyle: TextStyle(color: greyBCBCBC),
                hintText: "휴대폰 번호를 입력해주세요.",
                border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5*screenSizeFactor),
                 ),
                filled: false,),
                        onChanged: (text){
                        setState(() {
                          phoneNumtext = text;
                        });
                        },
                        keyboardType: TextInputType.datetime,
                      maxLength: 15,
                   //   enabled: verificationState!= VerificationState.RUNNING,

                    )),

                  ],
                ),
              ),
              SizedBox(height: 10,),
              Visibility(
                  visible: verificationState== VerificationState.READY,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: common_l_gap),
                        child: InkWell(
                          onTap: (){
                          startValidate();
                          },
                          child: Container(

                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5*screenSizeFactor),
                                  color: validSendSMS()? color_ButtonActive:color_ButtonDisable
                              ),
                              width: double.maxFinite,
                              height: 40,
                              child: Center(child: Text("인증번호 발송", style:
                              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),))),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("전화번호가 변경되었나요?", style: TextStyle(color: greyC6C3C3),),
                          InkWell(
                            onTap: () async{
                              print("문의하기 클릭");
                              var _url = "tel: 051-611-5060";
                              await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                            },
                            child: Padding(
                                padding: const EdgeInsets.all(common_gap),
                                child: Text("문의하기", style: TextStyle(fontWeight: FontWeight.bold),)),
                          )
                        ],
                      ),
                    ],
                  )),
             Visibility(
                 visible: verificationState!=VerificationState.READY,
                 child: Column(
               children: [
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: common_l_gap),
                   child: InkWell(
                     onTap: () async{
                       //재발송시간 경과했는지 확인할 것
                       if (DateTime.now().difference(DateTime.parse(await smsdata.read('sendTime')))>= reSendTime)
                       startValidate();
                     },
                     child: Container(
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(5*screenSizeFactor),
                             color: grey333333
                         ),
                         width: double.maxFinite,
                         height: 40,
                         child: Center(child: Text("인증문자 재발송", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),))),
                   ),
                 ),
                  SizedBox(
                    height: 16*screenSizeFactor,
                  ),
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: common_l_gap),
                   child: Container(
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(5*screenSizeFactor),
                         border: Border.all(
                           width: 1,
                           color: greyECECEC,
                         ),
                           //color: grey333333
                       ),
                       width: double.maxFinite,

                       child: Center(
                         child: Padding(
                           padding: const EdgeInsets.all(common_main_gap),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Expanded(
                                 child: TextField(
                                   onChanged: (text){
                                     setState(() {
                                       validateText = text;
                                     });
                                   },
                                   keyboardType: TextInputType.datetime,
                                   maxLength: 5,
                                   decoration: new InputDecoration(
                                     border: InputBorder.none,
                                     isCollapsed: true,
                                       counterText: "",
                                       hintText: '인증번호를 입력해주세요',
                                     hintStyle: TextStyle(fontSize: 14, color: greyBCBCBC,)
                                   ),
                                 ),
                               ),
                               Text("$remainTimeString"),
                             ],
                           ),
                         ),
                       )),
                 ),
                 SizedBox(height: 16*screenSizeFactor,),
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: common_main_gap),
                   child: SizedBox(
                       width: double.maxFinite,
                       child: Text("어떤 경우에도 타인에게 공유하지 마세요!", style: TextStyle(color: greyC6C3C3,),)),
                 ),
                 SizedBox(height: 16*screenSizeFactor,),
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: common_main_gap),
                   child: InkWell(
                     onTap: (){
                       setState(() {
                         print("확인");
                         var answer = smsdata.read("validKey");
                         if(answer==null){
                           showToast("인증번호를 발송에 실패했습니다.");
                         }
                         if(validateText == answer) {
                           print("정답입니다.");
                           verificationState = VerificationState.FINISH;
                          // FirebaseAuth auth = FirebaseAuth.instance;
                           //registerId();
                           Get.to(SetProfilePage());
                         }else{
                           print("오답입니다..");
                           print("$answer != ${validateText}");
                         }


                       });
                     },
                     child: Container(

                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(5*screenSizeFactor),
                             color: validateText.length==5?  color_ButtonActive : color_ButtonDisable
                         ),
                         width: double.maxFinite,
                         height: 40,
                         child: Center(child: Text("인증번호 확인", style: TextStyle(color: Colors.white,
                             fontWeight: FontWeight.bold),))),
                   ),
                 ),

               ],
             )),



            ],
          ),
        ),
      ),
    );
  }
  void registerId() async{
    print("registerid");
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: "01028519936@phonenumber.com",
          password: "phonenumber01028519936"
      );
      print("로그인!!");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        signInId();
      }
    } catch (e) {
      print(e);
    }
  }
  void signInId() async{
    print("signInId");
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "01028519936@phonenumber.com",
          password: "phonenumber01028519936"
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
  bool validSendSMS(){
   var value =  phoneNumtext.length == 13 ? true : false;
   return value;
  }
  void sendSms() async{
    int keynum= Random().nextInt(89998) + 10000;
    var uuid = Uuid();
    print("sendSMS1");
    var resourceUrl = "https://api.coolsms.co.kr/messages/v4/send";
    //var resourceUrl = "https://api.coolsms.co.kr/sms/2/send";
    //key: 'your API key',
    //secret: 'your API secret key'
    var apiKey ="NCSV6AEPV9F4I0G9";
    var apiSecret= "3VNGC5DV5Z9V32EKOKKBADCFBGUVFJF4";
    var signature = "c593d8cf6706473d16c04a753b5795431c636e5c682e09e47d197c1632097e3a";
    var mykey = utf8.encode(apiSecret);
    var salt = uuid.v4().replaceAll("-", "");
    var dateTimestamp = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    var bytes = utf8.encode(dateTimestamp+salt); // data being hashed
    var hmacShr256 = Hmac(sha256, mykey);
    var digest = hmacShr256.convert(bytes);
    //var hmac = new Hmac(sha256, salt+dateTimestamp);
    print(dateTimestamp);
    var signature2= digest.toString();
    print("signature2 : $signature2");

    var headerAuthorization="HMAC-SHA256 ApiKey=$apiKey, Date=$dateTimestamp, salt=$salt, signature=$signature2";
    print("headerAuthorization : $headerAuthorization");
    Map params = {};

    params["to"] = "01028519936";
    params["from"] = "0516115060";
    params["type"] = "SMS";
    params["text"] = "[9988GO] 회원 인증을 위해서 [$keynum]를 입력해주세요";

    Response response;
    var dio = Dio();
    dio.options.headers["Authorization"] = headerAuthorization;
    //var header= {"apiKey": apiKey, "apiSecret" : apiSecret };
    //dio.options.headers
    print("params1: ${params.toString()}");
    print("params2: ${json.encode(params).toString()}");

    try {
      response = await dio.post(resourceUrl, data: {"message": params},);
      print("response.statusCode : ${response.statusMessage}");
      print("response.statusCode : ${response.statusCode}");
      print("response.statusCode : ${response.data.toString()}");
      await smsdata.write('validKey', keynum.toString());

    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.requestOptions.toString());
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions.toString());
        print(e.message);
      }
    }


   /* if(response.statusCode==200||response.statusCode==201){
      print("response.data : ${response.data.toString()}");
    }*/

  }


  Future<void> timerStart() async {
    await smsdata.write('sendTime', DateTime.now().toString());

    while (verificationState == VerificationState.RUNNING) {
      var timeDiffrence = (DateTime.parse(await smsdata.read('sendTime'))).add(remainTime).difference(DateTime.now());
      if (timeDiffrence<Duration(seconds: 0)){timeDiffrence=Duration(seconds: 0);}
      print("timeDiffrence: $timeDiffrence $verificationState");
      await Future.delayed(Duration(seconds: 1));

      setState(() {
        remainTimeString = printDuration(timeDiffrence);
      });
      if (timeDiffrence < Duration(seconds: 1)) {
        verificationState = VerificationState.FINISH;
      }
    }
  }
  void startValidate(){
    setState(() {
      if(validSendSMS()){
        Get.to(SetProfilePage()); return;
        verificationState=VerificationState.RUNNING;
        timerStart();
        sendSms();
      }
    });
  }
}
