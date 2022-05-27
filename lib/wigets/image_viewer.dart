import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notrip/constants/common_size.dart';
import 'package:notrip/constants/string_address.dart';
import 'package:notrip/models/community_model.dart';
import 'package:notrip/tools/times.dart';
import 'package:notrip/wigets/round_wigets.dart';

class ImageViewer extends StatefulWidget {
  ImageViewer(this._imagesModels, this.writerNickname, this.writeTime,  {this.initImgIndex,  Key key}) : super(key: key);
  List<Images> _imagesModels;
  String writerNickname;
  String writeTime;
  int initImgIndex;
  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  //TimeTools _timeTools = TimeTools();
  var tabvisibility = true;
  var imageindex= -1;
  PageController _pageController;
  @override
  void initState() {
    imageindex = widget.initImgIndex;
    _pageController = PageController(initialPage: imageindex);
    _pageController.addListener(() {
    setState(() {
      imageindex = _pageController.page.toInt();
    });
    });
    super.initState();

  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: _pageController,
         children: List.generate(widget._imagesModels.length, (index) => Container(
           width: double.maxFinite,
           height: double.maxFinite,
           child: GestureDetector(
             onTap: (){
               print('클릭!');
               setState(() {
                 tabvisibility = !tabvisibility;
               });
             },
             child: Hero(
               tag: widget._imagesModels[imageindex].id,
               child: ExtendedImage.network(
                 "$mainUrl$imageStoragePath${widget._imagesModels[index].path}",
                 fit: BoxFit.contain,
                 cache: true,
                 //enableLoadState: false,
                 mode: ExtendedImageMode.gesture,
                 initGestureConfigHandler: (state) {
                   return GestureConfig(
                     minScale: 1,
                     animationMinScale: 0.8,
                     maxScale: 5.0,
                     animationMaxScale: 6,
                     speed: 1.0,
                     inertialSpeed: 5.0,
                     initialScale: 1.0,
                     inPageView: true,
                     initialAlignment: InitialAlignment.center,
                   );
                 },

               ),
             ),
           ),
         )),
        ),
        Visibility(
          visible: tabvisibility,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                child: AppBar(
                  centerTitle: true,
                  leading: IconButton(icon: Icon(Icons.close, color: Colors.white,),
                    onPressed: ()=> Get.back(),),
                  backgroundColor: Colors.black87,
                  title: Text('${imageindex+1}/${widget._imagesModels.length}', style: TextStyle(color: Colors.white),),
                ),
              ),
              Material(
                color: Colors.black87,
                child: InkWell(
                  onTap: (){
                   // Get.to(GalleryDetail(), transition: Transition.rightToLeft);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: common_s_gap),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(common_s_gap),
                          child: networkCircleImg(imgurl: "https://picsum.photos/200", imgsize: 30, replaceicon: Icons.person),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.writerNickname, style: TextStyle(color: Colors.white),),
                              Text(printSavedDate(widget.writeTime),
                                style: TextStyle(color: Colors.grey[400], fontSize:fontsize_s, fontWeight: FontWeight.w300
                                ),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )

      ],
    );
  }
}
