import 'package:notrip/constants/server_keys.dart';

class UserModel {
  String logintype="";
  String nickname="";
  String groupname= '';
  List<dynamic> mytable=[];
  List<dynamic> followtable=[];
  String uid="";
  String description="";
  String userimg="";
  String locationcode = '';
  String userpointdate = '';
  double userpoint = 0.0;
  String usertype="";  //master, manager, memeber

  UserModel.fromMap(Map<String, dynamic> map , this.uid, )
      :
        logintype = map[KEY_LOGINTYPE],
        nickname = map[KEY_NICKNAME],
        description = map[KEY_DESCRIPTION],
        mytable = map[KEY_MYTABLE]??[],
        followtable = map[KEY_FOLLOWTABLE],
        userimg = map[KEY_USERIMG]??'',
        locationcode = map[KEY_LOCATIONCODE]??'',
        groupname = map[KEY_GROUPNAME],
        userpointdate = map[KEY_USERPOINTDATE]??'',
        userpoint = (map[KEY_USERPOINT]??0.0)+.0,
        usertype= map[KEY_USERTYPE] ?? ""; //master, manager, memeber

  UserModel();






  @override
  String toString() {
    return 'UserModel{logintype: $logintype, '
        'followtable: $followtable, uid: $uid, '
        'userimg: $userimg, usertype: $usertype, ';
  }
}