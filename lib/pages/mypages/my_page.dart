import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/material_color.dart';
import 'package:notrip/constants/string_address.dart';
import 'package:notrip/controllers/login_controller.dart';
import 'package:notrip/pages/login/auth_screen.dart';
import 'package:notrip/pages/mypages/faq_page.dart';
import 'package:notrip/pages/mypages/my_account_infomation.dart';
import 'package:notrip/pages/mypages/notice_list_page.dart';
import 'package:notrip/pages/mypages/personal_inquire_page.dart';
import 'package:notrip/pages/mypages/setting_family.dart';
import 'package:notrip/pages/mypages/settings_page.dart';
import 'package:notrip/tools/kakao_tools.dart';
import 'package:notrip/wigets/pop_ups.dart';
import 'package:notrip/wigets/round_wigets.dart';
import 'package:url_launcher/url_launcher.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  static const SMS = "sms:?body=구구팔팔고를 써보세요~"; //IOS는 sms 보내는 URL 다르다고 하니 참고
  //https://stackoverflow.com/questions/54301938/how-to-send-sms-with-url-launcher-package-with-flutter
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appbarBackgroundColor,
        title: Text("마이페이지"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            print('click setting');
            Get.to(SettingsPage());
          }, icon: Icon(Icons.settings))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(common_llll_gap),
              child: Column(
                children: [
                  InkWell(
                    child:  Stack(
                      children: [
                        networkCircleImg(imgurl: testImgurl,
                            imgsize: iconsize_profile, replaceicon: Icons.person),
                        SizedBox(
                          width: iconsize_profile,
                          height: iconsize_profile,
                          child: Align(
                              alignment: Alignment.bottomRight,
                              child: Icon(CupertinoIcons.pencil_circle_fill)),
                        )
                      ],
                    ),
                  ),
                SizedBox(height: common_gap,),
                Text("홍길동", style: TextStyle(fontWeight: FontWeight.bold),)
                ],
              ),
            ),
            Divider(
              thickness: 7,
              height: 7,
            ),
            MypageOption((){print("내 계정 정보");
            Get.to(MyAccountInfomation());
            }, txt: '내 계정 정보'),
            Divider(thickness: 1, height: 1,),
            MypageOption((){print("연결된 가족 계정");
            Get.to(SettingFamily());
            }, txt: '연결된 가족 계정' ),
            Divider(thickness: 1, height: 1,),
            MypageOption((){print("공지사항");
            Get.to(NoticeListPage());
            }, txt: '공지사항' ),
            Divider(thickness: 1, height: 1,),
            MypageOption((){print("자주 묻는 질문");
            Get.to(FaqPage());
            }, txt: '자주 묻는 질문' ),
            Divider(thickness: 1, height: 1,),
            MypageOption((){print("1:1문의하기");
            Get.to(PersonalInquirePage());
            }, txt: '1:1문의하기' ),
            Divider(thickness: 7, height: 7,),
            MypageOption(() async{print("어플리케이션 정보공유");
            await shareApplication(context);

            }, txt: '어플리케이션 정보공유'),
            Divider(thickness: 1, height: 1,),
            MypageOption((){print("로그아웃");
            Get.find<LoginController>().signOut();
            Get.offAll(() => AuthScreen());
            }, txt: '로그아웃' ),
            Divider(thickness: 1, height: 1,),
            MypageOption((){print("탈퇴하기");
            secessionEnroll();
            }, txt: '탈퇴하기' ),
            Divider(
              thickness: 7,
              height: 7,
            ),
          ],
        ),
      ),
    );
  }

  shareApplication(BuildContext context) async {
    showCupertinoModalBottomSheet(
            expand: false,
            context: context, builder: (context) => Material(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(common_main_gap),
                  child: Text("어플리케이션 공유", style: TextStyle(color: greyB2B2B2, fontSize: 14, ),),
                ),
                Column(
                 mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(2, (index) =>
                  InkWell(
                  onTap: ()async{
                  print("안녕하세요$index");
                  if(index==0) {
                  print("카카오톡");
                  KakaoShareManager kakaoShareManager= KakaoShareManager();
                        await kakaoShareManager.shareMyCode('구구팔팔고\n', "www.naver.com"
                        );
                      }else if(index==1){
                        print("메시지");
                        if(await canLaunch(SMS)){
                          //IOS는 sms 보내는 URL 다르다고 하니 참고
                          //https://stackoverflow.com/questions/54301938/how-to-send-sms-with-url-launcher-package-with-flutter
                          await launch(SMS);
                        }else{
                          throw 'error sms';
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(common_main_gap),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          index ==0? Padding(
                            padding: const EdgeInsets.only(right: common_s_gap),
                            child: SvgPicture.asset('assets/icons/ic_kakao_rect.svg',),
                          ) : SizedBox.shrink(),
                          Text(index ==0?  "카카오톡으로 공유하기" : "문자(sms)로 공유하기",
                          style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )),
                ),
               //SizedBox(height: 30,),
               InkWell(
                 onTap: (){
                   Get.back();
                 },
                 child: Padding(
                   padding: const EdgeInsets.all(common_main_gap),
                   child: SizedBox(
                       width: double.maxFinite,
                       child: Text("취소하기", style: TextStyle(color: greyCCCCCC, fontWeight: FontWeight.bold),)),
                 ),
               ),
                SizedBox(height: 10,),
              ],
            ),
          ));
  }

  InkWell MypageOption(var todo, {String txt="", }) {
    return InkWell(
            onTap: todo,
            child:
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(common_gap),
                  child: Text(txt, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),),
                ),
              ],
            ),
          );
  }
}
