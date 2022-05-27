import 'package:kakao_flutter_sdk/link.dart';
import 'package:notrip/wigets/show_toast.dart';

class KakaoShareManager {

  static final KakaoShareManager _manager = KakaoShareManager._internal();

  factory KakaoShareManager() {
    return _manager;
  }

  KakaoShareManager._internal() {
    // 초기화 코드
  }
/*
  void initializeKakaoSDK() {
    String kakaoAppKey = "49db......";
    KakaoContext.clientId = kakaoAppKey;
  }*/

  Future<bool> isKakaotalkInstalled() async {
    bool installed = await isKakaoTalkInstalled();
    return installed;
  }

  Future shareMyCode(String txt, String linkurl) async {
    try {
      if (await isKakaotalkInstalled() == false) {
        showToast('카카오톡 설치를 확인해주세요');
        return;
      }
      var template = _getTemplate(txt, linkurl);
      var uri = await LinkClient.instance.defaultWithTalk(template);
      await LinkClient.instance.launchKakaoTalk(uri);
    }catch(e){showToast('카카오톡 설치 후\n개발자에게 문의해주세요.');}
  }

  TextTemplate _getTemplate(String txt ,  String linkurl) {
    TextTemplate template = TextTemplate(
        txt,  Link(
        webUrl: Uri.parse("http://www.naver.com"),
        mobileWebUrl: Uri.parse(linkurl)
    ),
        buttonTitle:'버튼!',
        //social: Social(likeCount: 286, commentCount: 45, sharedCount: 845),
        buttons: [
         /* Button("웹으로 보기",
              Link(webUrl: Uri.parse("http://www.naver.com"))),*/
          Button("구구팔팔고 다운로드",
              Link(webUrl: Uri.parse("http://www.naver.com"),
                  mobileWebUrl: Uri.parse(linkurl),
              )),
        ]
    );
    return template;
  }
}