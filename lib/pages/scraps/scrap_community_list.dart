import 'package:flutter/material.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/material_color.dart';

class ScrapCommunityList extends StatelessWidget {
  const ScrapCommunityList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(10, (index) =>
          Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(common_main_gap),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 85,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("커뮤니티제목$index", style: TextStyle(fontWeight: FontWeight.bold),),
                          Text("내용 내용 내용 내용 내용 내용 내용 내용 내용 내용 내용 내용  $index",
                            overflow: TextOverflow.ellipsis,),
                          Spacer(),
                          Text("김여행  2021.08.21",style: TextStyle(color: grey868181),),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
              Divider(
                thickness: 1,
                height: 1,
              )
            ],
          )
      ),
    );;
  }
}
