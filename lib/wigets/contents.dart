import 'package:flutter/material.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/material_color.dart';
import 'package:notrip/controllers/api_data_controller.dart';
import 'package:notrip/models/community_model.dart';
import 'package:notrip/tools/times.dart';
import 'package:notrip/wigets/round_wigets.dart';

SizedBox headerWidget(CommunityModel communityModel, BuildContext context, {Widget dotbutton1,}) {
  return SizedBox(
    height: 80,
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: common_s_gap),
          child: networkCircleImg(imgurl: "https://picsum.photos/200",
              imgsize: iconsize_ll*screenSizeFactor, replaceicon: Icons.person),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15,),
            Text(communityModel.subject, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            maxLines: 1,
            ),
            SizedBox(height: 5,),
            Text(communityModel.nickName +" · "+printSavedDate(communityModel.createdAt),  style: TextStyle(color: greyB2B2B2, fontSize: 13))
          ],
        ),
        Spacer(),
        Align(
            alignment: Alignment.topCenter,
            child: dotbutton1==null? SizedBox.shrink():dotbutton1)
      ],
    ),
  );
}