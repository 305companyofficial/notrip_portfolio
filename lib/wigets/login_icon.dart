import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notrip/constants/screen_size.dart';

class LoginIcon extends StatelessWidget {

  String imageAddress;
  double iconsize;
  LoginIcon( this.imageAddress , this.iconsize, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all( screensize.width*0.03),
      child: Material(
        elevation: 10.0,
        shape: CircleBorder(),
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: Ink.image(
          image: AssetImage(imageAddress),
          fit: BoxFit.cover,
          width: iconsize, height: iconsize,
          child: InkWell(
            splashColor: Colors.black26,
            onTap: () async {
              print('!!');
              try {
            //카카오톡 로그인은 신규버전 방법으로 새로 구현해야 함
            /*    //String authCode = await AuthCodeClient.instance.request(); // via browser
                // String authCode = await AuthCodeClient.instance.requestWithTalk() // or with KakaoTalk
                String authCode='';

                  final installed = await isKakaoTalkInstalled();
                  authCode = installed ? await AuthCodeClient.instance.requestWithTalk() : await AuthCodeClient.instance.request();

                print('시이발코드'+authCode);
                AccessTokenResponse token = await AuthApi.instance.issueAccessToken(authCode);
                AuthCodeClient.instance.toStore(token); // Store access token in AccessTokenStore for future API requests.
                print('토근이 나가신다. '+token.toString());
                print('토근이 나가신다2. '+token.toJson().toString());
                print('참거짓'+(token.refreshToken == null).toString()+'투루면 없는거임');

                //dialog 생성!
                showprogressdialog(context, '로그인 중입니다.');
                var user = await UserApi.instance.me();
                print(user.id);
                if(user.id<=0){showToast('로그인이 올바르지 않습니다.');}
                print(user.toString());
                print('sl akaaeofhgofk');
                await trykakaologin(user.id.toString());
                Get.back();
*/


              } catch (e) {
                print(e);
                // some error happened during the course of user login... deal with it.
              }
          /*    Provider.of<FirebaseAuthState>(context, listen: false)
                  .changeFireabseAuthStatus(FirebaseAuthStatus.SignIn);*/
            },
          ),
        ),
      ),
    );
  }

  Future trykakaologin(String userid) async {
     try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "${userid}@kakao.com",
          password: userid.toString()
      );
      print(userCredential.user.uid +'uid!!');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        try {
          UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: "${userid}@kakao.com",
              password: userid.toString()
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            print('The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            print('The account already exists for that email.');
          }
        } catch (e) {
          print(e);
        }


      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}
