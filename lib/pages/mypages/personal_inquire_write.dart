import 'package:flutter/material.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/material_color.dart';

class PersonalInquireWrite extends StatefulWidget {
  const PersonalInquireWrite({Key key}) : super(key: key);

  @override
  _PersonalInquireWriteState createState() => _PersonalInquireWriteState();
}

class _PersonalInquireWriteState extends State<PersonalInquireWrite> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(common_main_gap),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("제목"),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: common_ss_gap),
                  child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: const EdgeInsets.all(common_ss_gap),
                        hintText: "문의합니다.",)
                  ),
                ),
                SizedBox(height: 15,),
                Text("내용"),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: common_ss_gap),
                  child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: const EdgeInsets.all(common_ss_gap),
                        hintText: "내용을 입력해주세요.",),
                    maxLines: 7,
                    minLines: 7,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(common_main_gap,common_main_gap,common_main_gap,0),
            child: InkWell(
              child: Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: yellowFFE000,
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(common_gap),
                  child: Center(child: Text("다음")),
                ),
              ),
            ),
          ),
          SizedBox(height: 24,),
          Divider(
            thickness: 7,
            height: 7,
          ),
          Padding(
            padding: const EdgeInsets.all(common_main_gap),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("도움이 필요하신가요?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                SizedBox(height: 16,),
                Text("1644-1234", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                Text("오전9시 ~ 오후 6시(월-금)", style: TextStyle(color: greyCCCCCC),),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
