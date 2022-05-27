import 'package:flutter/material.dart';
import 'package:notrip/constants/material_color.dart';
import 'package:notrip/pages/mypages/personal_inquire_list.dart';
import 'package:notrip/pages/mypages/personal_inquire_write.dart';

class PersonalInquirePage extends StatefulWidget {
  const PersonalInquirePage({Key key}) : super(key: key);

  @override
  _PersonalInquirePageState createState() => _PersonalInquirePageState();
}

class _PersonalInquirePageState extends State<PersonalInquirePage> with SingleTickerProviderStateMixin {
  //TabController _tabController;
  var tabtext = ["문의작성", "답변 내용"];
  var tabindex = 0;
  @override
  void initState() {
    super.initState();
    //_tabController = new TabController(initialIndex: 0, vsync: this, length: tabtext.length);
  }
  @override
  void dispose() {
   // _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title: Text('1:1 문의하기'),
      ),
      // TabVarView 구현. 각 탭에 해당하는 컨텐트 구성
      body: Container(
        color: Colors.white,
        child: DefaultTabController(
          length: tabtext.length,
          child: Column(
            children: <Widget>[
              Container(
                constraints: BoxConstraints.expand(height: 50),
                child: TabBar(tabs:
                List.generate(tabtext.length, (index) => Tab(child: Text(tabtext[index],
                  style: TextStyle(fontWeight: FontWeight.bold,
                  color: tabindex == index ? Colors.black87 : greyCCCCCC
                  ),),),),
                 // controller: _tabController,
               onTap: (index){
                  setState(() {
                    tabindex = index;
                  });

               },
               /* [
                  Tab(child: Text("문의작성", style: TextStyle(fontWeight: FontWeight.bold),),),
                  Tab(child: Text("답변 내용", style: TextStyle(fontWeight: FontWeight.bold),),),
                ],*/
                  indicatorColor: Colors.yellow,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 4,
                ),
              ),
              Divider(thickness: 1, height: 1,),
              Expanded(
                child: Container(
                  child: TabBarView(children: [
                    PersonalInquireWrite(),
                    PersonalInquireList(),
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
