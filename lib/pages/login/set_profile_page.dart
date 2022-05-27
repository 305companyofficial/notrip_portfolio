import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/material_color.dart';
import 'package:notrip/constants/string_address.dart';
import 'package:notrip/pages/login/enroll_family_page.dart';
import 'package:notrip/wigets/pop_ups.dart';
import 'package:notrip/wigets/round_wigets.dart';

class SetProfilePage extends StatefulWidget {
  const SetProfilePage({Key key}) : super(key: key);

  @override
  _SetProfilePageState createState() => _SetProfilePageState();
}

class _SetProfilePageState extends State<SetProfilePage> {
  File _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("프로필 설정"),
        centerTitle: true,
      ),
      body:
      WillPopScope(
        onWillPop: _onBackPressed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: Padding(
                padding: const EdgeInsets.all(common_llll_gap),
                child: InkWell(
                  onTap: () async{
                    print("프로필 변경");
                    final _picker = ImagePicker();
                    final pickedFile = await _picker.getImage(source:  ImageSource.gallery);
                    setState(() {
                      _image = File(pickedFile.path);
                    });
                  },
                  child:  Stack(
                    children: [
                      _image==null?CircleAvatar(
                        radius: (iconsize_large_profile*screenSizeFactor)/2,
                        backgroundColor: greyC4C4C4,
                        child:
                         Image.asset('assets/images/profile_img.png', width: iconsize_large_profile*screenSizeFactor*0.8,
                          height:iconsize_large_profile*screenSizeFactor*0.8,),
                      ):
                          ClipOval(
                          child: Image.file(
                          _image,
                          fit: BoxFit.cover,
                          width: iconsize_large_profile*screenSizeFactor,
                          height: iconsize_large_profile*screenSizeFactor,
                        ),
                      ),



                    /*  Image.file(_image, width: iconsize_large_profile*screenSizeFactor*0.8,
                        height:iconsize_large_profile*screenSizeFactor*0.8,),*/

                      SizedBox(
                        width: iconsize_large_profile*screenSizeFactor,
                        height: iconsize_large_profile*screenSizeFactor,
                        child: Align(
                            alignment: Alignment(0.9, 0.9),
                            child: Icon(CupertinoIcons.pencil_circle_fill)),
                      )
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: common_main_gap),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(

                    ),
                  ),
                  Container(
                    child: Text("중복확인"),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: common_main_gap),
              child: Text("사용가능한 닉네임입니다✓", style: TextStyle(color: green12D26B),),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal : common_main_gap, vertical: common_lll_gap),
              child: InkWell(
                onTap: (){
                  Get.to(EnrollFamilyPage());
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5*screenSizeFactor),
                      color: grey868181
                  ),
                  width: double.maxFinite,
                  height: 40*screenSizeFactor,
                  child: Center(child: Text("다음")),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Future<bool> _onBackPressed() {
    return cancelEnroll();
  }
}
