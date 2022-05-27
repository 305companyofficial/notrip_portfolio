
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/user.dart';
import 'package:notrip/constants/common_size.dart';

Widget KakaoLogin() {
  return Padding(
    padding: const EdgeInsets.all(common_gap),
    child: InkWell(
      onTap: () async{
        print("카카오톡 로그인");
        try {
          await UserApi.instance.loginWithKakaoTalk();
          // perform actions after login
          User user = await UserApi.instance.me();
          print("카카오톡 유저"+user.toString());
          registerKakaoId(user.id.toString());
        } catch (e) {
          print('error on login: $e');
        }
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue
        ),
        width: double.maxFinite,
        height: 40,
        child: Center(child: Text("카카오톡으로 로그인", style:  TextStyle(color: Colors.white,
            fontSize: 15),)),
      ),
    ),
  );
}

void registerKakaoId(String id) async{
  print("registerid");
  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: "$id@kakao.com",
        password: "kakao$id"
    );
    print("로그인!!");
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
      signInKakaoId(id);
    }
  } catch (e) {
    print(e);
  }
}
void signInKakaoId(String id) async{
  print("signInId");
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: "$id@kakao.com",
        password: "kakao$id"
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
}