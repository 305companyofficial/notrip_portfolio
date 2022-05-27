import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/material_color.dart';
import 'package:notrip/constants/screen_size.dart';
import 'package:notrip/controllers/login_controller.dart';
import 'package:notrip/pages/main_page.dart';
import 'package:notrip/pages/login/verify_phone_page.dart';
import 'package:notrip/tools/enums.dart';
import 'package:notrip/wigets/kakao_login.dart';
import 'package:notrip/wigets/login_icon.dart';
import 'package:notrip/wigets/pop_ups.dart';
import 'package:notrip/wigets/round_wigets.dart';
import 'package:notrip/wigets/show_toast.dart';


class AuthScreen extends StatelessWidget {
  BuildContext _thiscontext;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    _thiscontext = context;
    if (screensize == null) screensize = MediaQuery.of(context).size;  //기계사이즈
    var iconsize = min(screensize.width*0.2, screensize.height*0.2);
    return
      Scaffold(
          body:  GetBuilder<LoginController>(builder:
          (logincontroller){
            return WillPopScope(
              onWillPop: _onBackPressed,
              child: Stack(
                children: [
                  Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Spacer(flex: 8,),
                        Text("구구팔팔GO", style: TextStyle(fontSize: 32*screenSizeFactor,  fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        Text('우리 오래오래 함께 여행다녀요.\n지금 바로 시작하세요!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20*screenSizeFactor, color: Colors.grey[900])
                        ),
                        Spacer(flex: 8,),
                  /*      Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Visibility(
                                visible: true,
                                child: Padding(
                                  padding: EdgeInsets.all( screensize.width*0.03),
                                  child:  Material(
                                    elevation: 10.0,
                                    shape: CircleBorder(),
                                    clipBehavior: Clip.hardEdge,
                                    color: Colors.white,
                                    child: Ink.image(
                                      image:
                                      AssetImage('assets/images/icon_google.png'),
                                      fit: BoxFit.cover,
                                      width: iconsize, height: iconsize,
                                      child: InkWell(
                                        splashColor: Colors.black26,
                                        onTap: () {
                                          if(logincontroller.authState == AuthStatus.SIGNOUT){
                                            _signInWithGoogle(context);}else{showToast("로그아웃 상태가 아닙니다.");}

                                          if(logincontroller.authState == AuthStatus.SIGNOUT){
                                          _signInWithGoogle(context);}else{showToast("로그아웃 상태가 아닙니다.");}
                                        },
                                      ),
                                    ),
                                  ) ,
                                ),
                              ),

*//*
                              Visibility(
                                visible: Platform.isIOS,
                                child: Padding(
                                  padding: EdgeInsets.all(  screensize.height*0.03),
                                  child:  Material(
                                    elevation: 10.0,
                                    shape: CircleBorder(),
                                    clipBehavior: Clip.hardEdge,
                                    color: Colors.white,
                                    child: Ink.image(
                                      image:
                                      AssetImage('assets/images/icon_apple.png'),
                                      fit: BoxFit.cover,
                                      width: iconsize, height: iconsize,
                                      child: InkWell(
                                        splashColor: Colors.black26,
                                        onTap: () {
                                         // Get.off(MainPage());
                                          //   _signInWithApple(context);
                                        },
                                      ),
                                    ),
                                  ) ,
                                ),
                              ),*//*




                           *//*   Visibility(
                                visible: true,
                                child: Padding(
                                  padding: EdgeInsets.all( screensize.width*0.03),
                                  child: Material(
                                    elevation: 10.0,
                                    shape: CircleBorder(),
                                    clipBehavior: Clip.hardEdge,
                                    color: Colors.transparent,
                                    child: Ink.image(
                                      image: AssetImage('assets/images/icon_naver.png'),
                                      fit: BoxFit.cover,
                                      width: iconsize, height: iconsize,
                                      child: InkWell(
                                        splashColor: Colors.black26,
                                        onTap: () {
                                          showToast('It can be available after published');
                                          print('네이버 로그인');
                                         // Get.off(MainPage());
                                          // Get.find<LoginController>().
                                          // Provider.of<FirebaseAuthState>(context, listen: false).changeFirebaseAuthStatus(FirebaseAuthStatus.SignIn);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),*//*

                          *//*    LoginIcon('assets/images/icon_kakao.png', iconsize),
*//*
                            ]
                        ),*/
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: common_lll_gap, horizontal: common_gap),
                          child: InkWell(
                            onTap: (){
                              print("전화번호로 로그인");
                              Get.to(VerifyPhonePage());
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: grey868181
                              ),
                              width: double.maxFinite,
                              height: 40,
                              child: Center(child: Text("로그인", style:  TextStyle(color: Colors.white,
                                  fontSize: 15),)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: logincontroller.isloading,
                    child: Stack(
                      children: [

                        Container(
                          width: double.infinity,
                          height:  double.infinity,
                          color: Colors.black87.withOpacity(0.7),
                        ),
                        Center(child: SizedBox(
                          width: 50, height: 50,
                          child: CircularProgressIndicator(
                            strokeWidth: 8,
                            color: Colors.white,
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          )
      );
  }



  Future<bool> _onBackPressed() {
    return exitApp(_thiscontext);
  }

  Future<User> _signInWithGoogle(dynamic context) async {
    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    Get.find<LoginController>().changeAuthStatus(AuthStatus.PROCESSING);
    Get.find<LoginController>().changeIsloading(true);
    User user = (await _auth.signInWithCredential(
        GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken)
    )).user;

    print("sign in "+ user.displayName +"\nuid:"+ user.uid);
    return user;
  }



}

