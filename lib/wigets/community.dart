import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/logger.dart';
import 'package:notrip/constants/string_address.dart';
import 'package:notrip/interface/dialog.dart';
import 'package:notrip/models/community_model.dart';

class BottomProgressBar extends StatelessWidget {
  const BottomProgressBar({
    Key key,
    @required this.totalElements,
    @required this.nextCommentIdx,
    @required this.communityCommentSize,
  }) : super(key: key);

  final int totalElements;
  final int nextCommentIdx;
  final int communityCommentSize;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: totalElements>= nextCommentIdx*communityCommentSize,
      child: Center(child: Padding(
        padding: const EdgeInsets.all(common_s_gap),
        child: CircularProgressIndicator(),
      )),
    );
  }
}

class MyCommunityDotButton extends StatelessWidget {
   MyCommunityDotButton(this._communityModel,  this.modifyfunction, this.deletefunction, this.sharefunction, {Key key}) : super(key: key);
   CommunityModel _communityModel;
   Function modifyfunction;
   Function deletefunction;
   Function sharefunction;
   @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          await showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) => CupertinoActionSheet(
              // title: const Text('Title'),
                message: const Text('내가 쓴 글'),
                actions: <CupertinoActionSheetAction>[
                    CupertinoActionSheetAction(
                    child: const Text(
                      '공유하기',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {
                      logger.d("${_communityModel.id} 공유하기");
                      Get.back();
                      sharefunction( _communityModel);
                    },
                  ),

                  CupertinoActionSheetAction(
                    child: const Text(
                      '수정하기',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {
                      print("${_communityModel.id} 수정하기");
                      Get.back();
                      modifyfunction( _communityModel);
                    },
                  ),
                  CupertinoActionSheetAction(
                    child: const Text(
                      '삭제하기',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      Get.back();
                      deletefunction( _communityModel);
                    },
                  ),
                  /* CupertinoActionSheetAction(
                child: const Text('Action Two'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )*/
                ],
                cancelButton: cancelActionSheetAction()),
          );
        }, icon: Icon(Icons.more_vert));
  }

}
CupertinoActionSheetAction cancelActionSheetAction() {
  return CupertinoActionSheetAction(
    child: const Text(
      '취소',
      style: TextStyle(color: Colors.blue),
    ),
    isDefaultAction: true,
    onPressed: () {
      //returnValue = false;
      Get.back();
    },
  );
}

class OtherCommunityDotButton extends StatelessWidget {
   OtherCommunityDotButton(this._communityModel, this.reportfunction, this.sharefunction, {Key key}) : super(key: key);
   Function reportfunction;
   CommunityModel _communityModel;
   Function sharefunction;
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          await showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) => CupertinoActionSheet(
              // title: const Text('Title'),
                message:  Text('${_communityModel.nickName}이 쓴 글'),
                actions: <CupertinoActionSheetAction>[
                  CupertinoActionSheetAction(
                    child: const Text(
                      '공유하기',
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {
                      logger.d("${_communityModel.id} 공유하기");
                      Get.back();
                      sharefunction( _communityModel);
                    },
                  ),
                  CupertinoActionSheetAction(
                    child: const Text(
                      '신고하기',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () async{
                      logger.d("신고하기");
                      Get.back();
                      reportfunction( _communityModel);
                    },
                  ),
                ],
                cancelButton: cancelActionSheetAction()),
          );
        }, icon: Icon(Icons.more_vert));
  }
}

