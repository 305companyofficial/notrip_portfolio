import 'package:flutter/material.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/material_color.dart';

class ScrapLocationList extends StatelessWidget {
  const ScrapLocationList({Key key}) : super(key: key);

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
                  SizedBox(
                    height: 85,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("장소이름$index", style: TextStyle(fontWeight: FontWeight.bold),),
                        Text("소제목$index"),
                        Spacer(),
                        Text("영업시간08:00~24:00",style: TextStyle(color: grey868181),),
                      ],
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
