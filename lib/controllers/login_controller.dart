import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notrip/models/user_model.dart';
import 'package:notrip/pages/login/auth_screen.dart';
import 'package:notrip/pages/community/detail_community_page.dart';
import 'package:notrip/pages/main_page.dart';
import 'package:notrip/tools/enums.dart';

class LoginController extends GetxController {
  final Rx<UserModel> _userModel = Rx<UserModel>(null);
  AuthStatus _authStatus = AuthStatus.SIGNOUT;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool  isloading = false;
  User _firebaseUser;
  SignInMethodFlag _signInMethodFlag = SignInMethodFlag.google;
  UserModel get userModel => _userModel.value;
  set userModel(UserModel userModel) => this._userModel.value = userModel;
  @override
  void onInit() {
    super.onInit();
    watchAuthchange();
  }

  userModelClear(){
   _userModel.value = null;
   update();
  }
  void signOut(){
    changeAuthStatus(AuthStatus.PROCESSING);
    try{GoogleSignIn().signOut();}catch(e){print(e);}
    _authStatus = AuthStatus.SIGNOUT;
    if(_firebaseUser!=null){
      print('sign out!');
      _firebaseUser =null;
      _firebaseAuth.signOut();}
    if(_userModel!=null){userModelClear();}
    update();
  }
  void changeIsloading(bool value){
    isloading = value;
    update();
    //update([isloading]);
  }

  void changeAuthStatus([AuthStatus authStatus]) async{
    if(authStatus != null) {
      _authStatus = authStatus;
    } else{
      if(_firebaseUser != null){
        if (_firebaseUser.uid!=null){
          changeIsloading(false);
          Get.offAll(
              MainPage()
          );
         /* print('uid-> ${_firebaseUser.uid}');
          await userNetworkRepository.attemptCreateOrUpdateUser(userUID: _firebaseUser.uid, email: _firebaseUser.email,);
          print('process1');
          _userModel.value = await userNetworkRepository.getUserModel(_firebaseUser.uid);

          print(_userModel.value.toString());
          print('process2');
          changeIsloading(false);
          if (_userModel.value.usertype == MEMBER ) {print("처리된 회원");
          _authStatus = AuthStatus.SIGNIN;
          _userModel.bindStream(userNetworkRepository.getUserModelStream(_firebaseUser.uid));
          }else{print("처리 되지 않은 회원");Get.to(InitialUserSettings());}*/
        }
      }else{
        _authStatus = AuthStatus.SIGNOUT;
        Get.offAll(
            MainPage()
           // AuthScreen()
    );
      }
    }
    print('Authstate -> $_authStatus');
    update();
  }
  void watchAuthchange(){
    print('watchAuthchange');
    _firebaseAuth.authStateChanges().listen((firebaseuser) {
      print('watchAuthchangelistener');
      if(firebaseuser == null){changeAuthStatus();
      }
      if(firebaseuser!= _firebaseUser){
        _firebaseUser = firebaseuser;
        changeAuthStatus();
      }
    });

  }



  AuthStatus get authState => _authStatus;
  User get firebaseUser => _firebaseUser;


}
