import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefController extends GetxController{
  SharedPreferences sharedprefs;

  @override
  void onInit() async {
    sharedprefs = await SharedPreferences.getInstance();
    super.onInit();
  }



  void setString(String key, String str){
    sharedprefs.setString(key, str);
  }
  void setStringArray(String key, List<String> value){
    sharedprefs.setStringList(key, value);
  }
  void setBooleanPref(String key, bool value){
    sharedprefs.setBool(key, value);
  }
  void setInt(String key, int value) async{
    sharedprefs.setInt(key, value);
  }
  void setDouble(String key, double value ){
    sharedprefs.setDouble(key, value);
  }


  String getString(String key){
    return sharedprefs.getString(key);
  }
  List<String> getStringArray(String key){
    return sharedprefs.getStringList(key);
  }
  bool getBooleanPref(String key){
    try{
    return sharedprefs.getBool(key) ?? false;}
    catch(e){return false;}
  }
  int getInt(String key){
    try{
    return sharedprefs.getInt(key) ?? 0;}
    catch(e){
      return 0;
    }
  }
  double getDouble(String key){
    return sharedprefs.getDouble(key);
  }

  void removekey(String key){
    sharedprefs.remove(key);
  }

  /// 모든 저장 데이터 삭제
  /// @param context
  void clearPref(){
    sharedprefs.clear();
  }

}