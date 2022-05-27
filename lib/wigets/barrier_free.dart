import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/logger.dart';
import 'package:notrip/constants/material_color.dart';
import 'package:notrip/pages/barrier_free/barrier_free_page.dart';

class BarrierFreeWidget extends StatelessWidget {
  const BarrierFreeWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(common_main_gap),
        child: InkWell(
          onTap: (){
            logger.d('배리어 프리 클릭');
            Get.to(BarrierFreePage());
          },
          child: Ink(
            padding: const EdgeInsets.fromLTRB(common_gap, common_gap, common_s_gap,common_s_gap),
            decoration: BoxDecoration(
                color: yellowFFE000,
                borderRadius: BorderRadius.circular(5)
            ),
            width: double.maxFinite,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("배리어프리",style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                    SizedBox(height: common_ss_gap,),
                    Text("편리시설정보찾기", style: TextStyle(fontSize: 14, color: grey666666),),
                    SizedBox(height: common_s_gap,),
                  ],
                ),
                SizedBox(width: common_s_gap,),
                Expanded(child: Column(
                  children: [
                    SizedBox(height: common_s_gap,),
                    Image.asset('assets/images/barrier_free_img.png'),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
