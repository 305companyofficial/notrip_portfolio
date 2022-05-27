import 'package:flutter/material.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/material_color.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({Key key}) : super(key: key);

  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  var _boolList = List.generate(10, (index) => false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("자주 하는 질문"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(10, (index) => Column(
            children: [
              InkWell(
                  onTap: (){
                    print("클릭 $index");
                    setState(() {
                      _boolList[index] = ! _boolList[index];
                    });
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(common_main_gap),
                        child: SizedBox(
                            width: double.maxFinite,
                            child: Row(
                              children: [
                                Text("안녕하세요"),
                                Spacer(),
                                Icon(  _boolList[index]? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down_outlined)
                              ],
                            )),
                      ),
                      Divider(height: 1, thickness: 1,)
                    ],
                  )),
              Visibility(
                  visible: _boolList[index],
                  child: Container(
                      padding: const EdgeInsets.all(common_main_gap),
                    width: double.maxFinite,
                      color: greyF1F1F1,
                      child: Text("봄날의 황금시대의 그들은 속에서 있다. 때까지 스며들어 든 철환하였는가? 피에 넣는 바로 그들을 위하여서. 날카로우나 가슴이 밥을 아니더면, 위하여서 피다. 미인을 이상의 할지라도 것이 피는 싹이 유소년에게서 것이다. 따뜻한 없는 너의 꽃 새 그들은 것이다. 바로 방황하여도, 따뜻한 운다. 끓는 석가는 할지라도 청춘에서만 되려니와, 창공에 피다. 주는 커다란 가치를 그들의 "
                      )))
            ],
          )

          ),
        ),
      ),
    );
  }
}
