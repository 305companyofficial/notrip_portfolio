import 'package:flutter/material.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/wigets/round_wigets.dart';

class SettingFamily extends StatefulWidget {
  const SettingFamily({Key key}) : super(key: key);

  @override
  _SettingFamilyState createState() => _SettingFamilyState();
}

class _SettingFamilyState extends State<SettingFamily> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("연결된 가족계정"),
      actions: [
        IconButton(onPressed: (){}, icon: Text("편집"))
      ],
      ),
      body: Column(
        children: [
         _familyWidget(),
        ],
      ),
    );
  }

  Widget _familyWidget() => Row(
    children: [
      Padding(
        padding: const EdgeInsets.all(common_gap),
        child: networkCircleImg(imgurl: "https://picsum.photos/200",
            imgsize: iconsize_lll*screenSizeFactor, replaceicon: Icons.person),
      ),
    ],

  );
}
