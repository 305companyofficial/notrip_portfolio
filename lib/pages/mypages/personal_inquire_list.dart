import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/material_color.dart';

class PersonalInquireList extends StatefulWidget {
  const PersonalInquireList({Key key}) : super(key: key);

  @override
  _PersonalInquireListState createState() => _PersonalInquireListState();
}

class _PersonalInquireListState extends State<PersonalInquireList> {
  var _showmore = List.generate(10, (index) => false);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(_showmore.length, (index) =>
            Column(
              children: [
                InkWell(
                  onTap: (){
                   setState(() {
                     _showmore[index] = !_showmore[index];
                   });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(common_main_gap),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("문의합니다.", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                            Spacer(),
                            Text("2021-10-01", style: TextStyle(fontSize: 14, color: greyB7B7B7),),
                          ],
                        ),
                        SizedBox(height: 15,),
                        Text("어떻게 쓰는거에요?"),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Text("답변완료", style: TextStyle(color: greyC4C4C4),),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: common_ss_gap),
                              child: Container(
                                //padding: EdgeInsets.symmetric(horizontal: common_s_gap),
                                width: 1, height: 10,
                                color: Colors.grey,
                              ),
                            ),
                            deleteButton(context),
                            Spacer(),
                            Icon(!_showmore[index] ? Icons.expand_more : Icons.expand_less)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: _showmore[index],
                  child: Container(
                    padding: EdgeInsets.all(common_gap),
                    color: greyECECEC,
                    width: double.maxFinite,
                    child: Column(
                      children: [
                        SizedBox(
                            width: double.maxFinite,
                            child: Text("2021-10-02", textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 14,color: greyB7B7B7),
                            )),
                        SizedBox(height: 15,),
                        Text("국회는 국정을 감사하거나 특정한 국정사안에 대하여 조사할 수 있으며, "
                            "이에 필요한 서류의 제출 또는 증인의 출석과 증언이나 의견의 진술을 요구할 수 있다.",
                        style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  height: 1,
                )
              ],
            )
        ),
      ),
    );
  }

  Widget  deleteButton(BuildContext context) {
    return InkWell(
            onTap: () async{
              await showCupertinoModalPopup<void>(
              context: context,
              builder: (BuildContext context) => CupertinoActionSheet(
              // title: const Text('Title'),
              message: const Text('해당 문의를 삭제하시겠습니까?\n삭제하시면 답변도 함께 삭제되며 복구되지 않습니다.'),
              actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
              child: const Text('삭제하기', style: TextStyle(color: Colors.red),),
              onPressed: () {
              Get.back();
              },
              ),
                                /* CupertinoActionSheetAction(
              child: const Text('Action Two'),
              onPressed: () {
                Navigator.pop(context);
              },
            )*/
            ],
            cancelButton: CupertinoActionSheetAction(
            child: const Text('취소', style: TextStyle(color: Colors.blue),),
            isDefaultAction: true,
            onPressed: () {
            //returnValue = false;
            Get.back();
            },
            )
            ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(common_ss_gap),
            child: Text("삭제"),
          ));
  }
}
